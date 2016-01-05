//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "DashboardEntity.h"

@interface DashboardDatabase : NSObject


-(void) createDatabase;

-(void) fetchDatabase: (NSInteger *) val3;

-(void) insertDatabase:(DashboardEntity *)dashboardEntity;

-(DashboardEntity*) fetchByDataDatabase: (NSString *) date;

-(DashboardEntity*) fetchLastData;

@end
