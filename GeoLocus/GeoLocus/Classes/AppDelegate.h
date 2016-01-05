//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <UIKit/UIKit.h>


@interface AppDelegate : NSObject <UIApplicationDelegate>{

    BOOL globalAutoTrip;
    NSString *deviceId;
    NSString *countryCode;
    float speedLimit;
    float avgSum;
    NSString *vAlert;
}

// invoke string is passed to your app on launch, this is only valid if you
// edit Activity1-Info.plist to add a protocol
// a simple tutorial can be found here :
// http://iphonedevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html

@property (nonatomic, strong) IBOutlet UIWindow* window;
@property (nonatomic, assign) BOOL globalAutoTrip;
@property (nonatomic, retain) NSString *deviceId;
@property (nonatomic, retain) NSString *countryCode;
@property (nonatomic, retain) NSString *vAlert;
@property (readwrite, assign) float speedLimit;
@property (readwrite, assign) float avgSum;

//@property (nonatomic, assign) BOOL isSwitchState;

@end
