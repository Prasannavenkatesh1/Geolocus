//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "TripSummaryEntity.h"
#import <CoreData/CoreData.h>

@interface TripSummaryDB : NSObject

+ (instancetype)sharedInstance;

- (void) insertTripSummaryDb:(TripSummaryEntity *) tripSummaryEntity;

- (void) updateTripSummaryDB:(TripSummaryEntity *) tripSummaryEntity;

-(TripSummaryEntity*) fetchLatestTripData:(NSString *)deviceNumber counterName:(NSString *)counterName;

@end
