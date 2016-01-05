//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

#import "RegistrationDatabase.h"
#import <sqlite3.h>

#import "RegistrationEntity.h"

@implementation RegistrationDatabase

-(NSString*) fetchLastInsuredID
{
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    NSString *resultInsuredID = [[NSString alloc] init];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT INSURED_ID FROM USER_LOGIN_REGISTRATION WHERE ID=(SELECT MAX(ID) FROM USER_LOGIN_REGISTRATION)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result of fetchLastInsuredID:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"REGISTRATION_DETAILS insured id= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                
                resultInsuredID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }else {
                
                NSLog(@"No Data is available.");
                resultInsuredID = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return resultInsuredID;
    
    
}


/*
 
 -(void) deleteRecord {
 
 
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
 
 NSString *deleteSQL = [NSString stringWithFormat:@"DELETE from REGISTRATION_DETAILS"];
 
 const char *delete_stmt = [deleteSQL UTF8String];
 sqlite3_prepare_v2(Geolocus, delete_stmt, -1, &statement, NULL );
 if (sqlite3_step(statement) == SQLITE_DONE)
 {
 NSLog(@"Record has deleted.");
 
 }else {
 
 NSLog(@"No Data is to delete.");
 
 }
 
 }
 sqlite3_finalize(statement);
 sqlite3_close(Geolocus);
 
 }
 
 
 
 */






// creating database for storing the data get from login service.

-(void) createLoginDatabase {
    
    NSLog(@"createLoginDatabase method of RegistrationDatabase class.");
    
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
    
    if ([filemgr fileExistsAtPath: databasePath ] == NO)
    {
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS USER_LOGIN_REGISTRATION(ID INTEGER PRIMARY KEY AUTOINCREMENT, ACCOUNT_ID TEXT, ACTIVE TEXT, AGREEMENT_NUMBER TEXT, COUNTRY_CODE TEXT, DELETED TEXT, DEVICE_NUMBER TEXT, END_DATE TEXT, INSURED_ID TEXT, INSURED_TYPE TEXT, ISSUE_DATE TEXT, LANGUAGE_CODE TEXT, PHONE_NUMBER TEXT, PROFILE_NAME TEXT, UOM_CATEGORY_ID TEXT, USER_ID TEXT, USER_NAME TEXT, PASSWORD TEXT, CURRENTDATE TEXT, SERVICE_TOKEN TEXT )";
            
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



//save our data
- (void) insertLoginDatabase :(RegistrationEntity *)registrationEntity
{
    [self createLoginDatabase];
    
    sqlite3_stmt *statement = NULL;
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
//    NSLog(@"Current Date: %@",currentDate);
//    
//    NSLog(@"registrationEntity.accountID: %@",registrationEntity.accountID);
//    NSLog(@"registrationEntity. isActive: %@",registrationEntity.isActive);
//    NSLog(@"registrationEntity. agreementNumber: %@",registrationEntity.agreementNumber);
//    NSLog(@"registrationEntity. countryCode: %@",registrationEntity.countryCode);
//    NSLog(@"registrationEntity. isDeleted: %@",registrationEntity.isDeleted);
//    NSLog(@"registrationEntity. deviceID: %@",registrationEntity.deviceID);
//    NSLog(@"registrationEntity. endDate: %@",registrationEntity.endDate);
//    NSLog(@"registrationEntity. insuredID: %@",registrationEntity.insuredID);
//    NSLog(@"registrationEntity. insuredType: %@",registrationEntity.insuredType);
//    NSLog(@"registrationEntity. issueDate: %@",registrationEntity.issueDate);
//    NSLog(@"registrationEntity. languageCode: %@",registrationEntity.languageCode);
//    NSLog(@"registrationEntity. phoneNumber: %@",registrationEntity.phoneNumber);
//    NSLog(@"registrationEntity. profileName: %@",registrationEntity.profileName);
//    NSLog(@"registrationEntity. uomCategoryID: %@",registrationEntity.uomCategoryID);
//    NSLog(@"registrationEntity. userID: %@",registrationEntity.userID);
//    NSLog(@"registrationEntity. userName: %@",registrationEntity.userName);
//    NSLog(@"registrationEntity. password: %@",registrationEntity.password);
//    NSLog(@"registrationEntity. serviceToken: %@",registrationEntity.serviceToken);
    
    
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        
        NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO USER_LOGIN_REGISTRATION(ACCOUNT_ID, ACTIVE, AGREEMENT_NUMBER, COUNTRY_CODE, DELETED, DEVICE_NUMBER, END_DATE, INSURED_ID, INSURED_TYPE, ISSUE_DATE, LANGUAGE_CODE, PHONE_NUMBER, PROFILE_NAME, UOM_CATEGORY_ID, USER_ID, USER_NAME, PASSWORD, CURRENTDATE, SERVICE_TOKEN) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")", registrationEntity.accountID, registrationEntity.isActive, registrationEntity.agreementNumber, registrationEntity.countryCode, registrationEntity.isDeleted, registrationEntity.deviceID, registrationEntity.endDate, registrationEntity.insuredID, registrationEntity.insuredType, registrationEntity.issueDate, registrationEntity.languageCode, registrationEntity.phoneNumber, registrationEntity.profileName, registrationEntity.uomCategoryID, registrationEntity.userID, registrationEntity.userName, registrationEntity.password, currentDate, registrationEntity.serviceToken];
        
        
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


-(RegistrationEntity*) fetchByDeviceIDAndUsername :(NSString *)deviceID :(NSString *)userName
{
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    RegistrationEntity *registrationEntity = [[RegistrationEntity alloc] init];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, ACCOUNT_ID, ACTIVE, AGREEMENT_NUMBER, COUNTRY_CODE, DELETED, END_DATE, INSURED_ID, INSURED_TYPE, ISSUE_DATE, LANGUAGE_CODE, PHONE_NUMBER, PROFILE_NAME, UOM_CATEGORY_ID, USER_ID, PASSWORD, SERVICE_TOKEN FROM USER_LOGIN_REGISTRATION WHERE DEVICE_NUMBER='%@' and USER_NAME='%@'",deviceID, userName];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                
                NSLog(@"REGISTRATION_DETAILS id= %d",sqlite3_column_int(statement, 0));
                NSLog(@"REGISTRATION_DETAILS insured id= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                
                registrationEntity.id = sqlite3_column_int(statement, 0);
                
                registrationEntity.accountID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                registrationEntity.isActive = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                registrationEntity.agreementNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                registrationEntity.countryCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                registrationEntity.isDeleted = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                registrationEntity.endDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                registrationEntity.insuredID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                registrationEntity.insuredType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                registrationEntity.issueDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                registrationEntity.languageCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                registrationEntity.phoneNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                registrationEntity.profileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                registrationEntity.uomCategoryID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                registrationEntity.userID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                registrationEntity.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                registrationEntity.serviceToken = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                
                
            }else {
                
                NSLog(@"No Data is available in method fetchByDeviceIDAndUsername.");
                registrationEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return registrationEntity;
    
    
}



-(NSString*) fetchLastDeviceID
{
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    NSString *resultDeviceID = [[NSString alloc] init];
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT DEVICE_NUMBER FROM USER_LOGIN_REGISTRATION WHERE ID=(SELECT MAX(ID) FROM USER_LOGIN_REGISTRATION)"];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result of fetchLastInsuredID:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"REGISTRATION_DETAILS insured id= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                
                resultDeviceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }else {
                
                NSLog(@"No Data is available in method fetchLastDeviceID.");
                resultDeviceID = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return resultDeviceID;
    
    
}


-(RegistrationEntity*) fetchDataByDate :(NSString *)currentDate {
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    RegistrationEntity *registrationEntity = [[RegistrationEntity alloc] init];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    NSString *dateValue = [currentDate substringWithRange:NSMakeRange(0,7)];
    NSLog(@"value of current date parameter in fetchDataByDate is= %@",dateValue);
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, ACCOUNT_ID, ACTIVE, AGREEMENT_NUMBER, COUNTRY_CODE, DELETED, END_DATE, INSURED_ID, INSURED_TYPE, ISSUE_DATE, LANGUAGE_CODE, PHONE_NUMBER, PROFILE_NAME, UOM_CATEGORY_ID, USER_ID,  PASSWORD, USER_NAME, DEVICE_NUMBER FROM USER_LOGIN_REGISTRATION WHERE strftime(\"%%Y-%%m\", CURRENTDATE) = '%@' ORDER BY CURRENTDATE", dateValue];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                registrationEntity.id = sqlite3_column_int(statement, 0);
                registrationEntity.accountID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                registrationEntity.isActive = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                registrationEntity.agreementNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                registrationEntity.countryCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                registrationEntity.isDeleted = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                registrationEntity.endDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                registrationEntity.insuredID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                registrationEntity.insuredType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                registrationEntity.issueDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                registrationEntity.languageCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                registrationEntity.phoneNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                registrationEntity.profileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                registrationEntity.uomCategoryID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                registrationEntity.userID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                registrationEntity.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                registrationEntity.userName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                registrationEntity.deviceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                
            }else {
                
                NSLog(@"No Data is available in method fetchDataByDate.");
                registrationEntity = NULL;
            }
            
        } else if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) != SQLITE_OK) {
            NSLog(@"prepare failed: %s", sqlite3_errmsg(Geolocus));
            
        }
        
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return registrationEntity;
}


-(RegistrationEntity*) fetchDataByUsername :(NSString *)userName
{
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    RegistrationEntity *registrationEntity = [[RegistrationEntity alloc] init];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ID, ACCOUNT_ID, ACTIVE, AGREEMENT_NUMBER, COUNTRY_CODE, DELETED, END_DATE, INSURED_ID, INSURED_TYPE, ISSUE_DATE, LANGUAGE_CODE, PHONE_NUMBER, PROFILE_NAME, UOM_CATEGORY_ID, USER_ID, PASSWORD, DEVICE_NUMBER, CURRENTDATE, SERVICE_TOKEN FROM USER_LOGIN_REGISTRATION WHERE USER_NAME='%@'", userName];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"REGISTRATION_DETAILS id= %d",sqlite3_column_int(statement, 0));
                NSLog(@"REGISTRATION_DETAILS insured id= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)]);
                
                registrationEntity.id = sqlite3_column_int(statement, 0);
                registrationEntity.accountID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
                registrationEntity.isActive = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
                registrationEntity.agreementNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
                registrationEntity.countryCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
                registrationEntity.isDeleted = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
                registrationEntity.endDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 6)];
                registrationEntity.insuredID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
                registrationEntity.insuredType = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
                registrationEntity.issueDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
                registrationEntity.languageCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
                registrationEntity.phoneNumber = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 11)];
                registrationEntity.profileName = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 12)];
                registrationEntity.uomCategoryID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 13)];
                registrationEntity.userID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 14)];
                registrationEntity.password = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 15)];
                registrationEntity.deviceID = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 16)];
                registrationEntity.currentDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 17)];
                registrationEntity.serviceToken = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 18)];
                
                
            }else {
                
                NSLog(@"No Data is available in method fetchDataByUsername.");
                registrationEntity = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return registrationEntity;
}


-(NSString*) fetchTokenByInsuredID :(NSString *)insuredID
{
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    NSString *resultToken = [[NSString alloc] init];
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT SERVICE_TOKEN FROM USER_LOGIN_REGISTRATION WHERE INSURED_ID='%@'", insuredID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"REGISTRATION_DETAILS resultToken= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                
                resultToken = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }else {
                
                NSLog(@"No Data is available in method fetchTokenByInsuredID.");
                resultToken = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return resultToken;
    
    
}


-(NSString*) fetchCountryCodeByDeviceID: (NSString *) deviceID
{
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    NSString *countryCode = [[NSString alloc] init];
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT COUNTRY_CODE FROM USER_LOGIN_REGISTRATION WHERE DEVICE_NUMBER='%@'", deviceID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"USER_REGISTRATION_DETAILS countryCode= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                
                countryCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }else {
                
                NSLog(@"No Data is available in method fetchCountryCodeByDeviceID.");
                countryCode = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return countryCode;
    
    
}



-(NSString*) fetchAccountIdByInsuredID :(NSString *)insuredID
{
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    NSString *accountId = [[NSString alloc] init];
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ACCOUNT_ID FROM USER_LOGIN_REGISTRATION WHERE INSURED_ID='%@'", insuredID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"REGISTRATION_DETAILS ACCOUNT_ID= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                
                accountId = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }else {
                
                NSLog(@"No Data is available in method fetchTokenByInsuredID.");
                accountId = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return accountId;
    
    
}

-(NSString*) fetchAccountCodeByInsuredID :(NSString *)insuredID
{
    
    [self createLoginDatabase];
    
    NSString *docsDir;
    NSArray *dirPaths;
    NSString *databasePath;
    sqlite3 *Geolocus;
    
    
    NSString *accountCode = [[NSString alloc] init];
    
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = [dirPaths objectAtIndex:0];
    
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"Geolocus.db"]];
    
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt *statement;
    
    if (sqlite3_open(dbpath, &Geolocus) == SQLITE_OK)
    {
        
        NSString *querySQL = [NSString stringWithFormat:@"SELECT ACCOUNT_CODE FROM USER_LOGIN_REGISTRATION WHERE INSURED_ID='%@'", insuredID];
        
        const char *query_stmt = [querySQL UTF8String];
        
        NSLog(@"query result:");
        
        if (sqlite3_prepare_v2(Geolocus, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            
            
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                
                NSLog(@"REGISTRATION_DETAILS ACCOUNT_CODE= %@",[[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 0)]);
                
                accountCode = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 0)];
                
            }else {
                
                NSLog(@"No Data is available in method fetchTokenByInsuredID.");
                accountCode = NULL;
            }
            
        }
        sqlite3_finalize(statement);
        sqlite3_close(Geolocus);
    }
    
    return accountCode;
    
    
}


@end
