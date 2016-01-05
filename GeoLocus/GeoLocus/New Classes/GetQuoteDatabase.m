//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "GetQuoteDatabase.h"
#import <sqlite3.h>
#import "GetQuoteEntity.h"

@implementation GetQuoteDatabase


-(void) createGetQuoteDatabase {
    
    NSLog(@"Welcome to createGetQuoteDatabase");
    
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
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS GET_QUOTE(ID INTEGER PRIMARY KEY AUTOINCREMENT, INSURED_ID TEXT, FINAL_PREMIUM TEXT, JOB_NUMBER TEXT, SUBTOTAL_PREMIUM TEXT, TAX_SUBCHARGE TEXT, CALL_OUTGOING_CNT TEXT, COVERAGE_DETAILS TEXT, CURRENT_DATE TEXT )";
            
            
            if (sqlite3_exec(Geolocus, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create table: GET_QUOTE");
                
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(Geolocus);
            
        } else {
            NSLog(@"Failed to open/create database");
            
        }
        
        NSLog(@"DATABASE has created");
    }
    
}


-(void) insertGetQuoteData:(GetQuoteEntity *)getQuoteEntity
{
    
    [self createGetQuoteDatabase];
    
    NSLog(@"coverage details: %@", getQuoteEntity.coveragedetails);
   
     NSData *jsonData = NULL;
    
    if (getQuoteEntity.coveragedetails != NULL){
    
    
    NSError *error;
   jsonData = [NSJSONSerialization dataWithJSONObject:getQuoteEntity.coveragedetails
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    
    NSLog(@"JSON for coverage details: %@", jsonData);
    
    NSString* jsonFormatedString;
    jsonFormatedString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
     NSLog(@"JSON String for coverage details: %@", jsonFormatedString);
    }
    
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
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO GET_QUOTE (INSURED_ID, FINAL_PREMIUM, JOB_NUMBER, SUBTOTAL_PREMIUM, TAX_SUBCHARGE, CALL_OUTGOING_CNT, COVERAGE_DETAILS, CURRENT_DATE) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", getQuoteEntity.insuredId, getQuoteEntity.finalpremium, getQuoteEntity.jobnumber, getQuoteEntity.premiumsubtotal, getQuoteEntity.taxvalue, getQuoteEntity.ubidiscount, jsonData, currentDate];
        
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(Geolocus, insert_stmt, -1, &statement, NULL);
        
        
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"Record Added into GET_QUOTE!!");
        }
        else {
            NSLog(@"No  Record..!! ERROR: '%s'", sqlite3_errmsg(Geolocus));
        }
        
        sqlite3_finalize(statement);
        
        sqlite3_close(Geolocus);
    }
    NSLog(@"End of insert for GET_QUOTE..!!");
    
    
}



-(GetQuoteEntity*) fetchLastQuoteByInsuredId: (NSString *) insuredId {
    
    
    NSLog(@"date in fetchLastQuoteByInsuredId= %@",insuredId);
    
    [self createGetQuoteDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    GetQuoteEntity *getQuoteEntity = [[GetQuoteEntity alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, INSURED_ID, FINAL_PREMIUM, JOB_NUMBER, SUBTOTAL_PREMIUM, TAX_SUBCHARGE, CALL_OUTGOING_CNT, COVERAGE_DETAILS, CURRENT_DATE FROM GET_QUOTE WHERE INSURED_ID='%@' AND ID=(SELECT MAX(ID) FROM GET_QUOTE WHERE INSURED_ID='%@')",insuredId, insuredId];
        
        const char *query_stmt = [querySQL UTF8String];
               
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                getQuoteEntity.id = sqlite3_column_int(statement, 0);
                getQuoteEntity.insuredId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                getQuoteEntity.finalpremium = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                getQuoteEntity.jobnumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                getQuoteEntity.premiumsubtotal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                getQuoteEntity.taxvalue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                getQuoteEntity.ubidiscount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                getQuoteEntity.coveragedetails = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                getQuoteEntity.currentDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                
            }else {
                
                NSLog(@"No Data is available.");
                getQuoteEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return getQuoteEntity;
    
    
}


-(GetQuoteEntity*) fetchQuoteByCurrentDate: (NSString *) insuredId: (NSString *) date {
    
    
    NSLog(@"In fetchQuoteByCurrentDate");
    
    [self createGetQuoteDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    GetQuoteEntity *getQuoteEntity = [[GetQuoteEntity alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, INSURED_ID, FINAL_PREMIUM, JOB_NUMBER, SUBTOTAL_PREMIUM, TAX_SUBCHARGE, CALL_OUTGOING_CNT, COVERAGE_DETAILS, CURRENT_DATE FROM GET_QUOTE WHERE INSURED_ID='%@' AND CURRENT_DATE='%@' AND ID=(SELECT MAX(ID) FROM GET_QUOTE WHERE INSURED_ID='%@')",insuredId, date, insuredId];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                getQuoteEntity.id = sqlite3_column_int(statement, 0);
                getQuoteEntity.insuredId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                getQuoteEntity.finalpremium = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                getQuoteEntity.jobnumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                getQuoteEntity.premiumsubtotal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                getQuoteEntity.taxvalue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                getQuoteEntity.ubidiscount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                getQuoteEntity.coveragedetails = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                getQuoteEntity.currentDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                
            }else {
                
                NSLog(@"No Data is available.");
                getQuoteEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return getQuoteEntity;
    
    
}


-(GetQuoteEntity*) fetchLastQuoteDetails {
    
    
    NSLog(@"In fetchLastQuoteDetails");
    
    [self createGetQuoteDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    GetQuoteEntity *getQuoteEntity = [[GetQuoteEntity alloc] init];
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, INSURED_ID, FINAL_PREMIUM, JOB_NUMBER, SUBTOTAL_PREMIUM, TAX_SUBCHARGE, CALL_OUTGOING_CNT, COVERAGE_DETAILS, CURRENT_DATE FROM GET_QUOTE WHERE ID=(SELECT MAX(ID) FROM GET_QUOTE)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                getQuoteEntity.id = sqlite3_column_int(statement, 0);
                getQuoteEntity.insuredId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                getQuoteEntity.finalpremium = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                getQuoteEntity.jobnumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                getQuoteEntity.premiumsubtotal = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                getQuoteEntity.taxvalue = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                getQuoteEntity.ubidiscount = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                getQuoteEntity.coveragedetails = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                getQuoteEntity.currentDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                
                
            }else {
                
                NSLog(@"No Data is available.");
                getQuoteEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return getQuoteEntity;
    
    
}



@end
