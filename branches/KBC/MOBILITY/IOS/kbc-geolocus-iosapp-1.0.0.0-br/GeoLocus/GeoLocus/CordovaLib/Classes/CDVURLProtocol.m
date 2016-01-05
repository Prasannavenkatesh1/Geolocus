/*
 Licensed to the Apache Software Foundation (ASF) under one
 or more contributor license agreements.  See the NOTICE file
 distributed with this work for additional information
 regarding copyright ownership.  The ASF licenses this file
 to you under the Apache License, Version 2.0 (the
 "License"); you may not use this file except in compliance
 with the License.  You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing,
 software distributed under the License is distributed on an
 "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 KIND, either express or implied.  See the License for the
 specific language governing permissions and limitations
 under the License.
 */

#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CDVURLProtocol.h"
#import "CDVCommandQueue.h"
#import "CDVWhitelist.h"
#import "CDVViewController.h"
#import "CDVFile.h"

@interface CDVHTTPURLResponse : NSHTTPURLResponse
@property (nonatomic) NSInteger statusCode;
@end

static CDVWhitelist* gWhitelist = nil;
// Contains a set of NSNumbers of addresses of controllers. It doesn't store
// the actual pointer to avoid retaining.
static NSMutableSet* gRegisteredControllers = nil;

// Returns the registered view controller that sent the given request.
// If the user-agent is not from a UIWebView, or if it's from an unregistered one,
// then nil is returned.
static CDVViewController *viewControllerForRequest(NSURLRequest* request)
{
    // The exec bridge explicitly sets the VC address in a header.
    // This works around the User-Agent not being set for file: URLs.
    NSString* addrString = [request valueForHTTPHeaderField:@"vc"];

    if (addrString == nil) {
        NSString* userAgent = [request valueForHTTPHeaderField:@"User-Agent"];
        if (userAgent == nil) {
            return nil;
        }
        NSUInteger bracketLocation = [userAgent rangeOfString:@"(" options:NSBackwardsSearch].location;
        if (bracketLocation == NSNotFound) {
            return nil;
        }
        addrString = [userAgent substringFromIndex:bracketLocation + 1];
    }

    long long viewControllerAddress = [addrString longLongValue];
    @synchronized(gRegisteredControllers) {
        if (![gRegisteredControllers containsObject:[NSNumber numberWithLongLong:viewControllerAddress]]) {
            return nil;
        }
    }

    return (__bridge CDVViewController*)(void*)viewControllerAddress;
}

@implementation CDVURLProtocol

+ (void)registerPGHttpURLProtocol {}

+ (void)registerURLProtocol {}

// Called to register the URLProtocol, and to make it away of an instance of
// a ViewController.
+ (void)registerViewController:(CDVViewController*)viewController
{
    if (gRegisteredControllers == nil) {
        [NSURLProtocol registerClass:[CDVURLProtocol class]];
        gRegisteredControllers = [[NSMutableSet alloc] initWithCapacity:8];
        // The whitelist doesn't change, so grab the first one and store it.
        gWhitelist = viewController.whitelist;

        // Note that we grab the whitelist from the first viewcontroller for now - but this will change
        // when we allow a registered viewcontroller to have its own whitelist (e.g InAppBrowser)
        // Differentiating the requests will be through the 'vc' http header below as used for the js->objc bridge.
        //  The 'vc' value is generated by casting the viewcontroller object to a (long long) value (see CDVViewController::webViewDidFinishLoad)
        if (gWhitelist == nil) {
            NSLog(@"WARNING: NO whitelist has been set in CDVURLProtocol.");
        }
    }

    @synchronized(gRegisteredControllers) {
        [gRegisteredControllers addObject:[NSNumber numberWithLongLong:(long long)viewController]];
    }
}

+ (void)unregisterViewController:(CDVViewController*)viewController
{
    @synchronized(gRegisteredControllers) {
        [gRegisteredControllers removeObject:[NSNumber numberWithLongLong:(long long)viewController]];
    }
}

+ (BOOL)canInitWithRequest:(NSURLRequest*)theRequest
{
    NSURL* theUrl = [theRequest URL];
    CDVViewController* viewController = viewControllerForRequest(theRequest);

    if ([[theUrl absoluteString] hasPrefix:kCDVAssetsLibraryPrefix]) {
        return YES;
    } else if (viewController != nil) {
        if ([[theUrl path] isEqualToString:@"/!gap_exec"]) {
            NSString* queuedCommandsJSON = [theRequest valueForHTTPHeaderField:@"cmds"];
            NSString* requestId = [theRequest valueForHTTPHeaderField:@"rc"];
            if (requestId == nil) {
                NSLog(@"!cordova request missing rc header");
                return NO;
            }
            BOOL hasCmds = [queuedCommandsJSON length] > 0;
            if (hasCmds) {
                SEL sel = @selector(enqueCommandBatch:);
                [viewController.commandQueue performSelectorOnMainThread:sel withObject:queuedCommandsJSON waitUntilDone:NO];
            } else {
                SEL sel = @selector(maybeFetchCommandsFromJs:);
                [viewController.commandQueue performSelectorOnMainThread:sel withObject:[NSNumber numberWithInteger:[requestId integerValue]] waitUntilDone:NO];
            }
            // Returning NO here would be 20% faster, but it spams WebInspector's console with failure messages.
            // If JS->Native bridge speed is really important for an app, they should use the iframe bridge.
            // Returning YES here causes the request to come through canInitWithRequest two more times.
            // For this reason, we return NO when cmds exist.
            return !hasCmds;
        }
        // we only care about http and https connections.
        // CORS takes care of http: trying to access file: URLs.
        if ([gWhitelist schemeIsAllowed:[theUrl scheme]]) {
            // if it FAILS the whitelist, we return TRUE, so we can fail the connection later
            return ![gWhitelist URLIsAllowed:theUrl];
        }
    }

    return NO;
}

+ (NSURLRequest*)canonicalRequestForRequest:(NSURLRequest*)request
{
    // NSLog(@"%@ received %@", self, NSStringFromSelector(_cmd));
    return request;
}

- (void)startLoading
{
    // NSLog(@"%@ received %@ - start", self, NSStringFromSelector(_cmd));
    NSURL* url = [[self request] URL];

    if ([[url path] isEqualToString:@"/!gap_exec"]) {
        [self sendResponseWithResponseCode:200 data:nil mimeType:nil];
        return;
    } else if ([[url absoluteString] hasPrefix:kCDVAssetsLibraryPrefix]) {
        ALAssetsLibraryAssetForURLResultBlock resultBlock = ^(ALAsset* asset) {
            if (asset) {
                // We have the asset!  Get the data and send it along.
                ALAssetRepresentation* assetRepresentation = [asset defaultRepresentation];
                NSString* MIMEType = (__bridge_transfer NSString*)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)[assetRepresentation UTI], kUTTagClassMIMEType);
                Byte* buffer = (Byte*)malloc([assetRepresentation size]);
                NSUInteger bufferSize = [assetRepresentation getBytes:buffer fromOffset:0.0 length:[assetRepresentation size] error:nil];
                NSData* data = [NSData dataWithBytesNoCopy:buffer length:bufferSize freeWhenDone:YES];
                [self sendResponseWithResponseCode:200 data:data mimeType:MIMEType];
            } else {
                // Retrieving the asset failed for some reason.  Send an error.
                [self sendResponseWithResponseCode:404 data:nil mimeType:nil];
            }
        };
        ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError* error) {
            // Retrieving the asset failed for some reason.  Send an error.
            [self sendResponseWithResponseCode:401 data:nil mimeType:nil];
        };

        ALAssetsLibrary* assetsLibrary = [[ALAssetsLibrary alloc] init];
        [assetsLibrary assetForURL:url resultBlock:resultBlock failureBlock:failureBlock];
        return;
    }

    NSString* body = [gWhitelist errorStringForURL:url];
    [self sendResponseWithResponseCode:401 data:[body dataUsingEncoding:NSASCIIStringEncoding] mimeType:nil];
}

- (void)stopLoading
{
    // do any cleanup here
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest*)requestA toRequest:(NSURLRequest*)requestB
{
    return NO;
}

- (void)sendResponseWithResponseCode:(NSInteger)statusCode data:(NSData*)data mimeType:(NSString*)mimeType
{
    if (mimeType == nil) {
        mimeType = @"text/plain";
    }
    NSString* encodingName = [@"text/plain" isEqualToString : mimeType] ? @"UTF-8" : nil;
    CDVHTTPURLResponse* response =
        [[CDVHTTPURLResponse alloc] initWithURL:[[self request] URL]
                                       MIMEType:mimeType
                          expectedContentLength:[data length]
                               textEncodingName:encodingName];
    response.statusCode = statusCode;

    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    if (data != nil) {
        [[self client] URLProtocol:self didLoadData:data];
    }
    [[self client] URLProtocolDidFinishLoading:self];
}

@end

@implementation CDVHTTPURLResponse
@synthesize statusCode;

- (NSDictionary*)allHeaderFields
{
    return nil;
}

@end
