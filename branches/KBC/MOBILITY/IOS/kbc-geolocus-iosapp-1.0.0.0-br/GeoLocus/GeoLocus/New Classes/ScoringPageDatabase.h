//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "ScoringEntity.h"

@interface ScoringPageDatabase : NSObject


-(void) createDatabase;

-(void) fetchDatabase: (NSInteger *) val3;

-(void) insertDatabase: (ScoringEntity *) scoringEntity;

-(ScoringEntity*) fetchByDataDatabase: (NSString *) date;

-(ScoringEntity*) fetchLastWeeklyData;


@end
