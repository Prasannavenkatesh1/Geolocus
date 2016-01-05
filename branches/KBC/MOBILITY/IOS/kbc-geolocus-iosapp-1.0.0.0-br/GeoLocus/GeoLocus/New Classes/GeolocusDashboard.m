//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "GeolocusDashboard.h"
#import <sqlite3.h>
#import "DashboardDatabase.h"
#import "DashboardController.h"
#import "DashboardEntity.h"
#import "RegistrationController.h"
#import "RegistrationEntity.h"
#import "RegistrationDatabase.h"
#import "ScoringPageController.h"
#import "ScoringEntity.h"
#import "GeoLocusViewController.h"
#import "Constant.h"
#import "LeaderBoardEntity.h"
#import "LeaderBoardController.h"
#import "SettingsEntity.h"
#import "TripSummaryEntity.h"
#import "TripSummaryDatabase.h"
#import "GetQuoteController.h"
#import "SendingEmergencyInfo.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GeoLocus-Swift.h"
#import "TripSummaryDB.h"

@interface GeolocusDashboard (){
    
    NSString *hostName;
    NSString *port;
    NSString *protocols;
    NSString *transValue;
    NSString *collValue;
    NSString *provider;
    NSString *minimumNotifyDistance;
    NSString *minimumNotifyTime;
    NSDictionary *settingsData;
    
    NSString *voicsStatus;

}
@end

@implementation GeolocusDashboard

@synthesize CLController;
@synthesize webView;

BOOL isSwitchState;
BOOL manualTripStarted;

//NSTimeInterval howRecent;
//NSDate* eventDate;

-(void) callDashboard: (NSString *)deviceId : (NSString *) countryCode {
    
//     Register Notification for autostart
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(autoStart:)
                                                 name:@"autoStart"
                                               object:nil];
    
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    
    NSLog(@"inside callDashboard method.");
    NSLog(@"Device Id : %@", deviceId);
    NSLog(@"Country Code : %@", countryCode);
    
    //get device id
    mainDelegate.deviceId = deviceId;
    
    //get country code based on device id
    mainDelegate.countryCode = countryCode;
    
    
    NSString *counterName = mainDelegate.countryCode;
    
    NSLog(@"country name in plugin: %@", counterName);
    
    //for trip start/stop
    
    //    [self intervalBasedLocationUpdate];
    
    CLController = [[CoreLocationController alloc] init];
    CLController.delegate = self;
    CLController.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //  CLController.locMgr.distanceFilter = kCLDistanceFilterNone;
    
#ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        [CLController.locMgr requestAlwaysAuthorization];
    }
#endif
    
    [CLController.locMgr startUpdatingLocation];
    [CLController.locMgr startUpdatingHeading];
    //  [CLController.locMgr startMonitoringSignificantLocationChanges];
    
    
    
//    //set speed threshold limit based on country code
    
    if ([mainDelegate.countryCode isEqualToString:@"US"])
    {
        mainDelegate.speedLimit = 89.0;
        
    } else {
        
        mainDelegate.speedLimit = 60.0;
        
    }
    
    isSwitchState = YES;
    
    NSLog(@"autoStart Global Auto Trip : %d",mainDelegate.globalAutoTrip);
    NSLog(@"manualTripStarted : %d",manualTripStarted);
    
//    if (mainDelegate.globalAutoTrip == 0) {
    if (manualTripStarted == 0) {
        [self performSelector:@selector(autoTripStart) withObject:nil afterDelay:10.0];
    }
    
    
}

-(void)intervalBasedLocationUpdate
{
    CLController = [[CoreLocationController alloc] init];
    CLController.delegate = self;
    CLController.locMgr.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //  CLController.locMgr.distanceFilter = kCLDistanceFilterNone;
    [CLController.locMgr startUpdatingLocation];
    [CLController.locMgr startUpdatingHeading];
    //  [CLController.locMgr startMonitoringSignificantLocationChanges];
    
    [self performSelector:@selector(intervalBasedLocationUpdate) withObject:Nil afterDelay:10.0];
    
}

//-(void) insertRegistrationDetails{
//    
//    
//    NSString* username = [command.arguments objectAtIndex:0];
//    NSString* password = [command.arguments objectAtIndex:1];
//    
//    NSString* firstName = [command.arguments objectAtIndex:2];
//    NSString* lastName = [command.arguments objectAtIndex:3];
//    NSString* displayName = [command.arguments objectAtIndex:4];
//    NSString* countryName = [command.arguments objectAtIndex:5];
//    NSString* phoneNumber = [command.arguments objectAtIndex:6];
//    NSString* gender = [command.arguments objectAtIndex:7];
//    NSString* isAgree = [command.arguments objectAtIndex:8];
//    
//    NSString* key = [command.arguments objectAtIndex:9];
//    
//    RegistrationEntity *registrationEntity = [[RegistrationEntity alloc] init];
//    
//    registrationEntity.userName = username;
//    registrationEntity.password = password;
//    registrationEntity.key = key;
//    registrationEntity.firstName = firstName;
//    registrationEntity.lastName = lastName;
//    registrationEntity.displayName = displayName;
//    registrationEntity.countryName = countryName;
//    registrationEntity.phoneNumber = phoneNumber;
//    registrationEntity.gender = gender;
//    registrationEntity.isAgree = isAgree;
//    
//    RegistrationController* registrationController = [[RegistrationController alloc] init];
//    
//    NSDictionary *result = [registrationController validateUser: registrationEntity];
//    
//    
//    NSLog(@"result in insertRegistrationDetails method of plugin= %@",result);
//    
//    CDVPluginResult *pluginResult = [ CDVPluginResult
//                                     resultWithStatus    : CDVCommandStatus_OK messageAsDictionary:result];
//    
//    
//    [self.commandDelegate sendPluginResult:pluginResult callbackId:command.callbackId];
//    
//}


-(BOOL) checkUserDetails {
    
    NSLog(@"inside checkUserDetails method.");
    
    BOOL result;
    NSString *resultInsuredID = [[NSString alloc] init];
    RegistrationDatabase* registrationDatabase = [[RegistrationDatabase alloc] init];
    RegistrationEntity* registrationEntity = [[RegistrationEntity alloc] init];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Date: %@",currentDate);
    
    registrationEntity = [registrationDatabase fetchDataByDate:currentDate];
    
    if(registrationEntity != NULL) {
        
        resultInsuredID = registrationEntity.insuredID;
        
        NSLog(@"fetched insured id= %@",resultInsuredID);
        
        if ((resultInsuredID != NULL) && ([resultInsuredID intValue] != 0)) {
            
            
            result = YES;
            
        } else {
            result = NO;
        }
    } else {
        result = NO;
    }
    
    return result;
    
}


-(NSDictionary *) weeklyScoringDetails:(NSString *)accountId :(NSString *)accountCode :(NSString *)resultInsuredID :(NSString *)resultToken  {
    
    
    NSLog(@"inside weeklyScoringDetails method.");
    
    RegistrationDatabase* registrationDatabase = [[RegistrationDatabase alloc] init];
    resultInsuredID = [registrationDatabase fetchLastInsuredID];
    NSLog(@"fetched insured id= %@",resultInsuredID);
    
    accountId = [registrationDatabase fetchAccountIdByInsuredID: resultInsuredID];
    accountCode = [registrationDatabase fetchAccountCodeByInsuredID: resultInsuredID];
    
    
    ScoringEntity *scoringEntity = [[ScoringEntity alloc] init];
    
    ScoringPageController* scoringPageController = [[ScoringPageController alloc] init];
    
    if ((resultInsuredID != NULL) && ([resultInsuredID intValue] != 0)) {
        
        
        resultToken = [registrationDatabase fetchTokenByInsuredID: resultInsuredID];
        
        scoringEntity = [scoringPageController getweeklyScoringData: resultInsuredID: resultToken: accountId: accountCode];
        
        
    } else {
        NSLog(@"Invalid insured ID.");
    }
    
    NSDictionary *weeklyResult = [NSDictionary dictionaryWithObjectsAndKeys:scoringEntity.weeklyAcceleration,@"weeklyAcceleration", [NSString stringWithFormat:@"%@",scoringEntity.weeklyBraking],@"weeklyBraking", [NSString stringWithFormat:@"%@",scoringEntity.weeklyCornering],@"weeklyCornering",[NSString stringWithFormat:@"%@",scoringEntity.weeklySpeeding],@"weeklySpeeding",[NSString stringWithFormat:@"%@",scoringEntity.weeklyTimeOfDay],@"weeklyTimeOfDay", nil];
    
    
    return weeklyResult;
}

-(NSDictionary *) leaderBoardDetails {
    
    NSLog(@"inside leaderBoardDetails method.");
    
    NSString *resultToken = [[NSString alloc] init];
    
    NSString *accountId = [[NSString alloc] init];
    
    NSString *resultInsuredID = [[NSString alloc] init];
    RegistrationDatabase* registrationDatabase = [[RegistrationDatabase alloc] init];
    resultInsuredID = [registrationDatabase fetchLastInsuredID];
    NSLog(@"fetched insured id= %@",resultInsuredID);
    
    LeaderBoardController* leaderBoardController = [[LeaderBoardController alloc] init];
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    //get device id
    mainDelegate.deviceId = [registrationDatabase fetchLastDeviceID];
    //    NSLog(@"Device ID:%@",mainDelegate.deviceId);
    
    //get country code based on device id
    mainDelegate.countryCode = [registrationDatabase fetchCountryCodeByDeviceID:mainDelegate.deviceId];
    //    NSLog(@"%@",mainDelegate.countryCode);
    
    
    NSString *counterName = mainDelegate.countryCode;
    
    NSLog(@"country name in plugin: %@", counterName);
    
    NSMutableDictionary *resultantObjectArray = [[NSMutableDictionary alloc] init];
    
    if ((resultInsuredID != NULL) && ([resultInsuredID intValue] != 0)) {
        
        resultToken = [registrationDatabase fetchTokenByInsuredID: resultInsuredID];
        
        accountId = [registrationDatabase fetchAccountIdByInsuredID: resultInsuredID];
        
        //resultantObjectArray = [leaderBoardController getLeaderBoardData: resultInsuredID: resultToken: counterName];
        
        
        resultantObjectArray = [leaderBoardController getLeaderBoardData: resultInsuredID: resultToken: counterName: accountId];
        
        NSLog(@"resultantObjectArray in plugin= %@", resultantObjectArray);
        
        NSLog(@"history's data in plugin= %@", [resultantObjectArray valueForKey:@"historyData"]);
        
        
    } else {
        NSLog(@"Invalid insured ID.");
    }
    
    return resultantObjectArray;
    
}

-(void) setSettingsData {
    
    AppDelegateSwift *mainDelegate = (AppDelegateSwift *)[[UIApplication sharedApplication] delegate];
    
    SettingsEntity* settingsEntity = [[SettingsEntity alloc] init];
    settingsEntity.hostname = @"54.183.64.73";
    settingsEntity.port = @"9091";
    settingsEntity.frequency = @"20";
    settingsEntity.protocols = @"HTTP,HTTPS,TCP/IP"; //@"https";
    settingsEntity.datauploadtype = @"WiFi,Mobile Data"; //@"Wi-Fi";
    settingsEntity.transmissioninterval = @"30"; //@"30 sec";
    settingsEntity.collectioninterval = @"10"; //@"5 sec"
    settingsEntity.notifydistance = @"20";//@"5 meters";
    settingsEntity.notifytime = @"20"; //@"5 sec";
    settingsEntity.provider = @"GPS,Network Provider,Both"; //"@"GPS";
    settingsEntity.providervalue = @"GPS or Network or Both";
    settingsEntity.voiceAlert = mainDelegate.vAlert;
    
    NSLog(@"host Settings %@", settingsEntity.hostname);
    NSLog(@"Voice Alert Settings %@", settingsEntity.voiceAlert);
    
    GeoLocusViewController* geolocusViewController = [[GeoLocusViewController alloc] init];
    [geolocusViewController storeDataIntoDb: settingsEntity];
}



-(NSDictionary*) getSettingsData{
    
    GeoLocusViewController* geolocusViewController = [[GeoLocusViewController alloc] init];
    
    settingsData = [geolocusViewController getSettingsData];
    
//    NSLog(@"The value in settings Data is : ",settingsData);
    
    return settingsData;
}


-(void)startBGServices:(NSString *)command
{
//    BOOL accessGranted = [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorized;
//    NSLog(@"%d",accessGranted);
    
     NSLog(@"Entering startBGServices");
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"Value of Global Auto Trip at startBGServices is : %d", mainDelegate.globalAutoTrip);
    
    NSLog(@"Value of isSwitchState is : %d", isSwitchState);
    
    if ([command  isEqualToString:@"Start"] && isSwitchState) {
        
        manualTripStarted = YES;

//        Reset total distance travelled
        CLController.fltDistanceTravelled = 0.0;

        
        GeoLocusViewController *settingController = [[GeoLocusViewController alloc]init];
        
        GeoLocusViewController *voiceController = [[GeoLocusViewController alloc]init];
        settingsData = [voiceController getSettingsData];
        voicsStatus = [settingsData valueForKey:@"voiceStatusKey"];
        
        if ([voicsStatus isEqualToString:@"Enabled"]) {
            
            AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Trip started"];
            
            if (!self.synthesizer.isSpeaking)
            {
                utterance.rate = 0.3;
                utterance.volume = 1.0;
                [self.synthesizer speakUtterance:utterance];
            }
        }
        
        mainDelegate.globalAutoTrip = NO;
        
        [settingController viewDidLoad];
        
        [settingController enabledStateChanged];
        
        isSwitchState = NO;
        
    }
}


-(void)autoTripStart
{
    
    AppDelegateSwift *mainDelegate = (AppDelegateSwift *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"Value of Global Auto Trip at autoTripStart is : %d", mainDelegate.globalAutoTrip);
    
//    NSLog(@"Value of Global tripStarted is : %d", mainDelegate.tripStarted);
    
//    if (isSwitchState && mainDelegate.tripStarted == false) {
    
    if (isSwitchState) {
        
        manualTripStarted = NO;
        
        //Reset total distance travelled
        CLController.fltDistanceTravelled = 0.0;

        GeoLocusViewController *settingController = [[GeoLocusViewController alloc]init];
        settingsData = [settingController getSettingsData];
        voicsStatus = [settingsData valueForKey:@"voiceStatusKey"];
        
        mainDelegate.vAlert = voicsStatus;

        mainDelegate.globalAutoTrip = YES;
        
        NSLog(@"Value of After GB is : %d" ,mainDelegate.globalAutoTrip);
        
        [settingController viewDidLoad];
        
//        [settingController enabledStateChanged];
        
        isSwitchState = NO;
    }
}

-(void)stopBGServices:(NSString *)command
{

    GeoLocusViewController *settingController = [[GeoLocusViewController alloc]init];
    [settingController stopServices];
    
    AppDelegateSwift *mainDelegate = (AppDelegateSwift *)[[UIApplication sharedApplication] delegate];
    
    NSLog(@"Value of Global Auto Trip at stopBGServices is : %d", mainDelegate.globalAutoTrip);
    
    if ([command  isEqualToString:@"Stop"]) {
        
        manualTripStarted = NO;
    
        isSwitchState = YES;
        mainDelegate.globalAutoTrip = YES;
    
        GeoLocusViewController *voiceController = [[GeoLocusViewController alloc]init];
        settingsData = [voiceController getSettingsData];
        voicsStatus = mainDelegate.vAlert;//[settingsData valueForKey:@"voiceStatusKey"];
    
        if ([voicsStatus isEqualToString:@"Enabled"]) {

            if (self.synthesizer.isSpeaking)
            {
                [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
                [self.synthesizer speakUtterance:utterance];
                [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
            }
    
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Trip stopped"];
        
        if (!self.synthesizer.isSpeaking)
        {
            
            utterance.rate = 0.3;
            utterance.volume = 1.0;
            [self.synthesizer speakUtterance:utterance];
        }
    }
    
    //Reset total distance travelled
    CLController.fltDistanceTravelled = 0.0;
        
    //Change the start button
//    mainDelegate.autoButtonChange = @"Disabled";
        
    }

}

- (void)autoStart:(NSNotification *) notification
{
    NSLog(@"Trip auto started!");
}


-(NSDictionary *) tripSummaryDetails {
    
    RegistrationDatabase* registrationDatabase = [[RegistrationDatabase alloc] init];
    
    //get device id
    NSString *deviceNumber = [[NSString alloc] init];
    NSString *counterName = [[NSString alloc] init];
    
    deviceNumber = [registrationDatabase fetchLastDeviceID];
    counterName = [registrationDatabase fetchCountryCodeByDeviceID:deviceNumber];
    
    
    TripSummaryEntity *tripSummaryEntity = [[TripSummaryEntity alloc] init];
//    TripSummaryDatabase* tripSummaryDatabase = [[TripSummaryDatabase alloc] init];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
//    tripSummaryEntity.deviceNumber = @"1095-919500053376";
//    tripSummaryEntity.acceleration = @"6";
//    tripSummaryEntity.braking = @"3";
//    tripSummaryEntity.overspeed = @"8";
//    tripSummaryEntity.incomingCall = @"4";
//    tripSummaryEntity.outgoingCall = @"2";
//    tripSummaryEntity.totalDistCovered = @"2745";
//    tripSummaryEntity.totalDuration = @"864567654646";
//    tripSummaryEntity.currentDate = currentDate;
    
    tripSummaryEntity.deviceNumber = @"0";
    tripSummaryEntity.acceleration = @"0";
    tripSummaryEntity.braking = @"0";
    tripSummaryEntity.overspeed = @"0";
    tripSummaryEntity.incomingCall = @"0";
    tripSummaryEntity.outgoingCall = @"0";
    tripSummaryEntity.totalDistCovered = @"0";
    tripSummaryEntity.totalDuration = @"0";
    tripSummaryEntity.currentDate = currentDate;
    
    TripSummaryEntity *tripSummaryEntity1 = [[TripSummaryDB sharedInstance] fetchLatestTripData:deviceNumber counterName:counterName];
    
    if (tripSummaryEntity1.acceleration) {
        tripSummaryEntity = tripSummaryEntity1;
    }
    
//    tripSummaryEntity = [tripSummaryDatabase fetchLatestTripData:deviceNumber counterName:counterName];//fetchLatestTripData: deviceNumber counterName: counterName];
    
    NSLog(@"Trip Summary Value is : %@,%@,%@,%@,%@,%@,%@",tripSummaryEntity.acceleration, tripSummaryEntity.braking, tripSummaryEntity.overspeed, tripSummaryEntity.incomingCall, tripSummaryEntity.outgoingCall, tripSummaryEntity.totalDistCovered, tripSummaryEntity.totalDuration);
    
    NSDictionary *tripSummaryResult = [NSDictionary dictionaryWithObjectsAndKeys:tripSummaryEntity.acceleration,@"tripAcceleration", [NSString stringWithFormat:@"%@",tripSummaryEntity.braking],@"tripBraking", [NSString stringWithFormat:@"%@",tripSummaryEntity.overspeed],@"tripOverspeed",[NSString stringWithFormat:@"%@",tripSummaryEntity.incomingCall],@"tripIncomingCall",[NSString stringWithFormat:@"%@",tripSummaryEntity.outgoingCall],@"tripOutgoingCall",[NSString stringWithFormat:@"%@",tripSummaryEntity.totalDistCovered],@"tripTotalDistCovered",[NSString stringWithFormat:@"%@",tripSummaryEntity.totalDuration],@"tripTotalDuration",[NSString stringWithFormat:@"%@",tripSummaryEntity.currentDate],@"tripDate", nil];
    
    return tripSummaryResult;

}


#pragma mark location error handling
- (void)locationError:(NSError *)error {
	NSLog(@"%@",[error description]);
}

#pragma mark Audio
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
