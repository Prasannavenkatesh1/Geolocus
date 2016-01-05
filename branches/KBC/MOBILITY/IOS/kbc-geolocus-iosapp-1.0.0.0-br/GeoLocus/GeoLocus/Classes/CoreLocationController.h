//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"
#import <sqlite3.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>

@class GeoLocusViewController;

@protocol CoreLocationControllerDelegate
@required

- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;

@end


@interface CoreLocationController : NSObject <CLLocationManagerDelegate> {
    //    GeoLocusAppDelegate *appDelegate;
    
	CLLocationManager *locMgr;
	id delegate;
    CLLocationSpeed speed;
    NSTimer *timer;
    CLLocation *locationForHeading;
    
    //DB
    FMDatabase *db;
    NSString *defaultDBPath;
    NSString *dbPath;
    NSString *collectionInterval;
    int collectIntervalValue;
    
    NSString *databasePath;
    FMDatabase *dataCollectDb;
    
/*    // to store data locally
    NSString *storeDataPath;
    FMDatabase *storeDataDb;
 */
    
    // for speed calculation
    
    float fltDistanceTravelled;
    double creationTime;
    double postTime;
    NSString *deviceUniqueId;
    NSString *distance;
    
    NSString *motionType;
    
    GeoLocusViewController *autoStopController;
    
    NSMutableArray *speedArray;
    NSMutableArray *locSpeedArray;

    NSDictionary *settingsData;
    NSString *voicsStatus;

    //for iPod music player
    MPMusicPlayerController *iPodMusicPlayer;
    AVAudioSession *audioSession;

}

@property (nonatomic, strong) CLLocationManager *locMgr;
@property (nonatomic, strong) id delegate;
@property (nonatomic,retain)  NSTimer *timer;
@property (strong, nonatomic) CLLocation* lastLocation;
@property (nonatomic) CLLocationCoordinate2D lastCoordinate;
@property (nonatomic, strong) GeoLocusViewController *autoStopController;
@property (nonatomic, copy) NSString *motionType;
@property (readwrite, assign) float fltDistanceTravelled;
@property (nonatomic, strong) NSMutableArray *speedArray;
@property (nonatomic, strong) NSMutableArray *locSpeedArray;


-(float)getDistanceInKm:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;
-(float)getDistanceInMiles:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

@end
