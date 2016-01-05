//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "DashboardDatabase.h"
#import <sqlite3.h>
#import "DashboardEntity.h"

@implementation DashboardDatabase


-(void) createDatabase {
    
    NSLog(@"Welcome to DashboardDatabase");
    
    sqlite3_stmt *statement = NULL;
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    NSLog(@"Database path = '%@'",databasePath);
    
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    // const char *dbpath = [databasePath UTF8String];
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS DASHBOARD_PARAMETER(ID INTEGER PRIMARY KEY AUTOINCREMENT, DATE TEXT, USEDMILES INTEGER, REWAREDSAVAILABLE INTEGER, SCORE INTEGER, ACCELERATION INTEGER, BRAKING INTEGER, CORNERING INTEGER, SPEEDING INTEGER, TIMEOFDAY INTEGER, TIMESTAMP TEXT )";
            
            
            if (sqlite3_exec(Geolocus, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(Geolocus);
            
        } else {
            NSLog(@"Failed to open/create database");
            
        }
        
        NSLog(@"DATABASE has been created");
    }
    
    NSLog(@"end if");
    
    //[filemgr release];
    
    
    
}




//save our data
- (void) insertDatabase:(DashboardEntity *) dashboardEntity
{
    
    [self createDatabase];
    
    sqlite3_stmt *statement = NULL;
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        NSLog(@"New data, Insert Please");
        
        
        NSLog(@"dashboardEntity.driverScores='%d'",dashboardEntity.driverScores);
        
        
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *currentDate = [[NSString alloc] init];
        currentDate = [DateFormatter stringFromDate:[NSDate date]];
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO DASHBOARD_PARAMETER (DATE, USEDMILES, REWAREDSAVAILABLE, SCORE, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY, TIMESTAMP) VALUES (\"%@\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%d\", \"%@\")", currentDate, (int)dashboardEntity.usedMiles, (int)dashboardEntity.rewardsAvailable, (int)dashboardEntity.driverScores, (int)dashboardEntity.acceleration, (int)dashboardEntity.braking, (int)dashboardEntity.cornering, (int)dashboardEntity.speeding, (int)dashboardEntity.timeOfDay, dashboardEntity.timeStamp];
        
        
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(Geolocus, insert_stmt, -1, &statement, NULL);
        
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Record Added..!!");
        }
        else {
            NSLog(@"No  Record..!!");
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(Geolocus);
    }
    NSLog(@"End of insert ..!!");
    
    
}


- (void) fetchDatabase:(NSInteger *) val3
{
    
    [self createDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"SELECT ID, DATE, USEDMILES, REWAREDSAVAILABLE, SCORE, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY FROM DASHBOARD_PARAMETER"];
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"All data has fetched.");
                
                /*
                 NSLog(@"DASHBOARD_PARAMETER id= %d",sqlite3_column_int(statement, 0));
                 NSLog(@"DASHBOARD_PARAMETER Date= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                 NSLog(@"DASHBOARD_PARAMETER used miles= %d",sqlite3_column_int(statement, 2));
                 NSLog(@"DASHBOARD_PARAMETER REWAREDSAVAILABLE= %d",sqlite3_column_int(statement, 3));
                 NSLog(@"DASHBOARD_PARAMETER SCORE= %d",sqlite3_column_int(statement, 4));
                 NSLog(@"DASHBOARD_PARAMETER ACCELERATION= %d",sqlite3_column_int(statement, 5));
                 NSLog(@"DASHBOARD_PARAMETER BRAKING= %d",sqlite3_column_int(statement, 6));
                 NSLog(@"DASHBOARD_PARAMETER CORNERING= %d",sqlite3_column_int(statement, 7));
                 NSLog(@"DASHBOARD_PARAMETER SPEEDING= %d",sqlite3_column_int(statement, 8));
                 NSLog(@"DASHBOARD_PARAMETER TIMEOFDAY= %d",sqlite3_column_int(statement, 9));
                 */
                
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
}




-(DashboardEntity*) fetchByDataDatabase: (NSString *) date {
    
    
    NSLog(@"date in fetchByDataDatabase= %@",date);
    
    
    [self createDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    DashboardEntity *dashboardEntity = [[DashboardEntity alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, USEDMILES, REWAREDSAVAILABLE, SCORE, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY, TIMESTAMP FROM DASHBOARD_PARAMETER WHERE DATE='%@' AND ID=(SELECT MAX(ID) FROM DASHBOARD_PARAMETER WHERE DATE='%@')",date, date];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                dashboardEntity.id = sqlite3_column_int(statement, 0);
                dashboardEntity.usedMiles = sqlite3_column_int(statement, 1);
                dashboardEntity.rewardsAvailable = sqlite3_column_int(statement, 2);
                dashboardEntity.driverScores = sqlite3_column_int(statement, 3);
                dashboardEntity.acceleration = sqlite3_column_int(statement, 4);
                dashboardEntity.braking = sqlite3_column_int(statement, 5);
                dashboardEntity.cornering = sqlite3_column_int(statement, 6);
                dashboardEntity.speeding = sqlite3_column_int(statement, 7);
                dashboardEntity.timeOfDay = sqlite3_column_int(statement, 8);
                
                dashboardEntity.timeStamp = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                
            }else {
                
                NSLog(@"No Data is available.");
                dashboardEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return dashboardEntity;
    
    
}




-(DashboardEntity*) fetchLastData {
    
    
    NSLog(@"Inside fetchLastData method.");
    
    
    [self createDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    DashboardEntity *dashboardEntity = [[DashboardEntity alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        //        NSString *querySQL = [NSString stringWithFormat:@"SELECT DATE, USEDMILES, REWAREDSAVAILABLE, SCORE, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY FROM DASHBOARD_PARAMETER WHERE ID=(SELECT MAX(ID) FROM DASHBOARD_PARAMETER)"];
        
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT USEDMILES, REWAREDSAVAILABLE, SCORE, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY FROM DASHBOARD_PARAMETER WHERE ID=(SELECT MAX(ID) FROM DASHBOARD_PARAMETER)"];
        
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                //                dashboardEntity.currentDate = sqlite3_column_int(statement, 0);
                //                dashboardEntity.usedMiles = sqlite3_column_int(statement, 1);
                //                dashboardEntity.rewardsAvailable = sqlite3_column_int(statement, 2);
                //                dashboardEntity.driverScores = sqlite3_column_int(statement, 3);
                //                dashboardEntity.acceleration = sqlite3_column_int(statement, 4);
                //                dashboardEntity.braking = sqlite3_column_int(statement, 5);
                //                dashboardEntity.cornering = sqlite3_column_int(statement, 6);
                //                dashboardEntity.speeding = sqlite3_column_int(statement, 7);
                //                dashboardEntity.timeOfDay = sqlite3_column_int(statement, 8);
                
                
                
                
                
                dashboardEntity.usedMiles = sqlite3_column_int(statement, 0);
                dashboardEntity.rewardsAvailable = sqlite3_column_int(statement, 1);
                dashboardEntity.driverScores = sqlite3_column_int(statement, 2);
                dashboardEntity.acceleration = sqlite3_column_int(statement, 3);
                dashboardEntity.braking = sqlite3_column_int(statement, 4);
                dashboardEntity.cornering = sqlite3_column_int(statement, 5);
                dashboardEntity.speeding = sqlite3_column_int(statement, 6);
                dashboardEntity.timeOfDay = sqlite3_column_int(statement, 7);
                
                
                
            }else {
                
                NSLog(@"No Data is available.");
                dashboardEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return dashboardEntity;
    
}


@end
