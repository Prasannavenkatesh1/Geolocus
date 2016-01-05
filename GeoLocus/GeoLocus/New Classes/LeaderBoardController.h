//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

#import "LeaderBoardEntity.h"

@interface LeaderBoardController : NSObject

@property(nonatomic,strong) id lbData;


- (BOOL)connected;

//-(LeaderBoardEntity*) getLeaderBoardData: (NSString *) insuredID;


//-(NSMutableDictionary*) getLeaderBoardData: (NSString *) insuredID;

//-(NSMutableDictionary*) getLeaderBoardData: (NSString *) insuredID: (NSString *) resultToken;
//-(NSMutableDictionary*) getLeaderBoardData:(NSString *) insuredID:(NSString *) resultToken :(NSString *)counterName;


-(NSMutableDictionary*) getLeaderBoardData:(NSString *) insuredID:(NSString *) resultToken :(NSString *)counterName:(NSString *)accountId;

-(BOOL) getCurrentMonth:(LeaderBoardEntity *)leaderBoardDetails;

@end
