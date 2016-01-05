//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DashboardEntity.h"

@interface DashboardDB : NSObject

+ (instancetype)sharedInstance;

- (void) insertDatabase:(DashboardEntity *) dashboardEntity;

-(DashboardEntity*) fetchByDataDatabase: (NSString *) date;

-(DashboardEntity*) fetchLastData;

@end
