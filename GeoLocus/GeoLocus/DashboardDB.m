//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "DashboardDB.h"
#import <sqlite3.h>
#import "GeoLocus-Swift.h"
#import <CoreData/CoreData.h>
#import "DASHBOARD_PARAMETER.h"
#import "DashboardEntity.h"

@implementation DashboardDB

static DashboardDB *sharedInstance = nil;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[DashboardDB alloc] init];
    });
    return sharedInstance;
}

- (void) insertDatabase:(DashboardEntity *) dashboardEntity
{
 
    NSLog(@"Entering Dashboard Data Insert");
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [mainDelegate managedObjectContext];
    
    DASHBOARD_PARAMETER *dashboardDetails = [NSEntityDescription insertNewObjectForEntityForName:@"DASHBOARD_PARAMETER" inManagedObjectContext:context];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];

    dashboardDetails.iD = @"1";
    dashboardDetails.dATE = dashboardEntity.currentDate;
    dashboardDetails.uSEDMILES = [NSNumber numberWithDouble:dashboardEntity.usedMiles];
    dashboardDetails.rEWARDSAVAILABLE = [NSNumber numberWithInteger:dashboardEntity.rewardsAvailable];
    dashboardDetails.sCORE = [NSNumber numberWithInteger:dashboardEntity.driverScores];
    dashboardDetails.aCCELERATION = [NSNumber numberWithInteger:dashboardEntity.acceleration];
    dashboardDetails.bRAKING = [NSNumber numberWithInteger:dashboardEntity.braking];
    dashboardDetails.sPEEDING = [NSNumber numberWithInteger:dashboardEntity.speeding];
    dashboardDetails.cORNERING = [NSNumber numberWithInteger:dashboardEntity.cornering];
    dashboardDetails.tIMEOFDAY = [NSNumber numberWithInteger:dashboardEntity.timeOfDay];
    dashboardDetails.tIMESTAMP = dashboardEntity.timeStamp;
    
    NSLog(@"rewardsAvailable inserted : %@",dashboardDetails.rEWARDSAVAILABLE);
    
    NSError *error;
    
    if (![context save:&error]) {
        
        NSLog(@"Not Inserted in the Table DASHBOARD_PARAMETER : %@", [error localizedDescription]);
    }
    
}

-(DashboardEntity*) fetchByDataDatabase: (NSString *) date {
    
    DashboardEntity *dashboardEntity = [[DashboardEntity alloc] init];
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [mainDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DASHBOARD_PARAMETER" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self == %@", date];
    
    [fetchRequest setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
    
    NSLog(@"results : %lu", (unsigned long)results.count);
    
    if (results.count > 1) {
        
        dashboardEntity.usedMiles = [[context valueForKey:@"uSEDMILES"] intValue];
        dashboardEntity.rewardsAvailable = [[context valueForKey:@"rEWARDSAVAILABLE"] intValue];
        dashboardEntity.driverScores = [[context valueForKey:@"sCORE"] intValue];
        dashboardEntity.acceleration = [[context valueForKey:@"aCCELERATION"] intValue];
        dashboardEntity.braking = [[context valueForKey:@"bRAKING"] intValue];
        dashboardEntity.speeding = [[context valueForKey:@"sPEEDING"] intValue];
        dashboardEntity.cornering = [[context valueForKey:@"cORNERING"] intValue];
        dashboardEntity.timeOfDay = [[context valueForKey:@"tIMEOFDAY"] intValue];
        
        
        
    }
    else {
        NSLog(@"No Value retrieved for this date from the core data Dashboard DB.");
        NSLog(@"%@, %@", error, error.localizedDescription);
    }
    
    NSLog(@"Dashboard Entitiy Core Data fetchByDataDatabase : %d", dashboardEntity.rewardsAvailable);
    return dashboardEntity;
}

-(DashboardEntity*) fetchLastData {

    DashboardEntity *dashboardEntity = [[DashboardEntity alloc] init];
    
    AppDelegateSwift *mainDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [mainDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DASHBOARD_PARAMETER" inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    
    NSArray *result = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        
        NSLog(@"Unable to execute fetch request.");
        NSLog(@"%@, %@", error, error.localizedDescription);
        
    } else {
        
        for (context in result) {
            
            NSNumber* miles = [context valueForKey:@"uSEDMILES"];
            NSNumber* rewards = [context valueForKey:@"rEWARDSAVAILABLE"];
            NSNumber* scores = [context valueForKey:@"sCORE"];
            NSNumber* accelerate = [context valueForKey:@"aCCELERATION"];
            NSNumber* brake = [context valueForKey:@"bRAKING"];
            NSNumber* speed = [context valueForKey:@"sPEEDING"];
            NSNumber* corner = [context valueForKey:@"cORNERING"];
            NSNumber* time = [context valueForKey:@"tIMEOFDAY"];

            
            int usedMiles = [miles intValue];
            int rewardsAvailable = [rewards intValue];
            int score = [scores intValue];
            int acceleration = [accelerate intValue];
            int braking = [brake intValue];
            int speeding = [speed intValue];
            int cornering = [corner intValue];
            int timeOfDay = [time intValue];
            
            dashboardEntity.usedMiles = usedMiles;
            dashboardEntity.rewardsAvailable = rewardsAvailable;
            dashboardEntity.driverScores = score;
            dashboardEntity.acceleration = acceleration;
            dashboardEntity.braking = braking;
            dashboardEntity.speeding = speeding;
            dashboardEntity.cornering = cornering;
            dashboardEntity.timeOfDay = timeOfDay;
            
        }
    }
    
    NSLog(@"Dashboard Entitiy Core Data fetchLastData : %d", dashboardEntity.usedMiles);
    
    return dashboardEntity;
    
}


@end
