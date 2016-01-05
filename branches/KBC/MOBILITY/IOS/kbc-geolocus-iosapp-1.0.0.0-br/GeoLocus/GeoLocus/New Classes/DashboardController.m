//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "DashboardController.h"
#import "DashboardDatabase.h"
#import "DashboardEntity.h"
#import "Reachability.h"
#import "DashboardDB.h"

#import "ServiceConstants.h"

#import <math.h>

@interface DashboardController () {
    
    NSDictionary *dictionary;
    NSDictionary *dictNew;
    
    BOOL pageStillLoading;
    NSInteger resultantDistance;
    
}

@end

@implementation DashboardController



- (DashboardEntity *) displayDashboard :(NSString *)insuredID :(NSString *)resultToken :(NSString *)counterName :(NSString *)accountId :(NSString *)accountCode{
    
    
    NSLog(@"inside displayDashboard method of DashboardController.");
    
    
    
    /* NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
     [DateFormatter setDateFormat:@"yyyy/MM/dd"];
     NSString *currentDate = [[NSString alloc] init];
     currentDate = [DateFormatter stringFromDate:[NSDate date]];  */
    
    
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [self getCurrentDate];
    
    
    NSLog(@"Current Date: %@",currentDate);
    
    DashboardEntity *dashboardEntity = [[DashboardEntity alloc] init];
    DashboardDatabase* dashboardDatabase = [[DashboardDatabase alloc] init];
    
    dashboardEntity = [dashboardDatabase fetchByDataDatabase:currentDate];
    
//    dashboardEntity = [[DashboardDB sharedInstance] fetchByDataDatabase:currentDate];
    
    NSLog(@"dashboardEntity: %@",dashboardEntity);
    
    NSTimeInterval timeStamp = ([[NSDate date] timeIntervalSince1970] * 1000.0);
    NSString *intervalString = [NSString stringWithFormat:@"%f", timeStamp];
    
    
    if ([intervalString doubleValue] - [dashboardEntity.timeStamp doubleValue] >= 7200000) {
        dashboardEntity = NULL;
    }
    
    
    if (dashboardEntity == NULL) {
        
        if (![self connected]) {
            NSLog(@"Internet is not connected");
            
            dashboardEntity = [dashboardDatabase fetchLastData];
//            dashboardEntity = [[DashboardDB sharedInstance] fetchLastData];
            dashboardEntity.usedMiles = [self distanceConversion:dashboardEntity.usedMiles :counterName];
            return dashboardEntity;
            // not connected
        }else {
            NSLog(@"Internet is connected");
            
            pageStillLoading = YES;
            
            NSLog(@"The value of Insured Id is : %@" ,insuredID);
            NSString *urlAsString = [NSString stringWithFormat:DASHBOARDURL,insuredID,accountId];
            
            NSURL *url = [NSURL URLWithString:urlAsString];
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
            
            NSLog(@"The value of account code is : %@" ,accountCode);
            
            [request setHTTPMethod:@"GET"];
            [request setValue:resultToken forHTTPHeaderField:@"SPRING_SECURITY_REMEMBER_ME_COOKIE"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:accountCode forHTTPHeaderField:@"AccountCode"];
            
            [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
            
            while (pageStillLoading) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            
            if ([dashboardDatabase fetchByDataDatabase:currentDate] != NULL) {
//            if ([[DashboardDB sharedInstance] fetchByDataDatabase:currentDate] != NULL) {
                dashboardEntity = [dashboardDatabase fetchByDataDatabase:currentDate];
//                dashboardEntity = [[DashboardDB sharedInstance] fetchByDataDatabase:currentDate];
                NSLog(@"Data is not null..!!");
                //// return dashboardEntity;
            }else {
                
                dashboardEntity = [dashboardDatabase fetchLastData];
//                dashboardEntity = [[DashboardDB sharedInstance] fetchLastData];
            }
            
            NSLog(@"distance driven before= %i",dashboardEntity.usedMiles);
            
            dashboardEntity.usedMiles = [self distanceConversion:dashboardEntity.usedMiles :counterName];
            NSLog(@"distance driven after= %i",dashboardEntity.usedMiles);
            
            return dashboardEntity;
        }
    } else {
        
        dashboardEntity.usedMiles = [self distanceConversion:dashboardEntity.usedMiles :counterName];
        NSLog(@"distance driven after= %i",dashboardEntity.usedMiles);
        
        return dashboardEntity;
    }
    
    
    return dashboardEntity;
    
}



- (NSString*) getCurrentDate {
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    return currentDate;
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

/*
 - (NSInteger) distanceConversion :(NSInteger *)distanceInMeters :(NSString *)country {
 
 if (([country caseInsensitiveCompare:@"IN"]||[country isEqualToString:@"GB"]||[country isEqualToString:@"UK"]) == NSOrderedSame) {
 
 resultantDistance = ((int)distanceInMeters)/1000;
 
 } else if([country caseInsensitiveCompare:@"US"] == NSOrderedSame){
 
 resultantDistance = (NSInteger)(((int)distanceInMeters)*0.00062137);
 }
 
 return resultantDistance;
 
 }
 */





- (NSInteger) distanceConversion :(NSInteger *)distanceInMeters :(NSString *)country {
    
    if (([country caseInsensitiveCompare:@"US"]||[country isEqualToString:@"GB"]) == NSOrderedSame) {
        
        resultantDistance = (NSInteger)(((int)distanceInMeters)*0.00062137);
        
    } else {
        
        resultantDistance = ((int)distanceInMeters)/1000;
        
    }
    
    return resultantDistance;
    
}




- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}


- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSLog(@"Authentication challenge");
    
    if ([challenge previousFailureCount] == 0)
    {
        
        NSString *username = @"Geolocusincidents";
        NSString *password = @"G111111#";
        
        NSURLCredential *credential = [NSURLCredential credentialWithUser:username
                                                                 password:password
                                                              persistence:NSURLCredentialPersistenceForSession];
        [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        
    } else {
        NSLog(@"Credentials are wrong!");
        
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    NSLog(@"inside didReceiveResponse response= %@",response);
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"inside didFailWithError = %@",error);
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSError *e;
    dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&e];
//    NSLog(@"dictionary = %@", dictionary);
    
//    NSLog(@"policyAgg= %@",[dictionary objectForKey:@"policyAggregates"]);
    
    DashboardDatabase* dashboardDatabase = [[DashboardDatabase alloc] init];
    DashboardEntity *dashboardEntity = [[DashboardEntity alloc] init];
    
    
    /* NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
     [DateFormatter setDateFormat:@"yyyy/MM/dd"];
     NSString *currentDate = [[NSString alloc] init];
     currentDate = [DateFormatter stringFromDate:[NSDate date]];
     
     dashboardEntity.currentDate = currentDate; */
    
    dashboardEntity.currentDate = [self getCurrentDate];
    
    if ([dictionary objectForKey:@"policyAggregates"] != [NSNull null]) {
        
        dictNew = [dictionary valueForKeyPath:@"policyAggregates"][0];
        
        dashboardEntity.acceleration = [dictNew[@"accelerationScore"] intValue];
        dashboardEntity.braking = [dictNew[@"brakingScore"] intValue];
        dashboardEntity.cornering = [dictNew[@"corneringScore"] intValue];
        dashboardEntity.driverScores = [dictNew[@"totalScore"] intValue];
        dashboardEntity.rewardsAvailable = [dictNew[@"rewards"] intValue];
        dashboardEntity.speeding = [dictNew[@"speedingScore"] intValue];
        dashboardEntity.timeOfDay = [dictNew[@"todScore"] intValue];
        dashboardEntity.usedMiles = [dictNew[@"distance"] intValue];
        
        
        NSTimeInterval timeStamp = ([[NSDate date] timeIntervalSince1970] * 1000.0);
        // NSTimeInterval is defined as double
        //  NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString *intervalString = [NSString stringWithFormat:@"%f", timeStamp];
        
        NSLog(@"intervalString = %@", intervalString);
        dashboardEntity.timeStamp = intervalString;
        
//        [[DashboardDB sharedInstance]insertDatabase:dashboardEntity];
        
        [dashboardDatabase insertDatabase:dashboardEntity];
        
    } else {
        
        dashboardEntity.acceleration = 0;
        dashboardEntity.braking = 0;
        dashboardEntity.cornering = 0;
        dashboardEntity.driverScores = 0;
        dashboardEntity.rewardsAvailable = 0;
        dashboardEntity.speeding = 0;
        dashboardEntity.timeOfDay = 0;
        dashboardEntity.usedMiles = 0;
        
        
        NSTimeInterval timeStamp = ([[NSDate date] timeIntervalSince1970] * 1000.0);
        // NSTimeInterval is defined as double
        //  NSNumber *timeStampObj = [NSNumber numberWithDouble: timeStamp];
        NSString *intervalString = [NSString stringWithFormat:@"%f", timeStamp];
        
        NSLog(@"intervalString = %@", intervalString);
        dashboardEntity.timeStamp = intervalString;
        
        //        [[DashboardDB sharedInstance]insertDatabase:dashboardEntity];
        
        [dashboardDatabase insertDatabase:dashboardEntity];
        
    }
    
    
}

// delegate method
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished Loading");
    
    /*
     NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
     [DateFormatter setDateFormat:@"yyyy/MM/dd"];
     NSString *currentDate = [[NSString alloc] init];
     currentDate = [DateFormatter stringFromDate:[NSDate date]];
     
     DashboardDatabase* dashboardDatabase = [[DashboardDatabase alloc] init];
     if ([dashboardDatabase fetchByDataDatabase:currentDate] != NULL) {
     NSLog(@"Data is not null..!!");
     
     }  */
    
    
    
    DashboardDatabase* dashboardDatabase = [[DashboardDatabase alloc] init];
    if ([dashboardDatabase fetchByDataDatabase:[self getCurrentDate]] != NULL) {
//    if ([[DashboardDB sharedInstance] fetchByDataDatabase:[self getCurrentDate]] != NULL) {
    
        NSLog(@"Data is not null..!!");
        
    }
    
    
    pageStillLoading = NO;
    
}

@end
