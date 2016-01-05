//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "TripSummaryDatabase.h"
#import <sqlite3.h>
#import "TripSummaryEntity.h"


@implementation TripSummaryDatabase

-(void) createTripSummaryDb {
    
    NSLog(@"createTripSummaryDb method of TripSummaryDatabase class.");
    
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
            
            
            
            //  const char *sql_stmt = "CREATE TABLE IF NOT EXISTS TRIP_SUMMARY_COLLECTDATA(DEVICE_NUMBER TEXT, ACCELERATION TEXT, BRAKING TEXT, OVERSPEED TEXT, INCOMING_CALL TEXT, OUTGOING_CALL TEXT, TOTAL_DISTANCE_COVERED TEXT, TOTAL_DURATION TEXT, CURRENT_DATE TEXT )";
            
            
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS TRIP_SUMMARY_COLLECTDATA(iD INTEGER PRIMARY KEY AUTOINCREMENT, dEVICE_NUMBER TEXT, aCCELERATION TEXT, bRAKING TEXT, oVERSPEED TEXT, iNCOMING_CALL TEXT, oUTGOING_CALL TEXT, tOTAL_DISTANCE_COVERED TEXT, tOTAL_DURATION TEXT, cURRENT_DATE TEXT )";
            
            
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
    
    NSLog(@"end if");
    
    //[filemgr release];
    
}


-(void) deleteTripSummaryDb {
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from TRIP_SUMMARY_COLLECTDATA"];
        
        const char *delete_stmt = [deleteSQL UTF8String];
        sqlite3_prepare_v2(Geolocus, delete_stmt, -1, &statement, NULL );
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Record has deleted.");
            
        }else {
            
            NSLog(@"No Data is to delete.");
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    

    
}

- (void) insertTripSummaryDb:(TripSummaryEntity *) tripSummaryEntity
{
    
    [self createTripSummaryDb];
    
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
        NSLog(@"New data in insertTripSummaryDb method");
        
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM TRIP_SUMMARY_COLLECTDATA"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSString *updateSQL = [NSString stringWithFormat: @"UPDATE TRIP_SUMMARY_COLLECTDATA SET dEVICE_NUMBER = \"%@\", aCCELERATION = \"%@\", bRAKING = \"%@\", oVERSPEED = \"%@\", iNCOMING_CALL = \"%@\", oUTGOING_CALL = \"%@\", tOTAL_DISTANCE_COVERED = \"%@\", tOTAL_DURATION = \"%@\", cURRENT_DATE = \"%@\"", tripSummaryEntity.deviceNumber, tripSummaryEntity.acceleration, tripSummaryEntity.braking, tripSummaryEntity.overspeed, tripSummaryEntity.incomingCall, tripSummaryEntity.outgoingCall, tripSummaryEntity.totalDistCovered, tripSummaryEntity.totalDuration, tripSummaryEntity.currentDate];
                
                NSLog(@"\n\n %@ \n %@ \n %@ \n %@ \n %@ \n %@ \n %@ \n %@ \n %@ \n\n",tripSummaryEntity.deviceNumber, tripSummaryEntity.acceleration, tripSummaryEntity.braking, tripSummaryEntity.overspeed, tripSummaryEntity.incomingCall, tripSummaryEntity.outgoingCall, tripSummaryEntity.totalDistCovered, tripSummaryEntity.totalDuration, tripSummaryEntity.currentDate);
                
                const char *update_stmt = [updateSQL UTF8String];
                
                NSLog(@"Update Statement is : %s", update_stmt);
                
                sqlite3_prepare_v2(Geolocus, update_stmt, -1, &statement, NULL);
                
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Record updated from method insertTripSummaryDb.");
                }
                else {
                    NSLog(@"%s: step error: %s", __FUNCTION__, sqlite3_errmsg(Geolocus));
                    NSLog(@"No  Record has been updated from method insertTripSummaryDb.");
                }
                
                sqlite3_finalize(statement);
                
            }else {
                
                
                NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO TRIP_SUMMARY_COLLECTDATA (dEVICE_NUMBER, aCCELERATION, bRAKING, oVERSPEED, iNCOMING_CALL, oUTGOING_CALL, tOTAL_DISTANCE_COVERED, tOTAL_DURATION, cURRENT_DATE) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", tripSummaryEntity.deviceNumber, tripSummaryEntity.acceleration, tripSummaryEntity.braking, tripSummaryEntity.overspeed, tripSummaryEntity.incomingCall, tripSummaryEntity.outgoingCall, tripSummaryEntity.totalDistCovered, tripSummaryEntity.totalDuration, tripSummaryEntity.currentDate];
                
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(Geolocus, insert_stmt, -1, &statement, NULL);
                
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"Record Added from method insertTripSummaryDb.");
                }
                else {
                    NSLog(@"No  Record has been added from method insertTripSummaryDb.");
                }
                
                sqlite3_finalize(statement);
                
            }
            
        }

        sqlite3_close(Geolocus);
    }
    NSLog(@"End of insert in method insertTripSummaryDb.");
    
    
}



-(TripSummaryEntity*) fetchLatestTripData:(NSString *)deviceNumber counterName:(NSString *)counterName {
    
    
    NSLog(@"inside fetchLatestTripData method");
    
    
    [self createTripSummaryDb];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    TripSummaryEntity *tripSummaryEntity = [[TripSummaryEntity alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    NSLog(@"DB path databasePath : %@ \n\n ",databasePath);
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        //        NSString *querySQL = [NSString stringWithFormat:@"SELECT ACCELERATION, BRAKING, OVERSPEED, INCOMING_CALL, OUTGOING_CALL, TOTAL_DISTANCE_COVERED, TOTAL_DURATION, CURRENT_DATE FROM TRIP_SUMMARY_COLLECTDATA WHERE DEVICE_NUMBER='%@' AND ID=(SELECT MAX(ID) FROM TRIP_SUMMARY_COLLECTDATA WHERE DEVICE_NUMBER='%@')",deviceNumber, deviceNumber];
        
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT aCCELERATION, bRAKING, oVERSPEED, iNCOMING_CALL, oUTGOING_CALL, tOTAL_DISTANCE_COVERED, tOTAL_DURATION, cURRENT_DATE FROM TRIP_SUMMARY_COLLECTDATA WHERE dEVICE_NUMBER='%@'",deviceNumber];
        
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSLog(@"0 = %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)]);
                NSLog(@"1 = %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)]);
                NSLog(@"2 = %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)]);
                NSLog(@"3 = %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)]);
                NSLog(@"4 = %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)]);
                NSLog(@"5 = %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)]);
                NSLog(@"6 = %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)]);
                NSLog(@"7 = %@", [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)]);
                
                
                tripSummaryEntity.acceleration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                tripSummaryEntity.braking = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                tripSummaryEntity.overspeed = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                tripSummaryEntity.incomingCall = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                tripSummaryEntity.outgoingCall = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                tripSummaryEntity.totalDistCovered = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                tripSummaryEntity.totalDuration = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                tripSummaryEntity.currentDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                
            }else {
                
                NSLog(@"No Data is available.");
                //tripSummaryEntity = NULL;
                
                tripSummaryEntity.acceleration = @"0";
                tripSummaryEntity.braking = @"0";
                tripSummaryEntity.overspeed = @"0";
                tripSummaryEntity.incomingCall = @"0";
                tripSummaryEntity.outgoingCall = @"0";
                tripSummaryEntity.totalDistCovered = @"0";
                tripSummaryEntity.totalDuration = @"0";
                tripSummaryEntity.currentDate = @"0";
                
                
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    
    
//    tripSummaryEntity.totalDistCovered = [self getDistanceWithUnits:tripSummaryEntity.totalDistCovered: counterName];
//    tripSummaryEntity.totalDuration = [self getTimeFormatted:tripSummaryEntity.totalDuration];
    
    
    return tripSummaryEntity;
    
    
}



-(NSString*) getDistanceWithUnits:(NSString *)totalDistCovered :(NSString *)counterName {
    
    NSString* resultantDistance = [[NSString alloc] init];
    double totalDistCoveredDouble = [totalDistCovered doubleValue];
    
    if([counterName isEqualToString:@"US"]||[counterName isEqualToString:@"GB"]) {
        
        
        resultantDistance = [NSString stringWithFormat:@"%.2f", totalDistCoveredDouble * 0.00062137];
        resultantDistance = [resultantDistance stringByAppendingString:@" mile"];
        
        
    }else {
        
        resultantDistance = [NSString stringWithFormat:@"%.2f", totalDistCoveredDouble / 1000];
        resultantDistance = [resultantDistance stringByAppendingString:@" km"];
    }
    
    return resultantDistance;
}




/*
 -(NSString*) getDistanceWithUnits:(NSString *)totalDistCovered:(NSString *)counterName {
 
 NSString* resultantDistance = [[NSString alloc] init];
 double totalDistCoveredDouble = [totalDistCovered doubleValue];
 
 if([counterName isEqualToString:@"IN"]||[counterName isEqualToString:@"GB"]||[counterName isEqualToString:@"UK"]) {
 
 resultantDistance = [NSString stringWithFormat:@"%.2f", totalDistCoveredDouble / 1000];
 resultantDistance = [resultantDistance stringByAppendingString:@" km"];
 
 }else if ([counterName isEqualToString:@"US"]) {
 
 resultantDistance = [NSString stringWithFormat:@"%.2f", totalDistCoveredDouble * 0.00062137];
 resultantDistance = [resultantDistance stringByAppendingString:@" mile"];
 }
 
 return resultantDistance;
 }
 */



-(NSString*) getTimeFormatted:(NSString *)totalDuration {
    
    NSString* resultantDuration = [[NSString alloc] init];
    
    int seconds = [totalDuration integerValue] % 60;
    int minutes = ([totalDuration integerValue] / 60) % 60;
    int hours = [totalDuration integerValue] / 3600;
    
    resultantDuration = [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
    return resultantDuration;
    
    
}



@end
