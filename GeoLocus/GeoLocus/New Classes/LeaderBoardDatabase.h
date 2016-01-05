//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

#import "LeaderBoardEntity.h"

@interface LeaderBoardDatabase : NSObject



/*
 -(void) createDatabase;
 
 -(void) fetchDatabase: (NSInteger *) val3;
 
 -(void) insertDatabase: (LeaderBoardEntity *) leaderBoardEntity;
 
 -(LeaderBoardEntity*) fetchByDataDatabase: (NSString *) date;
 
 -(LeaderBoardEntity*) fetchLastData;
 */



-(void) createLeaderBoardDatabase;

- (void) insertLeaderBoardDatabase:(LeaderBoardEntity *) leaderBoardEntity;

- (void) fetchLeaderBoardDatabase:(NSInteger *) val3;

-(NSArray*) fetchLeaderBoardLastData:(NSString *) cursorDate;

-(void) createLeaderBoardHistoryDatabase;

- (void) insertLeaderBoardHistoryDatabase:(LeaderBoardEntity *) leaderBoardEntity;

- (void) fetchLeaderBoardHistoryDatabase:(NSInteger *) val3;

-(NSMutableArray*) fetchLeaderBoardHistoryLastData:(NSString *) cursorDate :(NSString *) counterName;

@end
