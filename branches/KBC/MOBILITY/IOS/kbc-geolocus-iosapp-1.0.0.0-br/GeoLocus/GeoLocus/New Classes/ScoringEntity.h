//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

@interface ScoringEntity : NSObject


@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *acceleration;
@property (nonatomic, strong) NSString *braking;
@property (nonatomic, strong) NSString *cornering;
@property (nonatomic, strong) NSString *speeding;
@property (nonatomic, strong) NSString *timeOfDay;
@property (nonatomic, strong) NSString *currentDate;



@property (nonatomic, strong) NSMutableArray *weeklyAcceleration;
@property (nonatomic, strong) NSMutableArray *weeklyBraking;
@property (nonatomic, strong) NSMutableArray *weeklySpeeding;
@property (nonatomic, strong) NSMutableArray *weeklyCornering;
@property (nonatomic, strong) NSMutableArray *weeklyTimeOfDay;





@end
