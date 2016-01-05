//Created by Insurance H3 Team
//
//GeoLocus App
//
#import "TripSummaryDB.h"
//#import <sqlite3.h>
#import "TripSummaryEntity.h"
#import "GeoLocus-Swift.h"
#import <CoreData/CoreData.h>
#import "TRIP_SUMMARY_COLLECTDATA.h"

@implementation TripSummaryDB

   static TripSummaryDB *sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[TripSummaryDB alloc] init];
    });
    return sharedInstance;
}

- (void) insertTripSummaryDb:(TripSummaryEntity *) tripSummaryEntity
{

    NSLog(@"Entering Core Data Insert");
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [mainDelegate managedObjectContext];
   
    TRIP_SUMMARY_COLLECTDATA *tripSummary = [NSEntityDescription insertNewObjectForEntityForName:@"TRIP_SUMMARY_COLLECTDATA" inManagedObjectContext:context];
    
    tripSummary.iD = @"1";
    tripSummary.dEVICE_NUMBER = tripSummaryEntity.deviceNumber;
    tripSummary.aCCELERATION = tripSummaryEntity.acceleration;
    tripSummary.bRAKING = tripSummaryEntity.braking;
    tripSummary.oVERSPEED = tripSummaryEntity.overspeed;
    tripSummary.iNCOMING_CALL = tripSummaryEntity.incomingCall;
    tripSummary.oUTGOING_CALL = tripSummaryEntity.outgoingCall;
    tripSummary.tOTAL_DISTANCE_COVERED = tripSummaryEntity.totalDistCovered;
    tripSummary.tOTAL_DURATION = tripSummaryEntity.totalDuration;
    tripSummary.cURRENT_DATE = tripSummaryEntity.currentDate;
    
    NSError *error;
    
    if (![context save:&error]) {
        
        NSLog(@"Not Inserted in the Table TRIP_SUMMARY_COLLECTDATA : %@", [error localizedDescription]);
    }
}

- (void) updateTripSummaryDB:(TripSummaryEntity *) tripSummaryEntity
{
 
    NSLog(@"Entering Core Data Update");

    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSFetchRequest *fetchRequest=[NSFetchRequest fetchRequestWithEntityName:@"TRIP_SUMMARY_COLLECTDATA"];
    
    NSArray *arrupdateTrip=[mainDelegate.managedObjectContext executeFetchRequest:fetchRequest error:nil];
    
    NSLog(@"Count of the array is : %d", arrupdateTrip.count);
    
    if (arrupdateTrip.count > 0)
    {
        TRIP_SUMMARY_COLLECTDATA *updateTrip = [arrupdateTrip lastObject];
    
        updateTrip.iD = @"1";
        updateTrip.dEVICE_NUMBER = tripSummaryEntity.deviceNumber;
        updateTrip.aCCELERATION = tripSummaryEntity.acceleration;
        updateTrip.bRAKING = tripSummaryEntity.braking;
        updateTrip.oVERSPEED = tripSummaryEntity.overspeed;
        updateTrip.iNCOMING_CALL = tripSummaryEntity.incomingCall;
        updateTrip.oUTGOING_CALL = tripSummaryEntity.outgoingCall;
        updateTrip.tOTAL_DISTANCE_COVERED = tripSummaryEntity.totalDistCovered;
        updateTrip.tOTAL_DURATION = tripSummaryEntity.totalDuration;
        updateTrip.cURRENT_DATE = tripSummaryEntity.currentDate;
        
        NSError *error;
        
        if (![mainDelegate.managedObjectContext save:&error]) {
           
            NSLog(@"Error in trip update for the table TRIP_SUMMARY_COLLECTDATA : %@", [error localizedDescription]);
        }
    }
    else {
        
        [self insertTripSummaryDb:tripSummaryEntity];
    }

}

-(TripSummaryEntity*) fetchLatestTripData:(NSString *)deviceNumber counterName:(NSString *)counterName {
 
    TripSummaryEntity *tripSummaryEntity = [[TripSummaryEntity alloc] init];
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [mainDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"TRIP_SUMMARY_COLLECTDATA" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        
        for (context in result) {
        
            tripSummaryEntity.deviceNumber = [context valueForKey:@"dEVICE_NUMBER"];
            tripSummaryEntity.acceleration = [context valueForKey:@"aCCELERATION"];
            tripSummaryEntity.braking = [context valueForKey:@"bRAKING"];
            tripSummaryEntity.overspeed = [context valueForKey:@"oVERSPEED"];
            tripSummaryEntity.incomingCall = [context valueForKey:@"iNCOMING_CALL"];
            tripSummaryEntity.outgoingCall = [context valueForKey:@"oUTGOING_CALL"];
            tripSummaryEntity.totalDistCovered = [context valueForKey:@"tOTAL_DISTANCE_COVERED"];
            tripSummaryEntity.totalDuration = [context valueForKey:@"tOTAL_DURATION"];
            tripSummaryEntity.currentDate = [context valueForKey:@"cURRENT_DATE"];
            
        }
    }
    return tripSummaryEntity;
}


@end
