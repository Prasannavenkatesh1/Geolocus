//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

@interface LeaderBoardEntity : NSObject


@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *rankingId;
@property (nonatomic, strong) NSString *insuredId;
@property (nonatomic, strong) NSString *previousRank;
@property (nonatomic, strong) NSString *currentRank;
@property (nonatomic, strong) NSString *driverScore;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *processdate;
@property (nonatomic, strong) NSString *distanceDriven;
@property (nonatomic, strong) NSString *currentDate;



@property (nonatomic, strong) NSMutableArray *rank;
@property (nonatomic, strong) NSMutableArray *insured;
@property (nonatomic, strong) NSMutableArray *previousrank;
@property (nonatomic, strong) NSMutableArray *currentrank;
@property (nonatomic, strong) NSMutableArray *driverscore;
@property (nonatomic, strong) NSMutableArray *locations;
@property (nonatomic, strong) NSMutableArray *rankone;
@property (nonatomic, strong) NSMutableArray *rank2;
@property (nonatomic, strong) NSMutableArray *rank3;
@property (nonatomic, strong) NSMutableArray *insuredrank;




@end
