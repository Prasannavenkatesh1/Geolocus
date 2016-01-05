//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "FMDatabase.h"
#import "GeoLocusViewController.h"

@implementation AppDelegate


@synthesize globalAutoTrip;
@synthesize deviceId;
@synthesize countryCode;
@synthesize speedLimit;
@synthesize avgSum;
@synthesize vAlert;

- (id)init
{
    globalAutoTrip = NO;
    NSLog(@"%d",globalAutoTrip);

    
    deviceId = nil;
    countryCode = nil;
    speedLimit = 0.0;
    avgSum = 0.0;
    vAlert = nil;
    
    /** If you need to do any extra app-specific initialization, you can do it here
     *  -jm
     **/
    NSHTTPCookieStorage* cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    [cookieStorage setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyAlways];

    int cacheSizeMemory = 8 * 1024 * 1024; // 8MB
    int cacheSizeDisk = 32 * 1024 * 1024; // 32MB
#if __has_feature(objc_arc)
        NSURLCache* sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"];
#else
        NSURLCache* sharedCache = [[[NSURLCache alloc] initWithMemoryCapacity:cacheSizeMemory diskCapacity:cacheSizeDisk diskPath:@"nsurlcache"] autorelease];
#endif
    [NSURLCache setSharedURLCache:sharedCache];

    self = [super init];
    return self;
}


- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    // iPhone doesn't support upside down by default, while the iPad does.  Override to allow all orientations always, and let the root view controller decide what's allowed (the supported orientations mask gets intersected).
    NSUInteger supportedInterfaceOrientations = (1 << UIInterfaceOrientationPortrait) | (1 << UIInterfaceOrientationLandscapeLeft) | (1 << UIInterfaceOrientationLandscapeRight) | (1 << UIInterfaceOrientationPortraitUpsideDown);

    return supportedInterfaceOrientations;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication*)application
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //send trip end event before closing the app
    GeoLocusViewController *settingController = [[GeoLocusViewController alloc]init];
    [settingController stopServices];
}

// set up Audio so that user can play own music
-(void)iniAudio {
    
    AudioSessionInitialize(NULL, NULL, nil , nil);
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error: nil];
    
    UInt32 doSetProperty = 1;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
    
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
}

@end
