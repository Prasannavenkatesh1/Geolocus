//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Reachability.h"
#import "HeadphonesDetector.h"
#import "SettingsEntity.h"

@interface GeoLocusViewController : UIViewController <CoreLocationControllerDelegate,NSStreamDelegate,UIAlertViewDelegate>
{
    FMDatabase *db;
    FMDatabaseQueue *queue;
    FMDatabaseQueue *postQueue;
    
    NSString *defaultDBPath;
    NSString *dbPath;
    
    // For data posting
    
    FMDatabase *dbDataPosting;
    NSString *defaultDBPathForPosting;
    NSString *dbPathForPOsting;
    
    // to store data locally
     NSString *localDataPath;
     FMDatabase *storeDataDb;
    NSMutableArray *tempArray;
    NSDictionary *localDBDictionary;

    
    CoreLocationController *CLController;
	IBOutlet UILabel *speedLabel;
    
    NSMutableArray *dataArray;
    //    NSMutableArray *dataValArray;
    NSString * jsonString;
    NSString *finalJsonString;
    
    CFWriteStreamRef writeStream;
    CFReadStreamRef readStream;
    double creationTime;
    double postTime;
    int totalDistance;
    int batteryLbl;
    NSString *ck;
    double latitude;
    double longitude;
    int altitude;
    int hAccuracy;
    int vAccuracy;
    NSString *deviceUniqueId;
    int speed;
    int acceleration;
    float breakingVal;
    NSString *heading;
    
    NSString *dbhostName;
    NSString *dbPort;
    NSString *transmissionInterval;
    NSString *collectionInterval;
    NSString *provider;
    NSString *notifyDistance;
    NSString *notifyTime;
    NSString *dataUploadType;
    
    //    NSTimer *transmissionTimer;
    //    NSTimer *collectionTimer;
    int transIntervalValue;
    int collectIntervalValue;
    int distanceNotifyValue;
    
    NSRunLoop* runLoopDataPosting;
    NSRunLoop* runLoopDataCollection;
    
    UISwitch *startStopSwitch;
    
    Reachability *internetReachable;
    BOOL startEventState;
    NSString *startEventJson;
    NSString *stopEventJson;
    NSString *switchState;
    int tripEndDataSendCount;
    double startEventTime;
    NSString *startEvent;
    NSString *localEventAlert;
    
    UIAlertView *alerViewHeadPhone;
    
    NSString *headPhoneStatus;
    NSString *callStatus;
    NSString *inOrOutCall;
    
    NetworkStatus status;
    NSString *motionType;
    
    
    // to post bulk data
    
    NSMutableArray *dataCreatTime;
    NSMutableArray *totDistance;
    NSMutableArray *batteryPer;
    NSMutableArray *longitudeVal;
    NSMutableArray *latitudeVAl;
    NSMutableArray *accuracyVal;
    NSMutableArray *speedVal;
    NSMutableArray *altitudeVal;
    NSMutableArray *accelerationVal;
    NSMutableArray *breakVal;
    NSMutableArray *headingVal;
    
    
    //for trip summary
    CFTimeInterval summStTime;
    CFTimeInterval summEndTime;
    BOOL inConnected,outConnected, inDisconnected,outDisconnected, amDialling, inCall;
    
}

@property (nonatomic, strong) CoreLocationController *CLController;

@property (nonatomic, strong) NSOutputStream *outputStream;
@property (nonatomic, strong) NSInputStream *inputStream;

@property (nonatomic, strong) NSString *deviceId, *address;
@property (nonatomic) int port, period;
@property (nonatomic, strong) NSDictionary *diallingCodesDictionary;

@property (nonatomic, strong)NSString *dbhostName;
@property (nonatomic, strong)NSString *dbPort;
@property (nonatomic, strong)NSString *transmissionInterval;
@property (nonatomic, strong)NSString *collectionInterval;
@property (nonatomic, strong)NSString *provider;
@property (nonatomic, strong)NSString *notifyDistance;
@property (nonatomic, strong)NSString *notifyTime;
@property (nonatomic, strong)NSString *dataUploadType;
@property (nonatomic, copy)NSString *startEvent;
@property (nonatomic, copy)NSString *localEventAlert;
@property (nonatomic, strong)NSString *switchState;

// to post bulk data
@property (nonatomic, strong)NSMutableArray *dataCreatTime;
@property (nonatomic, strong)NSMutableArray *totDistance;
@property (nonatomic, strong)NSMutableArray *batteryPer;
@property (nonatomic, strong)NSMutableArray *longitudeVal;
@property (nonatomic, strong)NSMutableArray *latitudeVAl;
@property (nonatomic, strong)NSMutableArray *accuracyVal;
@property (nonatomic, strong)NSMutableArray *speedVal;
@property (nonatomic, strong)NSMutableArray *altitudeVal;
@property (nonatomic, strong)NSMutableArray *accelerationVal;
@property (nonatomic, strong)NSMutableArray *breakVal;
@property (nonatomic, strong)NSMutableArray *headingVal;

@property (nonatomic, assign) BOOL callConnected;
@property (nonatomic, assign) BOOL callDisconnected;
@property (nonatomic, assign) BOOL amDialling;
@property (nonatomic, assign) BOOL incomingCall;

@property (nonatomic, strong)NSString *localDataPath;
@property (nonatomic, strong)NSMutableArray *tempArray;

-(void)startLocationUpdate;
-(void)firstMethodToCall;
- (void)enabledStateChanged;
-(void)stopServices;
//- (NSDictionary *)callStateToUser;

-(void)storeDataIntoDb: (SettingsEntity *)settingsEntity;
-(NSDictionary*)getSettingsData;

@end
