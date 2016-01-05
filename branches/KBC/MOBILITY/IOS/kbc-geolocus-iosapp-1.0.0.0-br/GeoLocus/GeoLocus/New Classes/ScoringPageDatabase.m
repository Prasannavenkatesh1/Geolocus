//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "ScoringPageDatabase.h"

#import <sqlite3.h>
#import "ScoringEntity.h"

@implementation ScoringPageDatabase




-(void) createDatabase {
    
    NSLog(@"Inside createDatabase method of ScoringPageDatabase.");
    
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
    
    if ([filemgr fileExistsAtPath: databasePath ] == YES)
    {
		const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS SCORING_PAGE_WEEKLY(ID INTEGER PRIMARY KEY AUTOINCREMENT, DATE TEXT, ACCELERATION TEXT, BRAKING TEXT, CORNERING TEXT, SPEEDING TEXT, TIMEOFDAY TEXT )";
            
            
            if (sqlite3_exec(Geolocus, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table");
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(Geolocus);
            
        } else {
            NSLog(@"Failed to open/create database");
            
        }
        
        NSLog(@"DATABASE has created");
    }
    
    //[filemgr release];
    
}




//save our data
- (void) insertDatabase:(ScoringEntity *) scoringEntity
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
        
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSString *currentDate = [[NSString alloc] init];
        currentDate = [DateFormatter stringFromDate:[NSDate date]];
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO SCORING_PAGE_WEEKLY (DATE, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", currentDate, scoringEntity.weeklyAcceleration, scoringEntity.weeklyBraking, scoringEntity.weeklyCornering, scoringEntity.weeklySpeeding, scoringEntity.weeklyTimeOfDay];
        
        
        
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



//get information about a specfic employee by it's id
- (void) fetchDatabase:(NSInteger *) val3
{
    [self createDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    /* NSString *acceleration;
     NSString *braking;
     NSString *speed;  */
    
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
                              @"SELECT ID, DATE, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY FROM SCORING_PAGE_WEEKLY"];
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Fetched all data.");
                
                /*
                 
                 NSLog(@"SCORING_PAGE_WEEKLY id= %d",sqlite3_column_int(statement, 0));
                 NSLog(@"SCORING_PAGE_WEEKLY Date= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                 NSLog(@"SCORING_PAGE_WEEKLY ACCELERATION= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]);
                 NSLog(@"SCORING_PAGE_WEEKLY BRAKING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                 NSLog(@"SCORING_PAGE_WEEKLY CORNERING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]);
                 NSLog(@"SCORING_PAGE_WEEKLY SPEEDING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]);
                 NSLog(@"SCORING_PAGE_WEEKLY TIMEOFDAY= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]);
                 */
                
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
}




-(ScoringEntity*) fetchByDataDatabase: (NSString *) date {
    
    
    NSLog(@"date in fetchByDataDatabase= %@",date);
    
    
    [self createDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    /*  NSString *acceleration;
     NSString *braking;
     NSString *speed;  */
    
    NSMutableArray *mystr = [[NSMutableArray alloc] init];
    NSString *obj = @"hiagain";
    [mystr addObject:obj];
    
    ScoringEntity *scoringEntity = [[ScoringEntity alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY FROM SCORING_PAGE_WEEKLY WHERE DATE='%@'",date];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                /*
                 NSLog(@"SCORING_PAGE_WEEKLY id= %d",sqlite3_column_int(statement, 0));
                 NSLog(@"SCORING_PAGE_WEEKLY ACCELERATION= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                 NSLog(@"SCORING_PAGE_WEEKLY BRAKING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]);
                 NSLog(@"SCORING_PAGE_WEEKLY CORNERING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                 NSLog(@"SCORING_PAGE_WEEKLY SPEEDING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]);
                 NSLog(@"SCORING_PAGE_WEEKLY TIMEOFDAY= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]);
                 */
                
                scoringEntity.id = sqlite3_column_int(statement, 0);
                scoringEntity.weeklyAcceleration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                scoringEntity.weeklyBraking = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                scoringEntity.weeklyCornering = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                scoringEntity.weeklySpeeding = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                scoringEntity.weeklyTimeOfDay = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
            }else {
                
                NSLog(@"No Data is available.");
                scoringEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return scoringEntity;
    
    
}


-(ScoringEntity*) fetchLastWeeklyData {
    
    
    NSLog(@"inside fetchLastWeeklyData method");
    
    
    [self createDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    ScoringEntity *scoringEntity = [[ScoringEntity alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT DATE, ACCELERATION, BRAKING, CORNERING, SPEEDING, TIMEOFDAY FROM SCORING_PAGE_WEEKLY WHERE ID=(SELECT MAX(ID) FROM SCORING_PAGE_WEEKLY)"];
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                /*
                 NSLog(@"SCORING_PAGE_WEEKLY DATE= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                 NSLog(@"SCORING_PAGE_WEEKLY ACCELERATION= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                 NSLog(@"SCORING_PAGE_WEEKLY BRAKING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]);
                 NSLog(@"SCORING_PAGE_WEEKLY CORNERING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                 NSLog(@"SCORING_PAGE_WEEKLY SPEEDING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]);
                 NSLog(@"SCORING_PAGE_WEEKLY TIMEOFDAY= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]);
                 */
                
                
                scoringEntity.currentDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                scoringEntity.weeklyAcceleration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                scoringEntity.weeklyBraking = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                scoringEntity.weeklyCornering = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                scoringEntity.weeklySpeeding = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                scoringEntity.weeklyTimeOfDay = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                
            }else {
                
                NSLog(@"No Data is available.");
                scoringEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return scoringEntity;
    
    
}


@end
