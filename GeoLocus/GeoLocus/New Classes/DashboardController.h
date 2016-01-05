//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "DashboardEntity.h"

@interface DashboardController : NSObject


- (BOOL)connected;

- (NSInteger) distanceConversion:(NSInteger *)distanceInMeters :(NSString *)country;
- (DashboardEntity *) displayDashboard:(NSString *)insuredID :(NSString *)resultToken :(NSString *)counterName :(NSString *)accountId :(NSString *)accountCode;

- (NSString*) getCurrentDate;

@end
