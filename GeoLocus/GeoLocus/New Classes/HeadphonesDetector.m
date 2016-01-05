//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "HeadphonesDetector.h"
#import "AudioToolbox/AudioToolbox.h"

static HeadphonesDetector *headphonesDetector;

@implementation HeadphonesDetector

void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, 
									   UInt32 inPropertyValueSize, const void *inPropertyValue);

@synthesize delegate;
@dynamic headphonesArePlugged;


+ (HeadphonesDetector *) sharedDetector {
	if (headphonesDetector == nil) {
		headphonesDetector = [ [self alloc] init];
	}
	return headphonesDetector;
}

- (BOOL) headphonesArePlugged {
	BOOL result = NO;
	CFStringRef route;
	UInt32 propertySize = sizeof(CFStringRef);
	if (AudioSessionGetProperty(kAudioSessionProperty_AudioRoute, &propertySize, &route) == 0)	{
		NSString *routeString = (__bridge NSString *) route;
		if ([routeString isEqualToString: @"Headphone"] == YES) {
			result = YES;
		}
	}
	return result;
}

- (id) init {
	if (self = [super init]) {
		AudioSessionInitialize(NULL, NULL, NULL, NULL);
		AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, (__bridge void *)(self));
		
		return self;
	}
	return nil;
}

- (void) dealloc {
	self.delegate = nil;
	
	//[super dealloc];
}

void audioRouteChangeListenerCallback (void *inUserData, AudioSessionPropertyID inPropertyID, 
									   UInt32 inPropertyValueSize, const void *inPropertyValue) {
	CFDictionaryRef routeChangeDictionary = inPropertyValue;
	CFNumberRef routeChangeReasonRef = CFDictionaryGetValue (routeChangeDictionary, CFSTR(kAudioSession_AudioRouteChangeKey_Reason));
	SInt32 routeChangeReason;
	CFNumberGetValue(routeChangeReasonRef, kCFNumberSInt32Type, &routeChangeReason);
	
	if (routeChangeReason == kAudioSessionRouteChangeReason_OldDeviceUnavailable ||
		routeChangeReason == kAudioSessionRouteChangeReason_NewDeviceAvailable) {
		HeadphonesDetector *headphonesDetector = (__bridge HeadphonesDetector *) inUserData;
		if ([headphonesDetector.delegate respondsToSelector: @selector(headphonesDetectorStateChanged:) ]) {
			[headphonesDetector.delegate headphonesDetectorStateChanged: headphonesDetector];
		}
	}
}

@end