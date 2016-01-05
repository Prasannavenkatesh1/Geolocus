//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManager.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreMotion/CMMotionManager.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface SendingEmergencyInfo : UIViewController
{
    FMDatabase *db;
    NSString *defaultDBPath;
    NSString *dbPath;
    NSString *latitude;
    NSString *longitude;
    
    NSString *voiceStatus;
    
    MPMusicPlayerController *iPodMusicPlayer;
    AVAudioSession *audioSession;
}

- (void)viewDidLoad;

- (void)showEmail;

-(void)sendEmergency;

@property (readwrite, strong) CMMotionManager* motionManager;

@end


