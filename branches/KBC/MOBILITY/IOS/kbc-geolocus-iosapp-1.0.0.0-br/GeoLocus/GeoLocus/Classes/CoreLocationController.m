
//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "CoreLocationController.h"
#import <AVFoundation/AVFoundation.h>
//#import "AppDelegate.h"
#import "GeoLocusViewController.h"
#import "Constant.h"
#import "GeolocusDashboard.h"
#import "Constant.h"
#import "GeoLocus-Swift.h"
#import "Datausage.h"
@class GlobalConstants;

#define kRequiredAccuracy 70.0 //meters
#define kMaxAge 20.0 //seconds
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))

#define M_PI   3.14159265358979323846264338327950288   /* pi */

@interface CoreLocationController () <AVSpeechSynthesizerDelegate>

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end

@implementation CoreLocationController

@synthesize locMgr, delegate, timer;
@synthesize lastLocation,lastCoordinate;
@synthesize autoStopController;
@synthesize motionType;
@synthesize fltDistanceTravelled;
@synthesize speedArray;
@synthesize locSpeedArray;

BOOL autoStartState = NO;
BOOL brakAlert = YES;
BOOL acclAlert = YES;
BOOL speedVAlert = YES;
BOOL hasBeenRun = YES;
BOOL wasPlaying = NO;

int counter = 0;


NSTimeInterval howRecent;
NSDate* eventDate;

NSString *headingDirection = nil;

- (id)init {
	self = [super init];
	
	if(self != nil) {
        
		self.locMgr = [[CLLocationManager alloc] init];
		self.locMgr.delegate = self;
        
        speedArray = [[NSMutableArray alloc]init];
        locSpeedArray = [[NSMutableArray alloc]init];
        
        iPodMusicPlayer = [[MPMusicPlayerController alloc] init];

	}
	
	return self;
}

#pragma mark get data from DB

-(void)getDBPath
{
    // Register Notification for database update
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(bBNotification:)
                                                 name:@"bBNotification"
                                               object:nil];
    
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
    
}

-(void)getDataFromDb
{
    [db open];
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
    
    while ([rs next]) {
        NSLog(@"%@",
              [rs stringForColumn:@"hostname"]);
        
        
        collectionInterval = [rs stringForColumn:@"collectioninterval"];
        NSString *collectionNumberString;
        NSScanner *collectionScanner = [NSScanner scannerWithString:collectionInterval];
        NSCharacterSet *collectionNumbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
        [collectionScanner scanUpToCharactersFromSet:collectionNumbers intoString:NULL];
        [collectionScanner scanCharactersFromSet:collectionNumbers intoString:&collectionNumberString];
        collectIntervalValue = [collectionNumberString integerValue];
        
    }
    
    [db close];
    
    [self sqliteDataBaseCode];
    
}

-(void)sqliteDataBaseCode
{
    NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPath objectAtIndex:0];
    databasePath = [documentDir stringByAppendingPathComponent:@"collectData.sqlite"];
    
    [self checkAndCreateDatabase];

/*    // to store data locally
    storeDataPath = [documentDir stringByAppendingPathComponent:@"storeData.sqlite"];
    [self createDatabaseForStoreData];
*/
}

-(void)checkAndCreateDatabase
{
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:databasePath];
    if(success) return;
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"collectData.sqlite"];
    [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
}


#pragma mark AVSpeech delegates
- (AVSpeechSynthesizer *)synthesizer
{
    if (!_synthesizer)
    {
        _synthesizer = [[AVSpeechSynthesizer alloc] init];
        _synthesizer.delegate = self;
    }
    return _synthesizer;
}

- (void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance
{
    if(wasPlaying){
        [iPodMusicPlayer play];
        wasPlaying = NO;
    }
}


#pragma mark location services
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
  
  
  NSDictionary *datausagedict = [Datausage getDatas];
  NSLog(@"Timestamp :%@",newLocation.timestamp);
  NSLog(@"datausagedict :%@",datausagedict);
  
  
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
        

        NSLog(@"%@",@"inside location manager");
        AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
        
        audioSession = [AVAudioSession sharedInstance];
    
        //get voice alert state
        voicsStatus = mainDelegate.vAlert;
        
        [self getDBPath];
        [self getDataFromDb];
        
        double lat = 0.0;
        lat = newLocation.coordinate.latitude;
        NSString *latitude = @"";
        latitude = [NSString stringWithFormat:@"%.14f",lat];
        
        double lon = 0.0;
        lon = newLocation.coordinate.longitude;
        NSString *longitude = @"";
        longitude = [NSString stringWithFormat:@"%.14f",lon];
        
        double alti = 0.0;
        alti = newLocation.altitude;
        NSString *altitude = [NSString stringWithFormat:@"%g",alti];
        
        double accur = 0.0;
        accur = newLocation.horizontalAccuracy;
        NSString *accuracy = [NSString stringWithFormat:@"%g",accur];
    
        //******************** Calculate autotrip detection
        
        //store speed into locSpeedArray;
        [locSpeedArray addObject:[NSString stringWithFormat:@"%.2f",newLocation.speed*3.6f]];
        
        float newLocSpeed = 0.0;
        float newLocSum = 0.0;
        
        for(int i=0; i < [locSpeedArray count]; i++)
        {
            newLocSum += [[locSpeedArray objectAtIndex:i] floatValue];
        }
        NSLog(@"Value of newLocSum is : %f" ,newLocSum);

        if ([locSpeedArray count] == 5)
        {
            newLocSpeed = newLocSum/[locSpeedArray count];

            [locSpeedArray removeAllObjects];
            locSpeedArray = [[NSMutableArray alloc]init];
        }
        
        NSLog(@"Value of newLocSpeed is : %f" ,newLocSpeed);

        self.motionType = nil;
        
        
        if (newLocation.speed*3.6f <= 2.8f || (newLocation.coordinate.latitude == oldLocation.coordinate.latitude && newLocation.coordinate.longitude == oldLocation.coordinate.longitude))
        {
            self.motionType = MOTIONTYPE_NOTMOVING;
            
        }
        if (newLocSpeed >= 7.0f)
        {
            self.motionType = MOTIONTYPE_AUTOMOTIVE;
            
            if (!hasBeenRun) // hasBeenRun is a boolean intance variable
            {
                [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(notMoving) object:nil];
                hasBeenRun = YES;
            }
        }
//
//        // auto trip start
        if ([self.motionType isEqualToString:MOTIONTYPE_AUTOMOTIVE] && autoStartState == NO && mainDelegate.globalAutoTrip == YES) {
        
            
           NSLog(@"Value of Global Auto Trip at auto trip start in coreLocation is : %d", mainDelegate.globalAutoTrip);
            
            autoStartState = YES;
            mainDelegate.globalAutoTrip = NO;
            
            //Change the start button
//            mainDelegate.autoButtonChange = @"Enabled";
            
            // Post a notification for autostart
            [[NSNotificationCenter defaultCenter] postNotificationName:@"autoStart" object:nil];
            
            //start the trip
            autoStopController = [[GeoLocusViewController alloc] init];
            [autoStopController enabledStateChanged];
            
            //voice alert for auto trip
            
            if ([voicsStatus isEqualToString:@"Enabled"]) {
                
                NSError *setCategoryError = nil;
                NSError *activationError = nil;
                BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback
                                             withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
                
                [audioSession setActive:YES error:&activationError];
                
                if(audioSession.isOtherAudioPlaying){
                    wasPlaying = YES;
//                    NSLog(@"Other audio is playing");
                    [iPodMusicPlayer pause];
                }
                
                NSLog(@"Success %hhd", success);
                
                if (self.synthesizer.isSpeaking)
                {
                    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
                    AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@""];
                    [self.synthesizer speakUtterance:utterance];
                    [self.synthesizer stopSpeakingAtBoundary:AVSpeechBoundaryImmediate];
                }
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance
                                                speechUtteranceWithString:@"Motion detected.Trip auto started"];
                
                utterance.rate = 0.3;
                utterance.volume = 1.0;
                [self.synthesizer speakUtterance:utterance];
                
            }
        }
        
        
        // auto trip stop
        if ([self.motionType isEqualToString:MOTIONTYPE_NOTMOVING])
        {
            if (hasBeenRun) // hasBeenRun is a boolean instance variable
            {
                hasBeenRun = NO;
                [self performSelector:@selector(notMoving) withObject:nil afterDelay:600.0];
            }
            
        }
        //********************End auto trip detection
        
        
        // calculate time interval based on location change
        
        NSTimeInterval timeElapsed;
        if(oldLocation != nil)
        {
            timeElapsed = [newLocation.timestamp timeIntervalSinceDate:oldLocation.timestamp];
            
        }
        else{
            timeElapsed = 1.0;
        }

        
        //Speed difference
        float speedDifference = 0.0;
        if (oldLocation!=nil) {
            
            //Speed difference
            float oldSpeed = oldLocation.speed;
            float newSpeed = newLocation.speed;
            
            speedDifference = (newSpeed-oldSpeed)*3.6f;
        }

        
        // Calculate Braking
        
        float brakingValue = 0.0;
        NSString *braking = nil;
        braking = [NSString stringWithFormat:@"%.1f",0.0];
        
        [speedArray addObject:[NSString stringWithFormat:@"%.2f",newLocation.speed*3.6f]];
        
        
        if ([speedArray count]==10) {
            [speedArray removeAllObjects];
            speedArray = [[NSMutableArray alloc]init];
        }
        
        brakingValue = fabsf(speedDifference);
        
        
        float avgSum = 0.0;
        if (speedDifference < 0)
        {
            float sumForBraking=0;
            for(int x=0; x < [speedArray count]; x++)
            {
                sumForBraking += [[speedArray objectAtIndex:x] floatValue];
            }
            
            avgSum = sumForBraking/[speedArray count];
            
            if (brakingValue > 7.0) {

                if (avgSum > 30.0 && brakAlert == YES) {
                    
                    braking = [NSString stringWithFormat:@"%f",brakingValue];

                    //create new utterance
                    if ([voicsStatus isEqualToString:@"Enabled"]) {
                        
                        NSError *setCategoryError = nil;
                        NSError *activationError = nil;
                        BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback
                                                     withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
                        
                        [audioSession setActive:YES error:&activationError];
                        
                        if(audioSession.isOtherAudioPlaying){
                            wasPlaying = YES;
//                            NSLog(@"Other audio is playing");
                            [iPodMusicPlayer pause];
                        }
                        
                        NSLog(@"Success %hhd", success);
                        
                        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Braking alert"];
                        
                        if (!self.synthesizer.isSpeaking)
                        {
                            utterance.rate = 0.3;
                            utterance.volume = 1.0;
                            [self.synthesizer speakUtterance:utterance];
                        }
                    }
                    brakAlert = NO;
                }
            }
        }else
        {
            brakAlert = YES;
        }
        
        
        // Calculate Acceleration
        
        float acceleration = 0.0;
        NSString *accele = nil;
        accele = [NSString stringWithFormat:@"%.1f",0.0];
        
        
        if (speedDifference > 0) {
            
            acceleration = speedDifference/timeElapsed;
            NSLog(@"Value of Acceleration is :%f",acceleration);
            
            float avgSpeed = 0.0;
            float sum=0;
            for(int x=0; x < [speedArray count]; x++)
            {
                sum += [[speedArray objectAtIndex:x] floatValue];
            }
            
            avgSpeed = sum/[speedArray count];
            NSLog(@"Value of Average Speed is :%f",avgSpeed);
            
            if (acceleration > 5.0) {
                if (avgSpeed > 35.0 && acclAlert == YES){
                    
                    accele = [NSString stringWithFormat:@"%f",acceleration];

                    //create new utterance
                    if ([voicsStatus isEqualToString:@"Enabled"]) {
                        
                        NSError *setCategoryError = nil;
                        NSError *activationError = nil;
                        BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback
                                                     withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
                        
                        [audioSession setActive:YES error:&activationError];
                        
                        if(audioSession.isOtherAudioPlaying){
                            wasPlaying = YES;
//                            NSLog(@"Other audio is playing");
                            [iPodMusicPlayer pause];
                        }
                        NSLog(@"Success %hhd", success);
                        
                        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Acceleration alert"];
                        
                        if (!self.synthesizer.isSpeaking)
                        {
                            utterance.rate = 0.3;
                            utterance.volume = 1.0;
                            [self.synthesizer speakUtterance:utterance];
                        }
                    }
                    
                    acclAlert = NO;
                }
            }
        }else
        {
            acclAlert = YES;
        }
        
//        NSString *speedValue = [NSString stringWithFormat:@"%.1f", newLocation.speed*3600/1000]; // in km
        
        NSString *speedValue = nil;
        speedValue = [NSString stringWithFormat:@"%.1f",0.0];
        
//        NSLog(@"Dan printing speedValue Before Overspeeding : %@", speedValue);
        
        // voice alert for overspeed
        if ((newLocation.speed*3.6f >= mainDelegate.speedLimit) && speedVAlert ) {
            
//            NSLog(@"Speed Limit is= %f", mainDelegate.speedLimit);
            
            speedValue = [NSString stringWithFormat:@"%.1f", newLocation.speed*3.6f];
            
//            NSLog(@"Dan printing newLocation speed : %f", newLocation.speed*3.6f);
//            NSLog(@"Dan printing speedValue After Overspeeding : %@", speedValue);
            
            //create new utterance
            if ([voicsStatus isEqualToString:@"Enabled"]) {
                
                NSError *setCategoryError = nil;
                NSError *activationError = nil;
                BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback
                                             withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
                
                [audioSession setActive:YES error:&activationError];
                
                if(audioSession.isOtherAudioPlaying){
                    wasPlaying = YES;
//                    NSLog(@"Other audio is playing");
                    [iPodMusicPlayer pause];
                }
                
                NSLog(@"Success %hhd", success);
                
                AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Overspeed alert"];
                
                if (!self.synthesizer.isSpeaking)
                {
                    utterance.rate = 0.3;
                    utterance.volume = 1.0;
                    [self.synthesizer speakUtterance:utterance];
                }
            }
            speedVAlert = NO;
            
        }else if (newLocation.speed*3.6f <= mainDelegate.speedLimit)
        {
            NSLog(@"ELSESpeed Limit is= %f", mainDelegate.speedLimit);
            speedVAlert = YES;
        }
        
        
        //Calculate distance
        if(newLocation && oldLocation)
        {
            fltDistanceTravelled +=[self getDistanceInKm:newLocation fromLocation:oldLocation];
            distance = [NSString stringWithFormat:@"%f",fltDistanceTravelled];
//            NSLog(@"%@",distance);
            
            [[NSUserDefaults standardUserDefaults] setFloat:fltDistanceTravelled forKey:@"distanceTravelled"];
        }else
        {
            distance = @"0.0";
        }
        
        //Direction
        NSString *direction = [[NSUserDefaults standardUserDefaults] valueForKey:@"heading"];
        NSString *heading = [[direction componentsSeparatedByCharactersInSet: [[NSCharacterSet letterCharacterSet] invertedSet]] componentsJoinedByString:@""];
//        NSLog(@"direction:%@",heading);
        
        //Battery level
        UIDevice *myDevice = [UIDevice currentDevice];
        [myDevice setBatteryMonitoringEnabled:YES];
        float batLeft = [myDevice batteryLevel];
        int i=[myDevice batteryState];
        
        NSLog(@"%d",i);
        float batinfo=(batLeft*100);
        
        NSString *batteryLbl = [NSString stringWithFormat:@"%f",batinfo];
        
        
        // Data creation time
        creationTime = 1000.0 * [[NSDate date] timeIntervalSince1970];
        
        NSString *dataCreatTime = [NSString stringWithFormat:@"%f",creationTime];
        
        NSArray* getUptoDecimal = [dataCreatTime componentsSeparatedByString: @"."];
        dataCreatTime = [getUptoDecimal objectAtIndex: 0];
        
        // update db
//        dataCollectDb = [FMDatabase databaseWithPath:databasePath];
//        [dataCollectDb open];
    
        latitude = [NSString stringWithFormat:@"%.14f",lat];
        longitude = [NSString stringWithFormat:@"%.14f",lon];
        
        
//        if ([longitude length]!=0 && [latitude length]!=0) {
//            [dataCollectDb executeUpdate:@"INSERT INTO collectData (dataSource,msgType,provider,creationTime,dataReceivedTimestamp,gpsAge,totalDistCovered,rawdata,lbl,ck,longitude,latitude,deviceNumber,accuracy,speed,altitude,acceleration,braking,heading,deviceType) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?);",@"Mobile",@"timeseries",@"gps",dataCreatTime,@"0",@"0",distance,@"0",batteryLbl,@"0",longitude,latitude,mainDelegate.deviceId,accuracy,speedValue,altitude,accele,braking,heading,@"Mobile", nil];
//          
//        }
    
//        [dataCollectDb close];
    
    
    
    NSString *str = [NSString stringWithFormat:@"Latitude: %@   Logitude: %@   Speed: %.2f   Timestamp: %@   Acceleration: %.2f   Braking: %.2f \r\n",latitude,longitude,newLocation.speed*3.6f,newLocation.timestamp,acceleration,brakingValue];
        //write data to file for ref
    NSLog(@"str :%@",str);
        [self writeToTextFile:str];

    }
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
     NSLog(@"%d",status);
}


- (void)startMonitoringForRegion:(CLRegion *)region desiredAccuracy:(CLLocationAccuracy)accuracy
{
    
}

//this is a wrapper method to fit the required selector signature
- (void)timeIntervalEnded:(NSTimer*)timer {
    fltDistanceTravelled=0;
    [self startReadingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading
{
    double updatedHeading = newHeading.magneticHeading;
    
    float value = updatedHeading;
    
    headingDirection = nil;
    if(value >= 0 && value < 23)
    {
        headingDirection = [NSString stringWithFormat:@"%f° N",value];
    }
    else if(value >=23 && value < 68)
    {
        headingDirection = [NSString stringWithFormat:@"%f° NE",value];
    }
    else if(value >=68 && value < 113)
    {
        headingDirection = [NSString stringWithFormat:@"%f° E",value];
    }
    else if(value >=113 && value < 185)
    {
        headingDirection = [NSString stringWithFormat:@"%f° SE",value];
    }
    else if(value >=185 && value < 203)
    {
        headingDirection = [NSString stringWithFormat:@"%f° S",value];
    }
    else if(value >=203 && value < 249)
    {
        headingDirection = [NSString stringWithFormat:@"%f° SE",value];
    }
    else if(value >=249 && value < 293)
    {
        headingDirection = [NSString stringWithFormat:@"%f° W",value];
    }
    else if(value >=293 && value < 350)
    {
        headingDirection = [NSString stringWithFormat:@"%f° NW",value];
    }
    
    @try {
        // Try something
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setValue:headingDirection forKey:@"heading"];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @finally {
        // Added to show finally works as well
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
	if([self.delegate conformsToProtocol:@protocol(CoreLocationControllerDelegate)]) {
		[self.delegate locationError:error];
	}
}

- (void)startReadingLocation {
    [locMgr startUpdatingLocation];
    [self.locMgr startUpdatingHeading];
}


-(float)getDistanceInKm:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    float lat1,lon1,lat2,lon2;
    
    lat1 = newLocation.coordinate.latitude  * M_PI / 180;
    lon1 = newLocation.coordinate.longitude * M_PI / 180;
    
    lat2 = oldLocation.coordinate.latitude  * M_PI / 180;
    lon2 = oldLocation.coordinate.longitude * M_PI / 180;
    
    float R = 6371; // km
    float dLat = lat2-lat1;
    float dLon = lon2-lon1;
    
    float a = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    float c = 2 * atan2(sqrt(a), sqrt(1-a));
    float d = R * c;
    
    NSLog(@"Kms-->%f",d);
    
    return d;
}

-(float)getDistanceInMiles:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    float lat1,lon1,lat2,lon2;
    
    lat1 = newLocation.coordinate.latitude  * M_PI / 180;
    lon1 = newLocation.coordinate.longitude * M_PI / 180;
    
    lat2 = oldLocation.coordinate.latitude  * M_PI / 180;
    lon2 = oldLocation.coordinate.longitude * M_PI / 180;
    
    float R = 3963; // km
    float dLat = lat2-lat1;
    float dLon = lon2-lon1;
    
    float a = sin(dLat/2) * sin(dLat/2) + cos(lat1) * cos(lat2) * sin(dLon/2) * sin(dLon/2);
    float c = 2 * atan2(sqrt(a), sqrt(1-a));
    float d = R * c;
    
    NSLog(@"Miles-->%f",d);
    
    return d;
}

#pragma mark dbupdate notification
- (void)bBNotification:(NSNotification *) notification
{
    NSLog(@"DB notification, please update database!");
    
    [self getDataFromDb];
    
}


-(void)notMoving
{    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSLog(@"Value of Global Auto Trip at notMoving is : %d", mainDelegate.globalAutoTrip);
    
    if (autoStartState == YES && mainDelegate.globalAutoTrip == NO) {
    
        NSLog(@"Value of GB is : %d" ,mainDelegate.globalAutoTrip);
    
        GeolocusDashboard *dashBoard = [[GeolocusDashboard alloc] init];
        [dashBoard stopBGServices:0];
        
        autoStartState = NO;
        mainDelegate.globalAutoTrip = NO;
        
        //Change the start button
//        mainDelegate.autoButtonChange = @"Disabled";
    }
}


//Method writes a string to a text file
-(void) writeToTextFile:(NSString *)textToWrite{
    
    NSString *str = textToWrite; //get text from textField
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/locDetail.txt",
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

- (void)dealloc {
    //[super dealloc];
}

@end
