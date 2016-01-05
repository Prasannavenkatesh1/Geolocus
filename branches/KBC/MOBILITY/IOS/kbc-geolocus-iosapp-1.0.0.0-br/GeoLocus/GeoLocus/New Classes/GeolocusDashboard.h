//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "CoreLocationController.h"
#import <AVFoundation/AVFoundation.h>

#import <dispatch/dispatch.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface GeolocusDashboard : UIViewController <CoreLocationControllerDelegate,AVSpeechSynthesizerDelegate>
{
    CoreLocationController *CLController;
    
    dispatch_queue_t backgroundQueue;
}
@property (nonatomic, strong) CoreLocationController *CLController;
@property (strong, nonatomic) AVSpeechSynthesizer *synthesizer;
@property (nonatomic,strong) UIWebView* webView;

-(void) callDashboard: (NSString *)deviceId : (NSString *) countryCode;

-(NSDictionary*) weeklyScoringDetails:(NSString *)accountId :(NSString *)accountCode :(NSString *)resultInsuredID :(NSString *)resultToken;

-(NSDictionary *) leaderBoardDetails;

-(void) startBGServices:(NSString *)command;

-(void)stopBGServices:(NSString *)command;

-(NSDictionary*) getSettingsData;

-(NSDictionary *) tripSummaryDetails;

-(void) setSettingsData;

-(BOOL) checkUserDetails;

@end
