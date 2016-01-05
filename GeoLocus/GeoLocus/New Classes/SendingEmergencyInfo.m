//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "SendingEmergencyInfo.h"
#import <MessageUI/MessageUI.h>
#import "ServiceConstants.h"
#import "AppDelegate.h"

@interface SendingEmergencyInfo () <MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate, AVSpeechSynthesizerDelegate> {
    
    BOOL pageStillLoading;
    NSString *errorMessage;
    NSUInteger errorCode;
}

@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;

@end

@implementation SendingEmergencyInfo

BOOL isPlaying = NO;
BOOL emergencyAlert = NO;

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"SHAKE");
        [self showAlert];
    } 
}

- (void)startDeviceMotion {
    // Create a CMMotionManager
    _motionManager = [[CMMotionManager alloc] init];
    
    // Tell CoreMotion to show the compass calibration HUD when required
    // to provide true north-referenced attitude
    _motionManager.showsDeviceMovementDisplay = YES;
    _motionManager.deviceMotionUpdateInterval = 1.0 / 60.0;
    
    // Attitude that is referenced to true north
    [_motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
}


- (void)stopDeviceMotion {
    [_motionManager stopDeviceMotionUpdates];
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
    if(isPlaying){
        [iPodMusicPlayer play];
        isPlaying = NO;
    }
}

-(IBAction)showAlert
{
    AppDelegate *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    audioSession = [AVAudioSession sharedInstance];
    
    //get voice alert state
    voiceStatus = mainDelegate.vAlert;
    
    //create new utterance
    if ([voiceStatus isEqualToString:@"Enabled"]) {
        
        NSError *setCategoryError = nil;
        NSError *activationError = nil;
        BOOL success = [audioSession setCategory:AVAudioSessionCategoryPlayback
                                     withOptions:AVAudioSessionCategoryOptionMixWithOthers error:&setCategoryError];
        
        [audioSession setActive:YES error:&activationError];
        
        if(audioSession.isOtherAudioPlaying){
            isPlaying = YES;
            [iPodMusicPlayer pause];
        }
        
        NSLog(@"Success %hhd", success);
        
        AVSpeechUtterance *utterance = [AVSpeechUtterance speechUtteranceWithString:@"Emergency Alert"];
        
        if (!self.synthesizer.isSpeaking)
        {
            utterance.rate = 0.3;
            utterance.volume = 1.0;
            [self.synthesizer speakUtterance:utterance];
        }
    }
    emergencyAlert = YES;
    
}

//- (void)showEmail:(NSString*)file {

- (void)showEmail {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    NSArray *recipents = @[@"8754510623", @"9710337872"];
    NSString *message = [NSString stringWithFormat:@"Testing sms. Please check! :)"];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    messageController.messageComposeDelegate = self;

    // Present message view controller on screen
//    [self presentViewController:messageController animated:YES completion:nil];
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] presentViewController:messageController animated:YES completion:nil];

    
    
    /* // Email Subject
     NSString *emailTitle = @"Test Email";
     // Email Content
     NSString *messageBody = @"iOS programming!";
     // To address
     NSArray *toRecipents = [NSArray arrayWithObject:@"danielraj31@gmail.com"];
     
     MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
     mc.mailComposeDelegate = self;
     [mc setSubject:emailTitle];
     [mc setMessageBody:messageBody isHTML:NO];
     [mc setToRecipients:toRecipents];  */
    
    // Present mail view controller on screen
    ////[self presentViewController:mc animated:YES completion:NULL];
    
    
}

-(void)sendEmergency :(NSString *)insuredID : (NSString *)resultToken
{

    if (emergencyAlert) {
    // get data from db

    defaultDBPath = [[NSBundle mainBundle] pathForResource:@"collectData" ofType: @"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;

    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];

    dbPath = [documentsDir stringByAppendingPathComponent:@"collectData.sqlite"];

    if([fileManager fileExistsAtPath:dbPath]==NO){
    
        defaultDBPath = [[NSBundle mainBundle] pathForResource:@"collectData" ofType: @"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
    
        if(!success){
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }

    db = [FMDatabase databaseWithPath:dbPath];
    
    [db open];
    
    FMResultSet *rs = [db executeQuery:@"SELECT * From collectData"];
    
    while ([rs next]) {
        latitude = [rs stringForColumn:@"latitude"];
        longitude = [rs stringForColumn:@"longitude"];
        
    }
    
    [db close];
    
    //latitude = @"37.37732484000000";
    //longitude = @"-122.14894979000000";
    
    
    NSLog(@"Retreived Running Data :%@\n%@\n%@\n%@",latitude,longitude,insuredID,resultToken);
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"latitude\":%@,\"longitude\":%@,\"insuredId\":%@}",latitude, longitude, insuredID];
    
    NSLog(@"Emergency service URL: %@", jsonRequest);

    
    NSURL *url = [NSURL URLWithString:EMERGENCYURL];
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
    NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"The url is : %@" ,request);
    
    [request setHTTPMethod:@"POST"];
    [request setValue:resultToken forHTTPHeaderField:@"SPRING_SECURITY_REMEMBER_ME_COOKIE"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"TEXT/XML" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    
    NSLog(@"The url is : %@" ,requestData);
    
    [request setHTTPBody: requestData];
 
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    /*pageStillLoading = NO;
    
    while (!pageStillLoading) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
    }*/
        
    }
    
}




- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
//    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[[[[UIApplication sharedApplication] delegate] window] rootViewController] dismissViewControllerAnimated:YES completion:nil];

}



/*
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

*/

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"Authentication challenge");
    
    if ([challenge previousFailureCount] == 0)
    {
        
        NSString *username = @"Geolocusincidents";
        NSString *password = @"G111111#";
        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:username
                                                                 password:password
                                                              persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        
    } else {
        NSLog(@"Credentials are wrong!");
        
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"inside didReceiveResponse");
    
    NSLog(@"inside didReceiveResponse response= %@",response);
    
    /* NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionaryResponse = [httpResponse allHeaderFields];
        
        
        NSLog(@"dictionary[SPRING_SECURITY_REMEMBER_ME_COOKIE] = %@", dictionaryResponse[@"SPRING_SECURITY_REMEMBER_ME_COOKIE"]);
    } */

    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"inside didFailWithError = %@",error);		
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished Loading");
    
    pageStillLoading = NO;
    
}

@end
