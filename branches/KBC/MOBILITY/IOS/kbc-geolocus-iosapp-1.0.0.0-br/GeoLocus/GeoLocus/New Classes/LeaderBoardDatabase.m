//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "LeaderBoardDatabase.h"

#import <sqlite3.h>

#import "LeaderBoardEntity.h"

@interface LeaderBoardDatabase() {
    
    NSDictionary *leaderBoardHistoryResult;
    NSDictionary *leaderBoardTopperResult;
    
}
@end

@implementation LeaderBoardDatabase


-(void) createLeaderBoardDatabase {
    
    NSLog(@"Inside createLeaderBoardDatabase method of LeaderBoardDatabase.");
    
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
            
            const char *sqlLeader_stmt = "CREATE TABLE IF NOT EXISTS LEADERBOARDDETAILS(ID INTEGER PRIMARY KEY AUTOINCREMENT, RANKINGID TEXT, INSUREDID TEXT, PREVIOUSRANK TEXT, CURRENTRANK TEXT, DRIVERSCORE TEXT, LOCATION TEXT, CURRENTDATE TEXT )";
            
            
            if (sqlite3_exec(Geolocus, sqlLeader_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table: LEADERBOARD");
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(Geolocus);
            
        } else {
            NSLog(@"Failed to open/create database");
            
        }
        
        NSLog(@"DATABASE has created");
    }
    
}




//save our data
- (void) insertLeaderBoardDatabase:(LeaderBoardEntity *) leaderBoardEntity
{
    [self createLeaderBoardDatabase];
    
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
        
        
        
        NSString *leaderboardInsert = [NSString stringWithFormat: @"INSERT INTO LEADERBOARDDETAILS (RANKINGID, INSUREDID, PREVIOUSRANK, CURRENTRANK, DRIVERSCORE, LOCATION, CURRENTDATE) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", leaderBoardEntity.rankingId, leaderBoardEntity.insuredId, leaderBoardEntity.previousRank, leaderBoardEntity.currentRank, leaderBoardEntity.driverScore, leaderBoardEntity.location, leaderBoardEntity.currentDate];
        
        
        
        
        const char *insert_stmt = [leaderboardInsert UTF8String];
        sqlite3_prepare_v2(Geolocus, insert_stmt, -1, &statement, NULL);
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Record Added in LEADERBOARD..!!");
        }
        else {
            NSLog(@"No  Record..!!");
        }
        
        
        
        sqlite3_finalize(statement);
        
        sqlite3_close(Geolocus);
    }
    NSLog(@"End of insert ..!!");
    
    
}



- (void) fetchLeaderBoardDatabase:(NSInteger *) val3
{
    [self createLeaderBoardDatabase];
    
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
                              @"SELECT ID, RANKINGID, INSUREDID, PREVIOUSRANK, CURRENTRANK, DRIVERSCORE, LOCATION, DISTANCEDRIVEN, PROCESSDATE FROM LEADERBOARD"];
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result for LEADERBOARD:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Fetched all data.");
                
                
                //
                //                 NSLog(@"SCORING_PAGE_WEEKLY id= %d",sqlite3_column_int(statement, 0));
                //                 NSLog(@"SCORING_PAGE_WEEKLY Date= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY ACCELERATION= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY BRAKING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY CORNERING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY SPEEDING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY TIMEOFDAY= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]);
                
                
            }
            
        }
        
        
        
        
        
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
}



-(NSArray*) fetchLeaderBoardLastData:(NSString *) cursorDate {
    
    
    NSLog(@"inside fetchLastData method");
    
    
    [self createLeaderBoardDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    NSMutableArray * topperArray = [[NSMutableArray alloc] init];
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    
    NSString *dateValue = [cursorDate substringWithRange:NSMakeRange(0,7)];
    NSLog(@"value of current date parameter in fetchLeaderBoardLastData is= %@",dateValue);
    
    
    leaderBoardTopperResult = NULL;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, RANKINGID, INSUREDID, PREVIOUSRANK, CURRENTRANK, DRIVERSCORE, LOCATION, CURRENTDATE FROM LEADERBOARDDETAILS WHERE strftime(\"%%Y-%%m\", CURRENTDATE) = '%@' ORDER BY CURRENTDATE", dateValue];
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result for LEADERBOARD:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            //        if (sqlite3_step(statement) == SQLITE_ROW)
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"fetchLeaderBoardLastData ID= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                NSLog(@"fetchLeaderBoardLastData RANKINGID= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                NSLog(@"fetchLeaderBoardLastData INSUREDID= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]);
                NSLog(@"fetchLeaderBoardLastData PREVIOUSRANK= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                NSLog(@"fetchLeaderBoardLastData CURRENTRANK= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]);
                NSLog(@"fetchLeaderBoardLastData DRIVERSCORE= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]);
                NSLog(@"fetchLeaderBoardLastData LOCATION= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]);
                NSLog(@"fetchLeaderBoardLastData CURRENTDATE= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]);
                
                
                leaderBoardTopperResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]],@"topperID", [NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]],@"topperRankingID",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]],@"topperInsuredID",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]],@"topperPreviousRank",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]],@"topperCurrentRank",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]],@"topperDriverScore",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]],@"topperLocation",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 7)]],@"currentDate", nil];
                
                
//                NSLog(@"leaderBoardTopperResult=%@",leaderBoardTopperResult);
                
                [topperArray addObject:leaderBoardTopperResult];
                
            }
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    
//    NSLog(@"topperArray = %@", topperArray);
    return topperArray;
    
    
}










-(void) createLeaderBoardHistoryDatabase {
    
    NSLog(@"Inside createLeaderBoardHistoryDatabase method of LeaderBoardDatabase.");
    
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
            
            
            const char *sqlLeader_stmt_history = "CREATE TABLE IF NOT EXISTS LEADER_BOARD_HISTORY(ID INTEGER PRIMARY KEY AUTOINCREMENT, CURRENTRANK TEXT, TOTALDISTANCECOVERED TEXT, PROCESSDATE TEXT, CURRENTDATE TEXT )";
            
            
            if (sqlite3_exec(Geolocus, sqlLeader_stmt_history, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table: LEADERBOARD_HISTORY");
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(Geolocus);
            
        } else {
            NSLog(@"Failed to open/create database");
            
        }
        
        NSLog(@"DATABASE has created");
    }
    
}




//save our data
- (void) insertLeaderBoardHistoryDatabase:(LeaderBoardEntity *) leaderBoardEntity
{
    [self createLeaderBoardHistoryDatabase];
    
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
        
        
        NSLog(@"leaderBoardEntity.currentRank = %@",leaderBoardEntity.currentRank);
        NSLog(@"leaderBoardEntity.distanceDriven = %@",leaderBoardEntity.distanceDriven);
        NSLog(@"leaderBoardEntity.processdate = %@",leaderBoardEntity.processdate);
        NSLog(@"leaderBoardEntity.currentDate = %@", leaderBoardEntity.currentDate);
        
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO LEADER_BOARD_HISTORY(CURRENTRANK, TOTALDISTANCECOVERED, PROCESSDATE, CURRENTDATE) VALUES (\"%@\", \"%@\", \"%@\", \"%@\")", leaderBoardEntity.currentRank, leaderBoardEntity.distanceDriven, leaderBoardEntity.processdate, leaderBoardEntity.currentDate];
        
        
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(Geolocus, insert_stmt, -1, &statement, NULL);
        
        
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Record Added in LEADERBOARD_HISTORY..!!");
        }
        else {
            
            
            NSLog(@"No  Record..!!");
        }
        if (sqlite3_prepare_v2(Geolocus, insert_stmt, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"prepare failed: %s", sqlite3_errmsg(Geolocus));
            
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(Geolocus);
    }
    NSLog(@"End of insert ..!!");
    
    
}



- (void) fetchLeaderBoardHistoryDatabase:(NSInteger *) val3
{
    [self createLeaderBoardHistoryDatabase];
    
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
        
        
        
        
        NSString *queryHistorySQL = [NSString stringWithFormat:
                                     @"SELECT ID, CURRENTRANK, PREVIOUSMONTHRANK, DISTANCECOVERED, PREVIOUSDISTANCECOVERED, PREVIOUSDATE0, PREVIOUSDATE1, CURRENTDATE, FUTUREDATEDATE FROM LEADER_BOARD_HISTORY"];
        const char *query_stmt_history = [queryHistorySQL UTF8String];
        
        NSLog(@"query result for LEADERBOARD_HISTORY:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt_history, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Fetched all data.");
                
                
                
                //                 NSLog(@"SCORING_PAGE_WEEKLY id= %d",sqlite3_column_int(statement, 0));
                //                 NSLog(@"SCORING_PAGE_WEEKLY Date= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY ACCELERATION= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY BRAKING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY CORNERING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY SPEEDING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY TIMEOFDAY= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]);
                
                
            }
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
}



//-(NSDictionary*) fetchLeaderBoardHistoryLastData:(NSString *) cursorDate {


-(NSMutableArray*) fetchLeaderBoardHistoryLastData:(NSString *) cursorDate :(NSString *) counterName {
    
    NSLog(@"inside fetchLeaderBoardHistoryLastData method");
    
    
    [self createLeaderBoardHistoryDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    NSMutableArray * historyArray = [[NSMutableArray alloc] init];
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    
    
    NSString *dateValue = [cursorDate substringWithRange:NSMakeRange(0,7)];
    NSLog(@"value of current date parameter in fetchLeaderBoardLastData is= %@",dateValue);
    
    leaderBoardHistoryResult = NULL;
    
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *queryHistorySQL = [NSString stringWithFormat:
                                     @"SELECT ID, CURRENTRANK, TOTALDISTANCECOVERED, PROCESSDATE, CURRENTDATE FROM LEADER_BOARD_HISTORY WHERE strftime(\"%%Y-%%m\", CURRENTDATE) = '%@' ORDER BY CURRENTDATE",dateValue];
        const char *query_stmt_history = [queryHistorySQL UTF8String];
        
        NSLog(@"query result for LEADERBOARD_HISTORY:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt_history, -1, &statement, NULL) == SQLITE_OK)
        {
            //  if (sqlite3_step(statement) == SQLITE_ROW)
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"Fetched all data.");
                
                
                NSLog(@"fetchLeaderBoardLastData ID= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                NSLog(@"fetchLeaderBoardLastData RANKINGID= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                NSLog(@"fetchLeaderBoardLastData INSUREDID= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]);
                NSLog(@"fetchLeaderBoardLastData PREVIOUSRANK= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                NSLog(@"fetchLeaderBoardLastData CURRENTDATE= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]);
                
                NSString* distanceCovered = [[NSString alloc] init];
                // distanceCovered = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                
                
                distanceCovered = [self getDistanceWithUnits:[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]: counterName];
                
                
                
                
                //                leaderBoardHistoryResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]],@"historyID", [NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]],@"historyCurrentRank",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]],@"historyDistanceCovered",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]],@"historyProcessDate",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]],@"currentDate", nil];
                
                
                
                leaderBoardHistoryResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]],@"historyID", [NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]],@"historyCurrentRank",[NSString stringWithFormat:@"%@",distanceCovered],@"historyDistanceCovered",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]],@"historyProcessDate",[NSString stringWithFormat:@"%@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]],@"currentDate", nil];
                
                
                
                
                
//                NSLog(@"leaderBoardHistoryResult=%@",leaderBoardHistoryResult);
                
                [historyArray addObject:leaderBoardHistoryResult];
                
                
                //                 NSLog(@"SCORING_PAGE_WEEKLY id= %d",sqlite3_column_int(statement, 0));
                //                 NSLog(@"SCORING_PAGE_WEEKLY Date= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY ACCELERATION= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY BRAKING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY CORNERING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 4)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY SPEEDING= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 5)]);
                //                 NSLog(@"SCORING_PAGE_WEEKLY TIMEOFDAY= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 6)]);
                
                
            }/*else {
              
              NSLog(@"No Data is available.");
              leaderBoardHistoryResult = NULL;
              } */
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    
//    NSLog(@"historyArray = %@",historyArray);
    
    return historyArray;
    
    //  return leaderBoardHistoryResult;
    
    
}




-(NSString*) getDistanceWithUnits:(NSString *)totalDistCovered:(NSString *)counterName {
    
    NSString* resultantDistance = [[NSString alloc] init];
    double totalDistCoveredDouble = [totalDistCovered doubleValue];
    
    if([counterName isEqualToString:@"US"]||[counterName isEqualToString:@"GB"]) {
        
        
        resultantDistance = [NSString stringWithFormat:@"%.2f", totalDistCoveredDouble * 0.00062137];
        //resultantDistance = [resultantDistance stringByAppendingString:@" mile"];
        
        
    }else {
        
        resultantDistance = [NSString stringWithFormat:@"%.2f", totalDistCoveredDouble / 1000];
        // resultantDistance = [resultantDistance stringByAppendingString:@" km"];
    }
    
    return resultantDistance;
}





@end
