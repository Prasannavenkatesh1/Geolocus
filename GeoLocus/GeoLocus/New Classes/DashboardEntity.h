//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

@interface DashboardEntity : NSObject


@property (nonatomic) NSInteger id;
@property (nonatomic) NSInteger usedMiles;
@property (nonatomic) NSInteger rewardsAvailable;
@property (nonatomic) NSInteger driverScores;
@property (nonatomic) NSInteger acceleration;
@property (nonatomic) NSInteger braking;
@property (nonatomic) NSInteger cornering;
@property (nonatomic) NSInteger speeding;
@property (nonatomic) NSInteger timeOfDay;


@property (nonatomic, strong) NSString *currentDate;

@property (nonatomic, strong) NSString *timeStamp;

@end
