//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "TripSummaryEntity.h"

@interface TripSummaryDatabase : NSObject

-(void) createTripSummaryDb;

-(void) deleteTripSummaryDb;

//-(TripSummaryEntity*) fetchLatestTripData;

//-(TripSummaryEntity*) fetchLatestTripData:(NSString *)deviceNumber:(NSString *)counterName;
-(TripSummaryEntity*) fetchLatestTripData:(NSString *)deviceNumber counterName:(NSString *)counterName;

-(NSString*) getTimeFormatted:(NSString *)totalDuration;

-(NSString*) getDistanceWithUnits:(NSString *)totalDistCovered:(NSString *)counterName;

- (void) insertTripSummaryDb:(TripSummaryEntity *) tripSummaryEntity;

@end
