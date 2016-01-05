//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "GeoLocusViewController.h"
#import <AdSupport/ASIdentifierManager.h>
#import "CoreLocationController.h"
#import "Constant.h"
#import "Reachability.h"
#import <CoreTelephony/CTCall.h>
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "AudioToolbox/AudioToolbox.h"
#import <AVFoundation/AVFoundation.h>

#import "CoreLocationController.h"
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "Reachability.h"
#import "HeadphonesDetector.h"
//#import "AppDelegate.h"
#import "TripSummaryEntity.h"
#import "TripSummaryDatabase.h"
#import "GeoLocus-Swift.h"
#import "TripSummaryDB.h"


#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define CHECKSUM_CONS 1217278743473774374;

@interface GeoLocusViewController ()<AVSpeechSynthesizerDelegate>

@property (nonatomic, retain) CTTelephonyNetworkInfo *tni;
@property (nonatomic, retain) CTCallCenter *callCenter;
@property (nonatomic, retain) NSString *crtCarrierName;
@property (nonatomic, copy) NSArray *crtCalls;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end

@implementation GeoLocusViewController

@synthesize tni, callCenter, crtCarrierName, crtCalls;

@synthesize CLController;
@synthesize deviceId, address;
@synthesize port, period;
@synthesize outputStream;
@synthesize inputStream;
@synthesize diallingCodesDictionary;
@synthesize dbhostName;
@synthesize dbPort;
@synthesize transmissionInterval;
@synthesize collectionInterval;
@synthesize provider;
@synthesize notifyDistance;
@synthesize notifyTime;
@synthesize dataUploadType;
@synthesize startEvent;
@synthesize switchState;
@synthesize localEventAlert;

// to post bulk data
@synthesize dataCreatTime;
@synthesize totDistance;
@synthesize batteryPer;
@synthesize longitudeVal;
@synthesize latitudeVAl;
@synthesize accuracyVal;
@synthesize speedVal;
@synthesize altitudeVal;
@synthesize accelerationVal;
@synthesize breakVal;
@synthesize headingVal;
@synthesize incomingCall,callConnected,callDisconnected,amDialling;

@synthesize localDataPath;
@synthesize tempArray;

BOOL state = NO;
BOOL tripEndState = NO;
BOOL settingsStatus = NO;


//for trip summary page
int overSpeedCount;
int acclCount;
int brakCount;
int inCallCount;
int outCallCount;
double summStartTime;
//

NSString *startEventTme = @"";

NSString *dbProtocol;

// Define a block for sorting calls by their callIDs.
NSComparator sortingBlock = ^(id call1, id call2) {
	NSString *callIdentifier = [call1 callID];
	NSString *call2Identifier = [call2 callID];
	NSComparisonResult result = [callIdentifier compare:call2Identifier
												options:NSNumericSearch | NSForcedOrderingSearch
												  range:NSMakeRange(0, [callIdentifier length])
												 locale:[NSLocale currentLocale]];
	return result;
};

- (void)viewDidLoad
{
    [self forLocalDataBase];
    [self firstMethodToCall];
    [super viewDidLoad];
}

- (void)enabledStateChanged
{
    //uncomment to trace crashed trips
/*    [self queryLocalDBForTripEndEvent];
 */
    
    [self getDataFromDb];
    [self checkNetworkConnection];
    
    state = YES;
    
    startEventState = YES;
    tripEndState = YES;
    // send start event json to server without any delay
    [self checkDataUploadType];
    
}

-(void)queryLocalDBForTripEndEvent
{
    
    tempArray = [[NSMutableArray alloc]init];
    
    storeDataDb = [FMDatabase databaseWithPath:self.localDataPath];
    [storeDataDb open];
    
    FMResultSet *localDbResult = [storeDataDb executeQuery:@"SELECT * From localData where eventType = 'TripEnd'"];
    
    while ([localDbResult next]) {
        [tempArray addObject:[localDbResult stringForColumn:@"eventType"]];
        
        localDBDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"dataSource"]],@"dataSource",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"msgType"]],@"msgType",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"provider"]],@"provider",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"creationTime"]],@"creationTime",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"dataReceivedTimestamp"]],@"dataReceivedTimestamp",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"gpsAge"]],@"gpsAge",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"totalDistCovered"]],@"totalDistCovered",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"rawdata"]],@"rawdata",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"lbl"]],@"lbl",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"ck"]],@"ck",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"longitude"]],@"longitude",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"latitude"]],@"latitude",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"deviceNumber"]],@"deviceNumber",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"accuracy"]],@"accuracy",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"speed"]],@"speed",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"altitude"]],@"altitude",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"acceleration"]],@"acceleration",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"braking"]],@"braking",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"heading"]],@"heading",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"deviceType"]],@"deviceType",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"eventType"]],@"eventType",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"endTime"]],@"endTime",
                             [NSString stringWithFormat:@"%@",[localDbResult stringForColumn:@"startTime"]],@"startTime",
                             nil];
        
    }
    
    [storeDataDb close];
    
    NSLog(@"%@temp array objects*********************************************",tempArray);
    if ([tempArray count]>=1) {
        /////////////////////////////////////////////////////////Delete all data from local DB /////////////////////////////////////////////////////////////////////////////
        
        storeDataDb = [FMDatabase databaseWithPath:self.localDataPath];
        [storeDataDb open];
        
        [storeDataDb executeUpdate:@"DELETE FROM localData"];
        
        [storeDataDb close];
        
        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        
    }else
    {
        //send trip end data using last trip time series data and event
        
        [self sendTripEndEventForLastCrashedTrip];
    }
    
    
}

-(void)stopServices
{
    [self forLocalDataBase];
    [self getDataFromDb];
    [self checkNetworkConnection];
    
    state = NO;
    startEventState = NO;
    
    tripEndDataSendCount = 0;
    [self checkDataUploadType];
    
}

-(void)checkNetworkConnection
{
    // Initialize Reachability
    internetReachable = [Reachability reachabilityWithHostName:@"www.google.com"];
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    status = [internetReachable currentReachabilityStatus];
    [internetReachable startNotifier];
    
}

-(void)firstMethodToCall
{
    //for trip summary
    
    overSpeedCount = 0;
    acclCount = 0;
    brakCount = 0;
    inCallCount = 0;
    outCallCount = 0;
    summStartTime = 0.0;
    
    incomingCall = NO;
    callConnected = NO;
    callDisconnected = NO;
    amDialling = NO;
    
    summStTime = CFAbsoluteTimeGetCurrent();
    summStartTime = summStTime;
    
    /*    // Network and Country Code
     NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"DiallingCodes" ofType:@"plist"];
     diallingCodesDictionary = [NSDictionary dictionaryWithContentsOfFile:plistPath];
     */
    
    // Get data from DB
    defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    dbPath = [documentsDir stringByAppendingPathComponent:@"geoLocus.sqlite"];
    
    if([fileManager fileExistsAtPath:dbPath]==NO){
        
        defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if(!success){
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    
    // Register Notification for database update
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveDBNotification:)
                                                 name:@"receiveDBNotification"
                                               object:nil];
    
    
    // Handle call state using core telphony
    
    // Instantiate CTTelephonyNetworkInfo and CTCallCenter objects.
	tni = [[CTTelephonyNetworkInfo alloc] init];
	callCenter = [[CTCallCenter alloc] init];
	crtCarrierName = tni.subscriberCellularProvider.carrierName;
	
	// Get the set of current calls from call center.
	crtCalls = [callCenter.currentCalls allObjects];
	
	// Sort current calls array by callIDs.
	crtCalls = [crtCalls sortedArrayUsingComparator:sortingBlock];
    
	// Define callEventHandler block inline
	callCenter.callEventHandler = ^(CTCall* inCTCall) {
		dispatch_async(dispatch_get_main_queue(), ^{
			crtCalls = [callCenter.currentCalls allObjects];
			crtCalls = [crtCalls sortedArrayUsingComparator:sortingBlock];
		});
		
		// Enable this NSLog inspect current call center.
		// NSLog(@"%s, self: <%@>, callCenter: <%@>", __PRETTY_FUNCTION__, self, self.callCenter);
	};
	
	// Define subscriberCellularProviderDidUpdateNotifier block inline
	tni.subscriberCellularProviderDidUpdateNotifier = ^(CTCarrier* inCTCarrier) {
		dispatch_async(dispatch_get_main_queue(), ^{
			crtCarrierName = inCTCarrier.carrierName;
		});
	};
    
    //handle call events
    [self callStateHandler];
    
}

#pragma mark local DB
-(void)forLocalDataBase
{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPath objectAtIndex:0];
    
    // to store data locally
    self.localDataPath = [documentDir stringByAppendingPathComponent:@"storeData.sqlite"];
    [self createDatabaseForStoreData];
}

-(void)createDatabaseForStoreData
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:self.localDataPath];
    if(success) return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"storeData.sqlite"];
    [fileManager copyItemAtPath:databasePathFromApp toPath:self.localDataPath error:nil];
}


- (void)viewDidUnload {
	[super viewDidUnload];
	
	self.tni.subscriberCellularProviderDidUpdateNotifier = nil;
	self.tni = nil;
	self.callCenter.callEventHandler = nil;
	self.callCenter = nil;
}

/*
 - (NSString *)codeFromDictionaryForCountry:(NSString *)country {
 return [diallingCodesDictionary objectForKey:[country lowercaseString]];
 }
 */

#pragma mark Call State
-(void)callStateHandler
{
    
    callCenter.callEventHandler=^(CTCall* call)
    {
        //        [self isAudioJackPlugged];
        
        
        if (call.callState == CTCallStateDisconnected)
        {
            self.callDisconnected = YES;
            [self showMessage:call.callState];
        }
        else if(call.callState == CTCallStateIncoming)
        {
            self.incomingCall = YES;
            inOrOutCall = @"CTCallStateIncoming";
            [self showMessage:call.callState];
            
        }
        else if (call.callState == CTCallStateConnected)
        {
            self.callConnected = YES;
            [self showMessage:call.callState];
            
        }else if (call.callState == CTCallStateDialing)
        {
            self.amDialling = YES;
            inOrOutCall = @"CTCallStateDialing";
            [self showMessage:call.callState];
        }
        else
        {
            NSLog(@"None of the conditions");
        }
        
        //for incoming calls
        if (self.incomingCall && self.callConnected && self.callDisconnected) {
            
            inCallCount++;
            
            self.incomingCall = NO;
            self.callConnected = NO;
            self.callDisconnected = NO;
        }
        
        //for outgoing calls
        if (self.amDialling && self.callConnected && self.callDisconnected) {
            
            outCallCount++;
            
            self.amDialling = NO;
            self.callConnected = NO;
            self.callDisconnected = NO;
        }
        
    };
    
    
}

-(void)showMessage:(NSString*)callState
{
    callStatus = callState;
}

- (BOOL) isAudioJackPlugged
{
    @try {
        // Try something
        
        // initialise the audio session - this should only be done once - so move this line to your AppDelegate
        AudioSessionInitialize(NULL, NULL, NULL, NULL);
        UInt32 routeSize;
        
        // oddly, without calling this method caused an error.
        AudioSessionGetPropertySize(kAudioSessionProperty_AudioRouteDescription, &routeSize);
        CFDictionaryRef desc; // this is the dictionary to contain descriptions
        
        // make the call to get the audio description and populate the desc dictionary
        AudioSessionGetProperty (kAudioSessionProperty_AudioRouteDescription, &routeSize, &desc);
        
        // the dictionary contains 2 keys, for input and output. Get output array
        CFArrayRef outputs = CFDictionaryGetValue(desc, kAudioSession_AudioRouteKey_Outputs);
        
        // the output array contains 1 element - a dictionary
        CFDictionaryRef dict = CFArrayGetValueAtIndex(outputs, 0);
        
        // get the output description from the dictionary
        CFStringRef output = CFDictionaryGetValue(dict, kAudioSession_AudioRouteKey_Type);
        
        /**
         Possible output types:
         kAudioSessionOutputRoute_LineOut
         kAudioSessionOutputRoute_Headphones
         kAudioSessionOutputRoute_BluetoothHFP
         kAudioSessionOutputRoute_BluetoothA2DP
         kAudioSessionOutputRoute_BuiltInReceiver
         kAudioSessionOutputRoute_BuiltInSpeaker
         kAudioSessionOutputRoute_USBAudio
         kAudioSessionOutputRoute_HDMI
         kAudioSessionOutputRoute_AirPlay
         */
        
        headPhoneStatus = (__bridge NSString *)(output);
        NSLog(@"Call mode:%@",headPhoneStatus);
        return CFStringCompare(output, kAudioSessionOutputRoute_Headphones, 0) == kCFCompareEqualTo;
        
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}


-(void)startLocationUpdate
{
    /*    CLController.delegate = self;
     CLController.locMgr.distanceFilter = distanceNotifyValue;
     CLController.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
     [CLController.locMgr startUpdatingLocation];
     [CLController.locMgr startUpdatingHeading];
     
     [self performSelector:@selector(startLocationUpdate) withObject:Nil afterDelay:10.0];
     */
}

#pragma mark Db transaction for setting page

-(void)storeDataIntoDb: (SettingsEntity *)settingsEntity {
    
    AppDelegateSwift *appDelegate = [[UIApplication sharedApplication] delegate];
    
    defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL isInserted;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    dbPath = [documentsDir stringByAppendingPathComponent:@"geoLocus.sqlite"];
    
    if([fileManager fileExistsAtPath:dbPath]==NO){
        
        defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if(!success){
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    db = [FMDatabase databaseWithPath:dbPath];
    [db open];
    
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
    
    NSLog(@"Settings hostname: %@",settingsEntity.hostname);
    NSLog(@"Settings port: %@",settingsEntity.port);
    NSLog(@"Settings frequency: %@",settingsEntity.frequency);
    NSLog(@"Settings protocols: %@",settingsEntity.protocols);
    NSLog(@"Settings datauploadtype: %@",settingsEntity.datauploadtype);
    NSLog(@"Settings transmissioninterval: %@",settingsEntity.transmissioninterval);
    NSLog(@"Settings collectioninterval: %@",settingsEntity.collectioninterval);
    NSLog(@"Settings provider: %@",settingsEntity.provider);
    NSLog(@"Settings notifydistance: %@",settingsEntity.notifydistance);
    NSLog(@"Settings notifytime: %@",settingsEntity.notifytime);
    NSLog(@"Settings providervalue: %@",settingsEntity.providervalue);
    NSLog(@"Settings voiceAlert: %@",settingsEntity.voiceAlert);
    
    if ([rs next]) {
        
        isInserted=[db executeUpdate:@"UPDATE geoLocus SET hostname = ?,port = ?,frequency = ?,protocols = ?,datauploadtype = ?,transmissioninterval = ?,collectioninterval = ?,provider = ?,notifydistance = ?,notifytime = ?,providervalue = ?,voicealert = ?",settingsEntity.hostname,settingsEntity.port,settingsEntity.frequency,settingsEntity.protocols,settingsEntity.datauploadtype,settingsEntity.transmissioninterval,settingsEntity.collectioninterval,settingsEntity.provider,settingsEntity.notifydistance,settingsEntity.notifytime,settingsEntity.providervalue,settingsEntity.voiceAlert, nil];
        
    } else {
        
        isInserted=[db executeUpdate:@"INSERT INTO geoLocus (hostname,port,frequency,protocols,datauploadtype,transmissioninterval,collectioninterval,provider,notifydistance,notifytime,providervalue,voicealert) VALUES (?,?,?,?,?,?,?,?,?,?,?,?);",settingsEntity.hostname,settingsEntity.port,settingsEntity.frequency,settingsEntity.protocols,settingsEntity.datauploadtype,settingsEntity.transmissioninterval,settingsEntity.collectioninterval,settingsEntity.provider,settingsEntity.notifydistance,settingsEntity.notifytime,settingsEntity.providervalue,settingsEntity.voiceAlert, nil];
    }
    
    if(isInserted){
        
        appDelegate.vAlert = settingsEntity.voiceAlert;
        
        settingsStatus = YES;
        // [db commit];
    }else{
        NSLog(@"Error occured while inserting");
    }
    
    [db close];
    
}


-(NSDictionary*)getSettingsData
{
    AppDelegateSwift *appDelegate = [[UIApplication sharedApplication] delegate];
    
    defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    dbPath = [documentsDir stringByAppendingPathComponent:@"geoLocus.sqlite"];
    
    if([fileManager fileExistsAtPath:dbPath]==NO){
        
        defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if(!success){
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
    
    /*  if ([rs next]){
     NSLog(@"not null");
     } else {
     NSLog(@"null");
     }
     */
    while ([rs next]) {
        NSLog(@"%@",
              [rs stringForColumn:@"hostname"]);
        
        NSLog(@"%@",
              [rs stringForColumn:@"port"]);
        
        dbhostName = [rs stringForColumn:@"hostname"];
        address = dbhostName;
        dbPort = [rs stringForColumn:@"port"];
        port = [dbPort intValue];
        
        
        dbProtocol = [rs stringForColumn:@"protocols"];
        
        // Input
        transmissionInterval = [rs stringForColumn:@"transmissioninterval"];
        NSString *numberString;
        NSScanner *scanner = [NSScanner scannerWithString:transmissionInterval];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        transIntervalValue = [numberString integerValue];
        
        collectionInterval = [rs stringForColumn:@"collectioninterval"];
        NSString *collectionNumberString;
        NSScanner *collectionScanner = [NSScanner scannerWithString:collectionInterval];
        NSCharacterSet *collectionNumbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [collectionScanner scanUpToCharactersFromSet:collectionNumbers intoString:NULL];
        [collectionScanner scanCharactersFromSet:collectionNumbers intoString:&collectionNumberString];
        collectIntervalValue = [collectionNumberString integerValue];
        
        provider = [rs stringForColumn:@"provider"];
        
        notifyDistance = [rs stringForColumn:@"notifydistance"];
        NSString *notifyDistanceString;
        NSScanner *distanceScanner = [NSScanner scannerWithString:notifyDistance];
        NSCharacterSet *distanceNumbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [distanceScanner scanUpToCharactersFromSet:distanceNumbers intoString:NULL];
        [distanceScanner scanCharactersFromSet:distanceNumbers intoString:&notifyDistanceString];
        distanceNotifyValue = [notifyDistanceString integerValue];
        
        notifyTime = [rs stringForColumn:@"notifytime"];
        dataUploadType = [rs stringForColumn:@"datauploadtype"];
        
        NSString *voiceAlertStatus = [[NSString alloc] init];
//        voiceAlertStatus = [rs stringForColumn:@"voicealert"];
        voiceAlertStatus = appDelegate.vAlert;
        
        NSLog(@"voiceAlertStatus: %@",voiceAlertStatus);
        
//        appDelegate.vAlert = voiceAlertStatus;
        
        
        NSDictionary *settingsResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",dbhostName],@"hostName",[NSString stringWithFormat:@"%@",dbPort],@"portNumber",[NSString stringWithFormat:@"%@",dbProtocol],@"protocols",[NSString stringWithFormat:@"%@",transmissionInterval],@"transmissionInterval", [NSString stringWithFormat:@"%@",collectionInterval],@"collectionInterval", [NSString stringWithFormat:@"%@",provider],@"provider", [NSString stringWithFormat:@"%@",notifyDistance],@"notifyDistance",[NSString stringWithFormat:@"%@",notifyTime],@"notifyTime",[NSString stringWithFormat:@"%@",dataUploadType],@"dataUploadType", [NSString stringWithFormat:@"Disabled"],@"serviceAutoEnable", [NSString stringWithFormat:@"Disabled"],@"behaviouralBased", [NSString stringWithFormat:@"Disabled"],@"transmitImmediate",[NSString stringWithFormat:@"Disabled"],@"Accelerometer", [NSString stringWithFormat:@"Disabled"],@"Speed", [NSString stringWithFormat:@"Disabled"],@"PhoneUsage", [NSString stringWithFormat:@"Disabled"],@"cornering", [NSString stringWithFormat:@"Disabled"],@"syncEndOfDay", [NSString stringWithFormat:@"20:00"],@"syncTime", [NSString stringWithFormat:@"https://54.193.31.22/sei/"],@"reportServiceURL", [NSString stringWithFormat:@"https://54.193.31.22/sei/"],@"weeklyReportServiceURL", [NSString stringWithFormat:@"https://54.193.31.22/sei/"],@"registerServiceURL", [NSString stringWithFormat:@"https://54.193.31.22/sei/"],@"loginServiceURL", [NSString stringWithFormat:@"%@", voiceAlertStatus], @"voiceStatusKey", nil];
        
//        NSDictionary *settingsResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",dbhostName],@"hostName",[NSString stringWithFormat:@"%@",dbPort],@"portNumber",[NSString stringWithFormat:@"%@",dbProtocol],@"protocols",[NSString stringWithFormat:@"%@",transmissionInterval],@"transmissionInterval", [NSString stringWithFormat:@"%@",collectionInterval],@"collectionInterval", [NSString stringWithFormat:@"%@",provider],@"provider", [NSString stringWithFormat:@"%@",notifyDistance],@"notifyDistance",[NSString stringWithFormat:@"%@",notifyTime],@"notifyTime",[NSString stringWithFormat:@"%@",dataUploadType],@"dataUploadType", [NSString stringWithFormat:@"Disabled"],@"serviceAutoEnable", [NSString stringWithFormat:@"Disabled"],@"behaviouralBased", [NSString stringWithFormat:@"Disabled"],@"transmitImmediate",[NSString stringWithFormat:@"Disabled"],@"Accelerometer", [NSString stringWithFormat:@"Disabled"],@"Speed", [NSString stringWithFormat:@"Disabled"],@"PhoneUsage", [NSString stringWithFormat:@"Disabled"],@"cornering", [NSString stringWithFormat:@"Disabled"],@"syncEndOfDay", [NSString stringWithFormat:@"20:00"],@"syncTime", [NSString stringWithFormat:@"https://54.183.64.73/sei/"],@"reportServiceURL", [NSString stringWithFormat:@"https://54.183.64.73/sei/"],@"weeklyReportServiceURL", [NSString stringWithFormat:@"https://54.183.64.73/sei/"],@"registerServiceURL", [NSString stringWithFormat:@"https://54.183.64.73/sei/"],@"loginServiceURL", [NSString stringWithFormat:@"%@", voiceAlertStatus], @"voiceStatusKey", nil];
        
        NSLog(@"The value of settingsResult is :%@",settingsResult);
        return settingsResult;
        
    }
    
    [db close];
    
    return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"ec2-54-183-64-73.us-west-1.compute.amazonaws.com"],@"hostName",[NSString stringWithFormat:@"9091"],@"portNumber",[NSString stringWithFormat:@"HTTP,HTTPS,TCP/IP"],@"protocols", [NSString stringWithFormat:@"30 sec"],@"transmissionInterval", [NSString stringWithFormat:@"30 sec"],@"collectionInterval", [NSString stringWithFormat:@"GPS,Network Provider,Both"],@"provider", [NSString stringWithFormat:@"20 meters"],@"notifyDistance",[NSString stringWithFormat:@"5 sec"],@"notifyTime",[NSString stringWithFormat:@"WiFi,Mobile Data"],@"dataUploadType", [NSString stringWithFormat:@"Disabled"],@"serviceAutoEnable", [NSString stringWithFormat:@"Disabled"],@"behaviouralBased", [NSString stringWithFormat:@"Disabled"],@"transmitImmediate",[NSString stringWithFormat:@"Disabled"],@"Accelerometer", [NSString stringWithFormat:@"Disabled"],@"Speed", [NSString stringWithFormat:@"Disabled"],@"PhoneUsage", [NSString stringWithFormat:@"Disabled"],@"cornering", [NSString stringWithFormat:@"Disabled"],@"syncEndOfDay", [NSString stringWithFormat:@"20:00"],@"syncTime", [NSString stringWithFormat:@"https://54.193.31.22/sei/"],@"reportServiceURL", [NSString stringWithFormat:@"https://54.193.31.22/sei/"],@"weeklyReportServiceURL", [NSString stringWithFormat:@"https://54.193.31.22/sei/"],@"registerServiceURL", [NSString stringWithFormat:@"https://54.193.31.22/sei/"],@"loginServiceURL", [NSString stringWithFormat:@"Disabled"], @"voiceStatusKey", nil];
    
//    return [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"ec2-54-183-64-73.us-west-1.compute.amazonaws.com"],@"hostName",[NSString stringWithFormat:@"9091"],@"portNumber",[NSString stringWithFormat:@"HTTP,HTTPS,TCP/IP"],@"protocols", [NSString stringWithFormat:@"30 sec"],@"transmissionInterval", [NSString stringWithFormat:@"30 sec"],@"collectionInterval", [NSString stringWithFormat:@"GPS,Network Provider,Both"],@"provider", [NSString stringWithFormat:@"20 meters"],@"notifyDistance",[NSString stringWithFormat:@"5 sec"],@"notifyTime",[NSString stringWithFormat:@"WiFi,Mobile Data"],@"dataUploadType", [NSString stringWithFormat:@"Disabled"],@"serviceAutoEnable", [NSString stringWithFormat:@"Disabled"],@"behaviouralBased", [NSString stringWithFormat:@"Disabled"],@"transmitImmediate",[NSString stringWithFormat:@"Disabled"],@"Accelerometer", [NSString stringWithFormat:@"Disabled"],@"Speed", [NSString stringWithFormat:@"Disabled"],@"PhoneUsage", [NSString stringWithFormat:@"Disabled"],@"cornering", [NSString stringWithFormat:@"Disabled"],@"syncEndOfDay", [NSString stringWithFormat:@"20:00"],@"syncTime", [NSString stringWithFormat:@"https://54.183.64.73/sei/"],@"reportServiceURL", [NSString stringWithFormat:@"https://54.183.64.73/sei/"],@"weeklyReportServiceURL", [NSString stringWithFormat:@"https://54.183.64.73/sei/"],@"registerServiceURL", [NSString stringWithFormat:@"https://54.183.64.73/sei/"],@"loginServiceURL", [NSString stringWithFormat:@"Disabled"], @"voiceStatusKey", nil];
}


#pragma mark get data from DB
-(void)getDataFromDb
{
    defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    dbPath = [documentsDir stringByAppendingPathComponent:@"geoLocus.sqlite"];
    
    if([fileManager fileExistsAtPath:dbPath]==NO){
        
        defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if(!success){
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    
    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
    
    while ([rs next]) {
        NSLog(@"%@",
              [rs stringForColumn:@"hostname"]);
        
        dbhostName = [rs stringForColumn:@"hostname"];
        self.address = dbhostName;
        dbPort = [rs stringForColumn:@"port"];
        port = [dbPort intValue];
        // Input
        transmissionInterval = [rs stringForColumn:@"transmissioninterval"];
        NSString *numberString;
        NSScanner *scanner = [NSScanner scannerWithString:transmissionInterval];
        NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        [scanner scanCharactersFromSet:numbers intoString:&numberString];
        transIntervalValue = [numberString integerValue];
        
        collectionInterval = [rs stringForColumn:@"collectioninterval"];
        NSString *collectionNumberString;
        NSScanner *collectionScanner = [NSScanner scannerWithString:collectionInterval];
        NSCharacterSet *collectionNumbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [collectionScanner scanUpToCharactersFromSet:collectionNumbers intoString:NULL];
        [collectionScanner scanCharactersFromSet:collectionNumbers intoString:&collectionNumberString];
        collectIntervalValue = [collectionNumberString integerValue];
        
        provider = [rs stringForColumn:@"provider"];
        
        notifyDistance = [rs stringForColumn:@"notifydistance"];
        NSString *notifyDistanceString;
        NSScanner *distanceScanner = [NSScanner scannerWithString:notifyDistance];
        NSCharacterSet *distanceNumbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [distanceScanner scanUpToCharactersFromSet:distanceNumbers intoString:NULL];
        [distanceScanner scanCharactersFromSet:distanceNumbers intoString:&notifyDistanceString];
        distanceNotifyValue = [notifyDistanceString integerValue];
        
        notifyTime = [rs stringForColumn:@"notifytime"];
        dataUploadType = [rs stringForColumn:@"datauploadtype"];
        
    }
    
    [db close];
    
}

-(NSString *)getUTCFormateDate:(NSDate *)localDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    return dateString;
}

- (void)locationError:(NSError *)error {
	speedLabel.text = [error description];
}

#pragma mark check data upload type and connectivity
-(void)checkDataUploadType
{
    
    if(status == NotReachable)
    {
        NSLog(@"no connection");
        //        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Network alert"
        //                                                          message:@"Please check your network connectivity"
        //                                                         delegate:nil
        //                                                cancelButtonTitle:@"OK"
        //                                                otherButtonTitles:nil];
        //
        //        [message show];
        
        [self checkNetworkConnection];
        
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        [self initNetworkCommunication];
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        [self initNetworkCommunication];
    }else
    {
        //[self initNetworkCommunication];
        
    }
    
    if (state)
    {
        [self performSelector:@selector(checkDataUploadType) withObject:Nil afterDelay:transIntervalValue];
        
    }
    
}

#pragma mark TCP Connection and data posting

- (void) initNetworkCommunication {
	
    if (settingsStatus){
        
        [self getDataFromDb];
        
        settingsStatus = NO;
    }
    
    
    if (port==0) {
        port = 9091;
    }
    if ([self.address length]==0) {
//        self.address = @"54.193.95.129";
        self.address = @"54.183.64.73";
    }
    
    //    port = 9091;
    //    address = @"54.193.95.129"; // old ip
    //    address = @"54.183.57.231"; // new ip
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef) self.address, port, NULL, &writeStream);
    
	inputStream = (__bridge NSInputStream *)readStream;
	outputStream = (__bridge NSOutputStream *)writeStream;
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    
	[inputStream open];
	[outputStream open];
	
    [self sendData];
    
}

- (void) sendData {
    
    // Data posting time
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    postTime = 1000.0 * [[NSDate date] timeIntervalSince1970];
    NSString *postTime1 = [NSString stringWithFormat:@"%f",postTime];
    
    NSArray* getUptoDecimal = [postTime1 componentsSeparatedByString: @"."];
    postTime1 = [getUptoDecimal objectAtIndex: 0];
    
    //get DB path to read data from
    defaultDBPathForPosting = [[NSBundle mainBundle] pathForResource:@"collectData" ofType: @"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    dbPathForPOsting = [documentsDir stringByAppendingPathComponent:@"collectData.sqlite"];
    
    if([fileManager fileExistsAtPath:dbPathForPOsting]==NO){
        
        defaultDBPathForPosting = [[NSBundle mainBundle] pathForResource:@"collectData" ofType: @"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPathForPosting toPath:dbPathForPOsting error:&error];
        
        if(!success){
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    dbDataPosting = [FMDatabase databaseWithPath:dbPathForPOsting];
    
    [dbDataPosting open];
    
    
    FMResultSet *rs = [dbDataPosting executeQuery:@"SELECT * From collectData"];
    
    NSString *creationTime1 = nil;
    NSString *totalDistance1 = nil;
    
    
    float totalDistCovered;
    
    dataCreatTime = [[NSMutableArray alloc]init];
    totDistance =  [[NSMutableArray alloc]init];
    batteryPer =  [[NSMutableArray alloc]init];
    longitudeVal = [[NSMutableArray alloc]init];
    latitudeVAl = [[NSMutableArray alloc]init];
    accuracyVal = [[NSMutableArray alloc]init];
    speedVal = [[NSMutableArray alloc]init];
    altitudeVal = [[NSMutableArray alloc]init];
    accelerationVal = [[NSMutableArray alloc]init];
    breakVal = [[NSMutableArray alloc]init];
    headingVal = [[NSMutableArray alloc]init];
    
    while ([rs next]) {
        creationTime1 = [rs stringForColumn:@"creationTime"];
        
        totalDistance1 = [rs stringForColumn:@"totalDistCovered"];
        totalDistCovered = [[rs stringForColumn:@"totalDistCovered"] floatValue];
        totalDistCovered = totalDistCovered*1000;
        
        
        if (![[rs stringForColumn:@"creationTime"] length]==0) {
            [dataCreatTime addObject:[rs stringForColumn:@"creationTime"]];
        }else{
            [dataCreatTime addObject:@"0"];
        }
        if (![[rs stringForColumn:@"totalDistCovered"] length]==0) {
            [totDistance addObject:[rs stringForColumn:@"totalDistCovered"]];
        }else{
            [totDistance addObject:@"0"];
        }
        if (![[rs stringForColumn:@"lbl"] length]==0) {
            [batteryPer addObject:[rs stringForColumn:@"lbl"]];
        }else{
            [batteryPer addObject:@"0"];
        }
        if (![[rs stringForColumn:@"longitude"] length]==0) {
            [longitudeVal addObject:[rs stringForColumn:@"longitude"]];
        }else{
            [longitudeVal addObject:@"0"];
        }
        if (![[rs stringForColumn:@"latitude"] length]==0) {
            [latitudeVAl addObject:[rs stringForColumn:@"latitude"]];
        }else{
            [latitudeVAl addObject:@"0"];
        }
        if (![[rs stringForColumn:@"accuracy"] length]==0) {
            [accuracyVal addObject:[rs stringForColumn:@"accuracy"]];
        }else{
            [accuracyVal addObject:@"0"];
        }
        if (![[rs stringForColumn:@"speed"] length]==0) {
            [speedVal addObject:[rs stringForColumn:@"speed"]];
        }else{
            [speedVal addObject:@"0"];
        }
        if (![[rs stringForColumn:@"altitude"] length]==0) {
            [altitudeVal addObject:[rs stringForColumn:@"altitude"]];
        }else{
            [altitudeVal addObject:@"0"];
        }
        if (![[rs stringForColumn:@"acceleration"] length]==0) {
            [accelerationVal addObject:[rs stringForColumn:@"acceleration"]];
        }else{
            [accelerationVal addObject:@"0"];
        }
        if (![[rs stringForColumn:@"braking"] length]==0) {
            [breakVal addObject:[rs stringForColumn:@"braking"]];
        }else{
            [breakVal addObject:@"0"];
        }
        if (![[rs stringForColumn:@"heading"] length]==0) {
            [headingVal addObject:[rs stringForColumn:@"heading"]];
        }else{
            [headingVal addObject:@"0"];
        }
        
    }
    
    
    
    // remove all records from db except most recent one
    [dbDataPosting executeUpdate:@"delete from collectData where rowid not in (select rowid from collectData order by rowid desc limit 1)"];
    
    
    if (![longitudeVal count]==0) {
        
        for (int i=0; i<[longitudeVal count]; i++) {
            
            
            // Calculate checksum
            int latLon = (int) (([[latitudeVAl objectAtIndex:i] doubleValue]+[[longitudeVal objectAtIndex:i] doubleValue]) * 1E6);
            NSString *checkSumStr1 = @"1217278743473774374";
            NSString *checkSumStr = [checkSumStr1 stringByAppendingString:[NSString stringWithFormat:@"%d",latLon]];
            
            NSNumber * calculatedChkSm= adlerChecksumof(checkSumStr);
            NSString *cKValue = [calculatedChkSm stringValue];
            
            // data received time stamp
            double dataReceivedTimestamp = 1000.0 * [[NSDate date] timeIntervalSince1970];
            
            NSString *dataReceivedTime = [NSString stringWithFormat:@"%f",dataReceivedTimestamp];
            
            NSArray* getUptoDecimalDataReceived = [dataReceivedTime componentsSeparatedByString: @"."];
            dataReceivedTime = [getUptoDecimalDataReceived objectAtIndex: 0];
            
            
            @try {
                
                if (startEventState == YES) {
                    
                    startEventTime = 1000.0 * [[NSDate date] timeIntervalSince1970];
                    
                    self.startEvent = [NSString stringWithFormat:@"%f",startEventTime];
                    NSArray* sEGetUptoDecimal = [startEvent componentsSeparatedByString: @"."];
                    self.startEvent = [sEGetUptoDecimal objectAtIndex: 0];
                    
                    startEventTme = self.startEvent;
                    
                    
////////////////////////////////////////////////////////////INSERT INTO LOCAL DB/////////////////////////////////////////////////////////////////////////////////
                    
                    storeDataDb = [FMDatabase databaseWithPath:self.localDataPath];
                    [storeDataDb open];
                    
                    [storeDataDb executeUpdate:@"INSERT INTO localData (uId,dataSource,msgType,provider,creationTime,dataReceivedTimestamp,gpsAge,totalDistCovered,rawdata,lbl,ck,longitude,latitude,deviceNumber,accuracy,speed,altitude,acceleration,braking,heading,deviceType,eventType,endTime,startTime) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",@"",@"Mobile",@"timeseries",@"gps",self.startEvent,dataReceivedTime,@"0",@"0",@"0",batteryLbl,cKValue,[longitudeVal objectAtIndex:i],[latitudeVAl objectAtIndex:i],mainDelegate.deviceId,[accuracyVal objectAtIndex:i],@"0",[altitudeVal objectAtIndex:i],@"0",@"0",[headingVal objectAtIndex:i],@"Mobile",@"TripStart",self.startEvent,self.startEvent, nil];
                    
                    [storeDataDb close];
                    
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                    
                    // Start Trip JSON to server
                    startEventJson = nil;
                    startEventJson = [NSString stringWithFormat:STARTEVENTJSON,0,@"network",0,0,0,self.startEvent,@"",self.startEvent,0,0,@"TripStart",@"",@"TripStart",@"Mobile",self.startEvent,[[longitudeVal objectAtIndex:i] doubleValue],@"",0,@"network",dataReceivedTime,0,0,cKValue,@"event",[[latitudeVAl objectAtIndex:i] doubleValue],[[accuracyVal objectAtIndex:i] integerValue],mainDelegate.deviceId,[headingVal objectAtIndex:i]];
                    
                    NSLog(@"Start Event:%@",startEventJson);
                    
                    startEventJson = [startEventJson stringByAppendingString:@"\r\n"];
                    
                    [self writeToTextFile:[NSString stringWithFormat:@"%@\r\n",startEventJson]];
                    
                    [outputStream  write:(const uint8_t *)[startEventJson UTF8String] maxLength:startEventJson.length];
                    
                    startEventState = NO;
                    
                }else{
                    
                    if (state == YES) {
                        
                        //timestamp for events like speed, acceleration, braking etc
                        
                        double eventTimeLocal = 1000.0 * [[NSDate date] timeIntervalSince1970];
                        self.localEventAlert = [NSString stringWithFormat:@"%f",eventTimeLocal];
                        NSArray* sEGetUptoDecimal = [self.localEventAlert componentsSeparatedByString: @"."];
                        self.localEventAlert = [sEGetUptoDecimal objectAtIndex: 0];
                        NSString *timeLocalEvent = self.localEventAlert;
                        ///// End
                        
                        //////////////////////////////////////////////////////////////////INSERT INTO LOCAL DB//////////////////////////////////////////////////////////////////////////////
                        
                        storeDataDb = [FMDatabase databaseWithPath:self.localDataPath];
                        [storeDataDb open];
                        
                        [storeDataDb executeUpdate:@"INSERT INTO localData (uId,dataSource,msgType,provider,creationTime,dataReceivedTimestamp,gpsAge,totalDistCovered,rawdata,lbl,ck,longitude,latitude,deviceNumber,accuracy,speed,altitude,acceleration,braking,heading,deviceType,eventType,endTime,startTime) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",@"1",@"Mobile",@"timeseries",@"gps",[dataCreatTime objectAtIndex:i],postTime1,@"0",[totDistance objectAtIndex:i],@"0",[batteryPer objectAtIndex:i],cKValue,[longitudeVal objectAtIndex:i],[latitudeVAl objectAtIndex:i],mainDelegate.deviceId,[accuracyVal objectAtIndex:i],[speedVal objectAtIndex:i],[altitudeVal objectAtIndex:i],[accelerationVal objectAtIndex:i],[breakVal objectAtIndex:i],[headingVal objectAtIndex:i],@"Mobile",@"timeseries",postTime1,self.startEvent, nil];
                        
                        [storeDataDb close];
                        
                        ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                        
                        finalJsonString = nil;
                        
                        finalJsonString = [NSString stringWithFormat:FINALJSONDATA,@"mobile",@"timeseries",@"gps",[dataCreatTime objectAtIndex:i],postTime1,0,[[totDistance objectAtIndex:i] floatValue]*1000.0,@"",[[batteryPer objectAtIndex:i] integerValue],cKValue,[[longitudeVal objectAtIndex:i] doubleValue],[[latitudeVAl objectAtIndex:i] doubleValue],mainDelegate.deviceId,[[accuracyVal objectAtIndex:i] integerValue],[[speedVal objectAtIndex:i] integerValue],[[altitudeVal objectAtIndex:i] integerValue],[[accelerationVal objectAtIndex:i] integerValue],[[breakVal objectAtIndex:i] integerValue],[headingVal objectAtIndex:i],@"Mobile"];
                        
                        finalJsonString = [finalJsonString stringByAppendingString:@"\r\n"];
//                        NSLog(@"posting json data %@:",finalJsonString);
                        
                        [self writeToTextFile:[NSString stringWithFormat:@"%@\r\n",finalJsonString]];
                        
                        [outputStream  write:(const uint8_t *)[finalJsonString UTF8String] maxLength:finalJsonString.length];
                        
                        // Check for Threshold limit violation for speed
//                        NSLog(@"Value of Speed Limit Threshold is : %f", mainDelegate.speedLimit);
//                        NSLog(@"Dan checking speedVal : %f", [[speedVal objectAtIndex:i] floatValue]);
                        
                        if ([[speedVal objectAtIndex:i] floatValue] >= mainDelegate.speedLimit) {
//                        if ([[speedVal lastObject] floatValue] >= mainDelegate.speedLimit) {
                        
                            overSpeedCount++;
                            
                            finalJsonString = nil;
                            finalJsonString = [NSString stringWithFormat:@"{\"params\":\{\"thresholdValue\":\{\"value\":\%d},\"dataSource\":\{\"value\":\"%@\"},\"totalDistCovered\":\{\"value\":\%f},\"altitude\":\{\"value\":\%d},\"acceleration\":\{\"value\":\%d},\"endTime\":\{\"value\":\%@},\"rawdata\":\{\"value\":\"%@\"},\"startTime\":\{\"value\":\%@},\"distance\":\{\"value\":\%f},\"braking\":\{\"value\":\%d},\"description\":\{\"value\":\"%@\"},\"ruleName\":\{\%@},\"eventCategoryName\":\{\"value\":\"%@\"},\"deviceType\":\{\"value\":\"%@\"},\"creationTime\":\{\"value\":\%@},\"longitude\":\{\"value\":\%.14f},\"geozoneId\":\{\%@},\"speed\":\{\"value\":\%d},\"provider\":\{\"value\":\"%@\"},\"dataReceivedTimestamp\":\{\"value\":\%@},\"gpsAge\":\{\"value\":\%d},\"currentValue\":\{\"value\":\%d},\"lbl\":\{\"value\":\%d},\"ck\":\{\"value\":\"%@\"},\"msgType\":\{\"value\":\"%@\"},\"latitude\":\{\"value\":\%.14f},\"accuracy\":\{\"value\":\%d},\"deviceNumber\":\{\"value\":\"%@\"},\"heading\":\{\"value\":\"%@\"}}}",[[speedVal objectAtIndex:i] integerValue],@"gps",[[totDistance objectAtIndex:i] floatValue]*1000.0,[[altitudeVal objectAtIndex:i] integerValue],[[accelerationVal objectAtIndex:i] integerValue],timeLocalEvent,@"",timeLocalEvent,[[totDistance objectAtIndex:i] floatValue]*1000.0,[[breakVal objectAtIndex:i] integerValue],@"overspeed",@"",@"overspeed",@"Mobile",timeLocalEvent,[[longitudeVal objectAtIndex:i] doubleValue],@"",[[speedVal objectAtIndex:i] integerValue],@"gps",postTime1,0,0,[[batteryPer objectAtIndex:i] integerValue],cKValue,@"event",[[latitudeVAl objectAtIndex:i] doubleValue],[[accuracyVal objectAtIndex:i] integerValue],mainDelegate.deviceId,[headingVal objectAtIndex:i]];
                            
                            
                            finalJsonString = [finalJsonString stringByAppendingString:@"\r\n"];
//                            NSLog(@"posting json data %@:",finalJsonString);
                            
                            [self writeToTextFile:[NSString stringWithFormat:@"%@%@\r\n",@"Identified speed limit violation",finalJsonString]];
                            
                            [outputStream  write:(const uint8_t *)[finalJsonString UTF8String] maxLength:finalJsonString.length];
                            
                        }
                        
                        // Check for Threshold limit violation for acceleration
                        if ([[accelerationVal objectAtIndex:i] integerValue] >= 5.0) {
                            
                            acclCount++;
                            
                            finalJsonString = nil;
                            finalJsonString = [NSString stringWithFormat:@"{\"params\":\{\"thresholdValue\":\{\"value\":\%d},\"dataSource\":\{\"value\":\"%@\"},\"totalDistCovered\":\{\"value\":\%f},\"altitude\":\{\"value\":\%d},\"acceleration\":\{\"value\":\%d},\"endTime\":\{\"value\":\%@},\"rawdata\":\{\"value\":\"%@\"},\"startTime\":\{\"value\":\%@},\"distance\":\{\"value\":\%f},\"braking\":\{\"value\":\%d},\"description\":\{\"value\":\"%@\"},\"ruleName\":\{\%@},\"eventCategoryName\":\{\"value\":\"%@\"},\"deviceType\":\{\"value\":\"%@\"},\"creationTime\":\{\"value\":\%@},\"longitude\":\{\"value\":\%.14f},\"geozoneId\":\{\%@},\"speed\":\{\"value\":\%d},\"provider\":\{\"value\":\"%@\"},\"dataReceivedTimestamp\":\{\"value\":\%@},\"gpsAge\":\{\"value\":\%d},\"currentValue\":\{\"value\":\%d},\"lbl\":\{\"value\":\%d},\"ck\":\{\"value\":\"%@\"},\"msgType\":\{\"value\":\"%@\"},\"latitude\":\{\"value\":\%.14f},\"accuracy\":\{\"value\":\%d},\"deviceNumber\":\{\"value\":\"%@\"},\"heading\":\{\"value\":\"%@\"}}}",[[accelerationVal objectAtIndex:i] integerValue],@"gps",[[totDistance objectAtIndex:i] floatValue]*1000.0,[[altitudeVal objectAtIndex:i] integerValue],[[accelerationVal objectAtIndex:i] integerValue],timeLocalEvent,@"",timeLocalEvent,[[totDistance objectAtIndex:i] floatValue]*1000.0,[[breakVal objectAtIndex:i] integerValue],@"acceleration",@"",@"acceleration",@"Mobile",timeLocalEvent,[[longitudeVal objectAtIndex:i] doubleValue],@"",[[speedVal objectAtIndex:i] integerValue],@"gps",postTime1,0,0,[[batteryPer objectAtIndex:i] integerValue],cKValue,@"event",[[latitudeVAl objectAtIndex:i] doubleValue],[[accuracyVal objectAtIndex:i] integerValue],mainDelegate.deviceId,[headingVal objectAtIndex:i]];
                            
                            
                            finalJsonString = [finalJsonString stringByAppendingString:@"\r\n"];
                            
//                            NSLog(@"posting json data %@:",finalJsonString);
                            
                            [self writeToTextFile:[NSString stringWithFormat:@"%@\r\n",finalJsonString]];
                            
                            [outputStream  write:(const uint8_t *)[finalJsonString UTF8String] maxLength:finalJsonString.length];
                            
                        }
                        
                        // Check for Threshold limit violation for braking
                        if ([[breakVal objectAtIndex:i] integerValue] >= 7) {
                            
                            brakCount++;
                            
                            finalJsonString = nil;
                            finalJsonString = [NSString stringWithFormat:@"{\"params\":\{\"thresholdValue\":\{\"value\":\%d},\"dataSource\":\{\"value\":\"%@\"},\"totalDistCovered\":\{\"value\":\%f},\"altitude\":\{\"value\":\%d},\"acceleration\":\{\"value\":\%d},\"endTime\":\{\"value\":\%@},\"rawdata\":\{\"value\":\"%@\"},\"startTime\":\{\"value\":\%@},\"distance\":\{\"value\":\%f},\"braking\":\{\"value\":\%d},\"description\":\{\"value\":\"%@\"},\"ruleName\":\{\%@},\"eventCategoryName\":\{\"value\":\"%@\"},\"deviceType\":\{\"value\":\"%@\"},\"creationTime\":\{\"value\":\%@},\"longitude\":\{\"value\":\%.14f},\"geozoneId\":\{\%@},\"speed\":\{\"value\":\%d},\"provider\":\{\"value\":\"%@\"},\"dataReceivedTimestamp\":\{\"value\":\%@},\"gpsAge\":\{\"value\":\%d},\"currentValue\":\{\"value\":\%d},\"lbl\":\{\"value\":\%d},\"ck\":\{\"value\":\"%@\"},\"msgType\":\{\"value\":\"%@\"},\"latitude\":\{\"value\":\%.14f},\"accuracy\":\{\"value\":\%d},\"deviceNumber\":\{\"value\":\"%@\"},\"heading\":\{\"value\":\"%@\"}}}",[[breakVal objectAtIndex:i] integerValue],@"gps",[[totDistance objectAtIndex:i] floatValue]*1000.0,[[altitudeVal objectAtIndex:i] integerValue],[[accelerationVal objectAtIndex:i] integerValue],timeLocalEvent,@"",timeLocalEvent,[[totDistance objectAtIndex:i] floatValue]*1000.0,[[breakVal objectAtIndex:i] integerValue],@"braking",@"",@"braking",@"Mobile",timeLocalEvent,[[longitudeVal objectAtIndex:i] doubleValue],@"",[[speedVal objectAtIndex:i] integerValue],@"gps",postTime1,0,0,[[batteryPer objectAtIndex:i] integerValue],cKValue,@"event",[[latitudeVAl objectAtIndex:i] doubleValue],[[accuracyVal objectAtIndex:i] integerValue],mainDelegate.deviceId,[headingVal objectAtIndex:i]];
                            
                            
                            finalJsonString = [finalJsonString stringByAppendingString:@"\r\n"];
                            
//                            NSLog(@"posting json data %@:",finalJsonString);
                            
                            [self writeToTextFile:[NSString stringWithFormat:@"%@\r\n",finalJsonString]];
                            
                            [outputStream  write:(const uint8_t *)[finalJsonString UTF8String] maxLength:finalJsonString.length];
                            
                        }
                        
                        //                if ([headPhoneStatus isEqualToString:@"Receiver"] && ([callStatus isEqualToString:@"CTCallStateIncoming"]||[callStatus isEqualToString:@"CTCallStateConnected"])) {
                        if (([inOrOutCall isEqualToString:@"CTCallStateIncoming"]&&[callStatus isEqualToString:@"CTCallStateConnected"])) {
                            
                            //                            inCallCount++;
                            
                            finalJsonString = nil;
                            finalJsonString = [NSString stringWithFormat:@"{\"params\":\{\"thresholdValue\":\{\"value\":\%d},\"dataSource\":\{\"value\":\"%@\"},\"totalDistCovered\":\{\"value\":\%f},\"altitude\":\{\"value\":\%d},\"acceleration\":\{\"value\":\%d},\"endTime\":\{\"value\":\%@},\"rawdata\":\{\"value\":\"%@\"},\"startTime\":\{\"value\":\%@},\"distance\":\{\"value\":\%f},\"braking\":\{\"value\":\%d},\"description\":\{\"value\":\"%@\"},\"ruleName\":\{\%@},\"eventCategoryName\":\{\"value\":\"%@\"},\"deviceType\":\{\"value\":\"%@\"},\"creationTime\":\{\"value\":\%@},\"longitude\":\{\"value\":\%.14f},\"geozoneId\":\{\%@},\"speed\":\{\"value\":\%d},\"provider\":\{\"value\":\"%@\"},\"dataReceivedTimestamp\":\{\"value\":\%@},\"gpsAge\":\{\"value\":\%d},\"currentValue\":\{\"value\":\%d},\"lbl\":\{\"value\":\%d},\"ck\":\{\"value\":\"%@\"},\"msgType\":\{\"value\":\"%@\"},\"latitude\":\{\"value\":\%.14f},\"accuracy\":\{\"value\":\%d},\"deviceNumber\":\{\"value\":\"%@\"},\"heading\":\{\"value\":\"%@\"}}}",0,@"gps",[[totDistance objectAtIndex:i] floatValue]*1000.0,[[altitudeVal objectAtIndex:i] integerValue],[[accelerationVal objectAtIndex:i] integerValue],timeLocalEvent,@"",timeLocalEvent,[[totDistance objectAtIndex:i] floatValue]*1000.0,[[breakVal objectAtIndex:i] integerValue],@"incomingcall",@"",@"incomingcall",@"Mobile",timeLocalEvent,[[longitudeVal objectAtIndex:i] doubleValue],@"",[[speedVal objectAtIndex:i] integerValue],@"gps",postTime1,0,0,[[batteryPer objectAtIndex:i] integerValue],cKValue,@"event",[[latitudeVAl objectAtIndex:i] doubleValue],[[accuracyVal objectAtIndex:i] integerValue],mainDelegate.deviceId,[headingVal objectAtIndex:i]];
                            
                            
                            finalJsonString = [finalJsonString stringByAppendingString:@"\r\n"];
//                            NSLog(@"posting json data %@:",finalJsonString);
                            
                            [self writeToTextFile:[NSString stringWithFormat:@"%@\r\n",finalJsonString]];
                            
                            [outputStream  write:(const uint8_t *)[finalJsonString UTF8String] maxLength:finalJsonString.length];
                            
                        }
                        
                        //                if ([headPhoneStatus isEqualToString:@"Receiver"] && ([callStatus isEqualToString:@"CTCallStateDialing"]||[callStatus isEqualToString:@"CTCallStateConnected"])) {
                        if (([inOrOutCall isEqualToString:@"CTCallStateDialing"]&&[callStatus isEqualToString:@"CTCallStateConnected"])) {
                            
                            //                            outCallCount++;
                            
                            finalJsonString = nil;
                            finalJsonString = [NSString stringWithFormat:@"{\"params\":\{\"thresholdValue\":\{\"value\":\%d},\"dataSource\":\{\"value\":\"%@\"},\"totalDistCovered\":\{\"value\":\%f},\"altitude\":\{\"value\":\%d},\"acceleration\":\{\"value\":\%d},\"endTime\":\{\"value\":\%@},\"rawdata\":\{\"value\":\"%@\"},\"startTime\":\{\"value\":\%@},\"distance\":\{\"value\":\%f},\"braking\":\{\"value\":\%d},\"description\":\{\"value\":\"%@\"},\"ruleName\":\{\%@},\"eventCategoryName\":\{\"value\":\"%@\"},\"deviceType\":\{\"value\":\"%@\"},\"creationTime\":\{\"value\":\%@},\"longitude\":\{\"value\":\%.14f},\"geozoneId\":\{\%@},\"speed\":\{\"value\":\%d},\"provider\":\{\"value\":\"%@\"},\"dataReceivedTimestamp\":\{\"value\":\%@},\"gpsAge\":\{\"value\":\%d},\"currentValue\":\{\"value\":\%d},\"lbl\":\{\"value\":\%d},\"ck\":\{\"value\":\"%@\"},\"msgType\":\{\"value\":\"%@\"},\"latitude\":\{\"value\":\%.14f},\"accuracy\":\{\"value\":\%d},\"deviceNumber\":\{\"value\":\"%@\"},\"heading\":\{\"value\":\"%@\"}}}",0,@"gps",[[totDistance objectAtIndex:i] floatValue]*1000.0,[[altitudeVal objectAtIndex:i] integerValue],[[accelerationVal objectAtIndex:i] integerValue],timeLocalEvent,@"",timeLocalEvent,[[totDistance objectAtIndex:i] floatValue]*1000.0,[[breakVal objectAtIndex:i] integerValue],@"outgoingcall",@"",@"outgoingcall",@"Mobile",timeLocalEvent,[[longitudeVal objectAtIndex:i] doubleValue],@"",[[speedVal objectAtIndex:i] integerValue],@"gps",postTime1,0,0,[[batteryPer objectAtIndex:i] integerValue],cKValue,@"event",[[latitudeVAl objectAtIndex:i] doubleValue],[[accuracyVal objectAtIndex:i] integerValue],mainDelegate.deviceId,[headingVal objectAtIndex:i]];
                            
                            
                            finalJsonString = [finalJsonString stringByAppendingString:@"\r\n"];
//                            NSLog(@"posting json data %@:",finalJsonString);
                            
                            [self writeToTextFile:[NSString stringWithFormat:@"%@\r\n",finalJsonString]];
                            
                            [outputStream  write:(const uint8_t *)[finalJsonString UTF8String] maxLength:finalJsonString.length];
                            
                        }
                        
                    }
                    else if (state == NO)
                        
                    {
                        if (tripEndState == YES) {
                            
                            double tripEndTime = 1000.0 * [[NSDate date] timeIntervalSince1970];
                            NSString *endTime = [NSString stringWithFormat:@"%f",tripEndTime];
                            NSArray* getUptoDecimalEndTime = [endTime componentsSeparatedByString: @"."];
                            endTime = [getUptoDecimalEndTime objectAtIndex: 0];
                            
                            // checksum for trip end event
                            
                            // Calculate checksum
                            int latLon = (int) (([[latitudeVAl lastObject] doubleValue]+[[longitudeVal lastObject] doubleValue]) * 1E6);
                            NSString *checkSumStr1 = @"1217278743473774374";
                            NSString *checkSumStr = [checkSumStr1 stringByAppendingString:[NSString stringWithFormat:@"%d",latLon]];
                            
                            NSNumber * calculatedChkSm= adlerChecksumof(checkSumStr);
                            NSString *endCkValue = [calculatedChkSm stringValue];
                            
                            
                            /////////////////////////////////////////////////////////////////////INSERT INTO LOCAL DB///////////////////////////////////////////////////////////////////////////
                            
                            storeDataDb = [FMDatabase databaseWithPath:self.localDataPath];
                            [storeDataDb open];
                            
                            [storeDataDb executeUpdate:@"INSERT INTO localData (uId,dataSource,msgType,provider,creationTime,dataReceivedTimestamp,gpsAge,totalDistCovered,rawdata,lbl,ck,longitude,latitude,deviceNumber,accuracy,speed,altitude,acceleration,braking,heading,deviceType,eventType,endTime,startTime) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",@"1",@"Mobile",@"event",@"gps",[dataCreatTime lastObject],postTime1,@"0",[totDistance lastObject],@"0",[batteryPer lastObject],endCkValue,[longitudeVal lastObject],[latitudeVAl lastObject],mainDelegate.deviceId,[accuracyVal lastObject],[speedVal lastObject],[altitudeVal lastObject],[accelerationVal lastObject],[breakVal lastObject],[headingVal lastObject],@"Mobile",@"TripEnd",endTime,startEventTme, nil];
                            
                            [storeDataDb close];
                            
                            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            
                            
                            // TripEnd JSON to server
                            stopEventJson = nil;
                            stopEventJson = [NSString stringWithFormat:STOPEVENTJSON,0,@"network",[[totDistance lastObject] floatValue]*1000.0,[[altitudeVal lastObject] integerValue],[[accelerationVal lastObject] integerValue],endTime,@"",startEventTme,[[totDistance lastObject] floatValue]*1000.0,[[breakVal lastObject] integerValue],@"TripEnd",@"",@"TripEnd",@"Mobile",[dataCreatTime lastObject],[[longitudeVal lastObject] doubleValue],@"",[[speedVal lastObject] integerValue],@"network",postTime1,0,[[batteryPer lastObject] integerValue],endCkValue,@"event",[[latitudeVAl lastObject] doubleValue],[[accuracyVal lastObject] integerValue],mainDelegate.deviceId,[headingVal lastObject]];
                            
                            
                            stopEventJson = [stopEventJson stringByAppendingString:@"\r\n"];
//                            NSLog(@"Stop json data %@:",stopEventJson);
                            
                            [self writeToTextFile:[NSString stringWithFormat:@"%@\r\n",stopEventJson]];
                            
                            [outputStream  write:(const uint8_t *)[stopEventJson UTF8String] maxLength:stopEventJson.length];
                            
                            tripEndDataSendCount++;
                            tripEndState = NO;
                            
                            
                            // remove any old values from user default
                            if([[NSUserDefaults standardUserDefaults] objectForKey:@"distanceTravelled"] != nil) {
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"distanceTravelled"];
                            }
                            
                            if([[NSUserDefaults standardUserDefaults] objectForKey:@"heading"] != nil) {
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"heading"];
                            }
                            
                            
                            // for trip summary view
                            
                            TripSummaryEntity *tripSummaryEntity = [[TripSummaryEntity alloc] init];
//                            TripSummaryDatabase* tripSummaryDatabase = [[TripSummaryDatabase alloc] init];
                            
                            NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
                            [DateFormatter setDateFormat:@"yyyy-MM-dd"];
                            NSString *currentDate = [[NSString alloc] init];
                            currentDate = [DateFormatter stringFromDate:[NSDate date]];
                            
                            //
                            
                            summEndTime = CFAbsoluteTimeGetCurrent();
                            float deltaTimeInSeconds = summEndTime - summStartTime;
                            
                            tripSummaryEntity.deviceNumber = mainDelegate.deviceId;
                            tripSummaryEntity.acceleration = [@(acclCount) stringValue];
                            tripSummaryEntity.braking = [@(brakCount) stringValue];
                            tripSummaryEntity.overspeed = [@(overSpeedCount) stringValue];
                            tripSummaryEntity.incomingCall = [@(inCallCount) stringValue];
                            tripSummaryEntity.outgoingCall = [@(outCallCount) stringValue];
                            tripSummaryEntity.totalDistCovered = [NSString stringWithFormat:@"%f",[[totDistance lastObject] floatValue]*1000.0];
                            tripSummaryEntity.totalDuration = [NSString stringWithFormat:@"%f",deltaTimeInSeconds];
                            tripSummaryEntity.currentDate = currentDate;
                            
//                            NSString *insertedText = nil;
//                            insertedText = [NSString stringWithFormat:@"%@, %@, %@, %@, %@, %@, %@, %@, %@",tripSummaryEntity.deviceNumber,tripSummaryEntity.acceleration, tripSummaryEntity.braking, tripSummaryEntity.overspeed, tripSummaryEntity.incomingCall, tripSummaryEntity.outgoingCall, tripSummaryEntity.totalDistCovered, tripSummaryEntity.totalDuration, tripSummaryEntity.currentDate];
//                            NSLog(@"TripSummary Values Inserted : %@",insertedText);
//                            
//                            UIAlertView *
//                            alert = [[UIAlertView alloc] initWithTitle:@"Inserted Values"
//                                                                            message:insertedText
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"OK"
//                                                                  otherButtonTitles:nil];
//                            [alert show];
                            
//                            [tripSummaryDatabase insertTripSummaryDb: tripSummaryEntity];
                            [[TripSummaryDB sharedInstance]updateTripSummaryDB:tripSummaryEntity];
                            
                            //reset counters
                            overSpeedCount = 0;
                            acclCount = 0;
                            brakCount = 0;
                            inCallCount = 0;
                            outCallCount = 0;
                            summStartTime = 0.0;
                            //
                            
                            /////////////////////////////////////////////Delete all data from local DB if TripEnd event is sent/////////////////////////////////////////////////////////////////
                            
                            NSLog(@"GV DB Path == %@", self.localDataPath);
                            
                            storeDataDb = [FMDatabase databaseWithPath:self.localDataPath];
                            [storeDataDb open];
                            
                            [storeDataDb executeUpdate:@"DELETE FROM localData"];
                            
                            [storeDataDb close];
                            
                            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                            
                        }else
                        {
                            CLController = nil;
                            CLController.delegate = nil;
                            
                            // remove any old values from user default
                            if([[NSUserDefaults standardUserDefaults] objectForKey:@"distanceTravelled"] != nil) {
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"distanceTravelled"];
                            }
                            
                            if([[NSUserDefaults standardUserDefaults] objectForKey:@"heading"] != nil) {
                                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"heading"];
                            }
                            
                            
                            [NSObject cancelPreviousPerformRequestsWithTarget:self
                                                                     selector:@selector(checkDataUploadType)
                                                                       object:nil];
                            
                            //                            [NSObject cancelPreviousPerformRequestsWithTarget:self
                            //                                                                     selector:@selector(startLocationUpdate)
                            //                                                                       object:nil];
                            
                            [inputStream close];
                            [outputStream close];
                            [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                                                   forMode: NSDefaultRunLoopMode];
                            
                            [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                                                    forMode: NSDefaultRunLoopMode];
                            
                            
                            [outputStream setDelegate:nil];
                            [inputStream setDelegate:nil];
                            //[outputStream release];
                            //[inputStream release];
                            outputStream = nil;
                            inputStream = nil;
                            
                            
                            // delete all records from db
                            [dbDataPosting executeUpdate:@"DELETE FROM collectData"];
                            [dbDataPosting close];
                            
                            
                        }
                        
                    }
                }
                
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
            }
            @finally {
                
            }
            
        }
        
    }
    
    [self closeStream];
}

#pragma mark for crashed trip
-(void)sendTripEndEventForLastCrashedTrip
{
    [self initNetworkForCrashedTrip];
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    double dataPostTime = 1000.0 * [[NSDate date] timeIntervalSince1970];
    NSString *postTime1 = [NSString stringWithFormat:@"%f",dataPostTime];
    
    NSArray* getUptoDecimal = [postTime1 componentsSeparatedByString: @"."];
    postTime1 = [getUptoDecimal objectAtIndex: 0];
    
    double tripEndTime = 1000.0 * [[NSDate date] timeIntervalSince1970];
    NSString *endTime = [NSString stringWithFormat:@"%f",tripEndTime];
    NSArray* getUptoDecimalEndTime = [endTime componentsSeparatedByString: @"."];
    endTime = [getUptoDecimalEndTime objectAtIndex: 0];
    
    
    // TripEnd JSON to server
    NSString *tripEndJson = nil;
    tripEndJson = [NSString stringWithFormat:STOPEVENTJSON,0,@"network",[[localDBDictionary valueForKey:@"totalDistCovered"] floatValue]*1000.0,[[localDBDictionary valueForKey:@"altitude"] integerValue],[[localDBDictionary valueForKey:@"acceleration"] integerValue],[localDBDictionary valueForKey:@"endTime"],@"",[localDBDictionary valueForKey:@"startTime"],[[localDBDictionary valueForKey:@"totalDistCovered"] floatValue]*1000.0,[[localDBDictionary valueForKey:@"braking"] integerValue],@"TripEnd",@"",@"TripEnd",@"Mobile",[localDBDictionary valueForKey:@"creationTime"],[[localDBDictionary valueForKey:@"longitude"] doubleValue],@"",[[localDBDictionary valueForKey:@"speed"] integerValue],@"network",postTime1,0,[[localDBDictionary valueForKey:@"lbl"] integerValue],[localDBDictionary valueForKey:@"ck"],@"event",[[localDBDictionary valueForKey:@"latitude"] doubleValue],[[localDBDictionary valueForKey:@"accuracy"] integerValue],mainDelegate.deviceId,[localDBDictionary valueForKey:@"heading"]];
    
    
    tripEndJson = [tripEndJson stringByAppendingString:@"\r\n"];
    
//    NSLog(@"Stop json data %@:",tripEndJson);
    
    [outputStream  write:(const uint8_t *)[tripEndJson UTF8String] maxLength:tripEndJson.length];
    
    [self closeStream];
    
}

-(void)initNetworkForCrashedTrip
{
    [self getDataFromDb];
    
    if (port==0) {
        port = 9091;
    }
    if ([self.address length]==0) {
//        self.address = @"54.193.95.129";
        self.address = @"54.183.64.73";
    }
    
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef) self.address, port, NULL, &writeStream);
    
	inputStream = (__bridge NSInputStream *)readStream;
	outputStream = (__bridge NSOutputStream *)writeStream;
	[inputStream setDelegate:self];
	[outputStream setDelegate:self];
	[inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	[outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
	[inputStream open];
	[outputStream open];
}

#pragma mark handle stream
- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
    
	NSLog(@"stream event %i", streamEvent);
	
	switch (streamEvent) {
			
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
		case NSStreamEventHasBytesAvailable:
            
			if (theStream == inputStream) {
				
				uint8_t buffer[1024];
				int len;
				
				while ([inputStream hasBytesAvailable]) {
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0) {
						
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						
						if (nil != output) {
                            
							NSLog(@"server said: %@", output);
							
						}
					}
				}
			}
			break;
            
			
		case NSStreamEventErrorOccurred:
			
			NSLog(@"Can not connect to the host!");
            
			break;
			
		case NSStreamEventEndEncountered:
            
            [theStream close];
            [theStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            theStream = nil;
			
			break;
		default:
			NSLog(@"Unknown event");
	}
    
}

-(void)closeStream
{
    [outputStream close];
    [inputStream close];
    
    [inputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                           forMode: NSDefaultRunLoopMode];
    
    [outputStream removeFromRunLoop:[NSRunLoop currentRunLoop]
                            forMode: NSDefaultRunLoopMode];
    
    
    [outputStream setDelegate:nil];
    [inputStream setDelegate:nil];
    //[outputStream release];
    //[inputStream release];
    outputStream = nil;
    inputStream = nil;
    
}

#pragma mark calculate checksum value

static NSNumber * adlerChecksumof(NSString *str)
{
    unichar chr;
    NSMutableData *data= [[NSMutableData alloc]init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    for (int i = 0; i < ([str length] / 2); i++)
    {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [data appendBytes:&whole_byte length:1];
    }
    
    for (int i=0; i<[str length]; i++) {
        chr = [str characterAtIndex:i];
        //        NSLog(@"ascii value %d", chr);
    }
    
    int16_t a=1;
    int16_t b=0;
    for (int i=0; i<[str length]; i++)
    {
        chr = [str characterAtIndex:i];
        a+= chr;
        b+=a;
    }
    
    int32_t adlerChecksum= b*65536+a;
    return @(adlerChecksum);
}




#pragma mark DB update notification

- (void)receiveDBNotification:(NSNotification *) notification
{
    NSLog(@"DB modification notification, please update database!");
    
    [self getDataFromDb];
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Method writes a string to a text file
-(void) writeToTextFile:(NSString *)textToWrite{
    
    NSString *str = textToWrite; //get text from textField
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/textfile.txt",
                          documentsDirectory];
    
    // check for file exist
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:fileName]) {
        
        // the file doesn't exist,we can write out the text using the  NSString convenience method
        
        NSError *error = noErr;
        BOOL success = [str writeToFile:fileName atomically:YES encoding:NSUTF8StringEncoding error:&error];
        if (!success) {
            // handle the error
            NSLog(@"%@", error);
        }
        
    } else {
        
        // the file already exists, append the text to the end
        
        // get a handle
        NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:fileName];
        
        // move to the end of the file
        [fileHandle seekToEndOfFile];
        
        // convert the string to an NSData object
        NSData *textData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        // write the data to the end of the file
        [fileHandle writeData:textData];
        
        // clean up
        [fileHandle closeFile];
    }
    
}

- (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer)
    {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}


@end
