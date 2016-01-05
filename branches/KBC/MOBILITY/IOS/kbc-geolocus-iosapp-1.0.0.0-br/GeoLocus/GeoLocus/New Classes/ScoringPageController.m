//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "ScoringPageController.h"
#import "Reachability.h"
#import "ScoringEntity.h"
#import "ScoringPageDatabase.h"

#import "ServiceConstants.h"


@interface ScoringPageController () {
    
    NSDictionary *weeklyData;
    NSDictionary *dictNew;
    
    NSDictionary *dictInsuredID;
    
}

@end


@implementation ScoringPageController


-(ScoringEntity*) getweeklyScoringData:(NSString *) insuredID:(NSString *) resultToken:(NSString *) accountId:(NSString *) accountCode {
    
    
    NSLog(@"inside getweeklyScoringData method of ScoringPageController.");
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    NSLog(@"Current Date: %@",currentDate);
    
    NSDateComponents *currentDateComponents = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear | kCFCalendarUnitWeek | kCFCalendarUnitWeekOfMonth fromDate:[NSDate date]];
    // NSInteger currentDateDay = [currentDateComponents day];
    NSInteger currentDateMonth = [currentDateComponents month];
    NSInteger currentDateYear = [currentDateComponents year];
    NSInteger currentDateWeek = [currentDateComponents weekOfMonth];
    NSDate *databaseDate;
    
    
    ScoringEntity *scoringEntity = [[ScoringEntity alloc] init];
    ScoringPageDatabase* scoringPageDatabase = [[ScoringPageDatabase alloc] init];
    
    
    ScoringEntity *oldScoringEntity = [[ScoringEntity alloc] init];
    BOOL weeklyData = NO;
    oldScoringEntity = [scoringPageDatabase fetchLastWeeklyData];
    
    if (oldScoringEntity != NULL) {
        
        NSLog(@"Date from scoring page database: %@", oldScoringEntity.currentDate);
        databaseDate = [DateFormatter dateFromString:oldScoringEntity.currentDate];
        NSDateComponents *databaseDateComponents = [[NSCalendar currentCalendar] components:kCFCalendarUnitDay | kCFCalendarUnitMonth | kCFCalendarUnitYear | kCFCalendarUnitWeek | kCFCalendarUnitWeekOfMonth fromDate:databaseDate];
        // NSInteger databaseDateDay = [databaseDateComponents day];
        NSInteger databaseDateMonth = [databaseDateComponents month];
        NSInteger databaseDateYear = [databaseDateComponents year];
        NSInteger databaseDateWeek = [databaseDateComponents weekOfMonth];
        
        
        if (currentDateYear >= databaseDateYear) {
            if (currentDateMonth >= databaseDateMonth) {
                if ((currentDateWeek > databaseDateWeek) || (currentDateWeek < databaseDateWeek)) {
                    
                    weeklyData = YES;
                }
                
            }
            
        } else {
            weeklyData = YES;
        }
        
        
        
        
    } else {
        weeklyData = YES;
    }
    
    if (weeklyData == YES) {
        
        if (![self connected]) {
            NSLog(@"Internet is not connected");
            // not connected
        }else {
            NSLog(@"Internet is connected");
            
            
            //            NSString *urlAsString = [NSString stringWithFormat:@"https://54.193.31.22/sei/report/aggr/weekly?insuredID=%@",insuredID];
            
            NSMutableArray *prevMonths = [[NSMutableArray alloc] init];
            NSInteger monthCounter = 0;
            
            if (currentDateMonth > 6) {
                
                monthCounter = currentDateMonth - 6;
                
                for (monthCounter; monthCounter<currentDateMonth; monthCounter++) {
                    
                    [prevMonths addObject:[NSNumber numberWithInt:monthCounter]];
                    
                }
                
            } else {
                
                monthCounter = 0;
                
                for (monthCounter; monthCounter<currentDateMonth; monthCounter++) {
                    
                    if (monthCounter<currentDateMonth) {
                        
                        [prevMonths addObject:[NSNumber numberWithInt:monthCounter]];
                        
                    } else {
                        [prevMonths addObject:@"0"];
                    }
                }
            }
            
            NSString * result = [prevMonths componentsJoinedByString:@""];
            
            [[result stringByReplacingOccurrencesOfString:@"(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
            
            NSString *valOfPrevMonths = [prevMonths objectAtIndex:0];
            
            if (valOfPrevMonths > 0) {
                result = [prevMonths componentsJoinedByString:@","];
            }

            
            NSString *yearValue = [NSString stringWithFormat:@"%ld", (long)currentDateYear];
            
            NSString *urlAsString = [NSString stringWithFormat:WEEKLYURL,insuredID, accountId, yearValue, result];
            //NSString *urlAsString = [NSString stringWithFormat:WEEKLYURL,insuredID, accountId, yearValue, test];
            
            NSLog(@"Weekly service URL: %@",urlAsString);
            
            NSURL *url = [NSURL URLWithString:urlAsString];
            
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
            
            [request setHTTPMethod:@"GET"];
            
            [request setValue:resultToken forHTTPHeaderField:@"SPRING_SECURITY_REMEMBER_ME_COOKIE"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:accountCode forHTTPHeaderField:@"accountCode"];
            
            [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
            
            
            
            
            
            /*  NSURL *url = [NSURL URLWithString:urlAsString];
             NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
             [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
             [request setHTTPMethod:@"GET"];
             NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
             
             */
            
            
            while ([[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]) {
                
                if ([scoringPageDatabase fetchByDataDatabase:currentDate] != NULL) {
                    scoringEntity = [scoringPageDatabase fetchByDataDatabase:currentDate];
                    NSLog(@"Data is not null..!!");
                    return scoringEntity;
                }
                
            }
            
            
        }
        
    } else {
        
        scoringEntity = [scoringPageDatabase fetchLastWeeklyData];
        
    }
    
    return scoringEntity;
    
    
    
}



- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    NSString *username = @"Geolocusincidents";
    NSString *password = @"G111111#";
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:username
                                                             password:password
                                                          persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"inside didReceiveResponse");
    
    NSLog(@"inside didReceiveResponse response= %@",response);
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSLog(@"connection didReceiveData");
    
    NSError *e;
    weeklyData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&e];
//    NSLog(@"dictionary = %@", weeklyData);
    
    ScoringEntity *scoringEntity = [[ScoringEntity alloc] init];
    ScoringPageDatabase* scoringPageDatabase = [[ScoringPageDatabase alloc] init];
    
    
    if ([weeklyData objectForKey:@"insuredAggregates"] != [NSNull null]) {
        
        dictNew = [weeklyData valueForKeyPath:@"insuredAggregates"];
        NSLog(@"periodicAggrs = %@",dictNew);
        dictInsuredID = [dictNew valueForKeyPath:@"periodicAggrs"][0];
        NSLog(@"dictInsuredID = %@",dictInsuredID);
        
        NSInteger sizeOfWeeklyData = [dictInsuredID count];
        NSLog(@"size of periodicAggrs = %d",sizeOfWeeklyData);
        
        
        NSMutableArray *accelerationArray = [[NSMutableArray alloc] init];
        NSMutableArray *brakingArray = [[NSMutableArray alloc] init];
        NSMutableArray *corneringArray = [[NSMutableArray alloc] init];
        NSMutableArray *speedingArray = [[NSMutableArray alloc] init];
        NSMutableArray *timeOfDayArray = [[NSMutableArray alloc] init];
        
        
        NSArray *acceleration = [dictInsuredID valueForKeyPath:@"acceleration"];
        NSArray *braking = [dictInsuredID valueForKeyPath:@"braking"];
        NSArray *cornering = [dictInsuredID valueForKeyPath:@"cornering"];
        NSArray *speeding = [dictInsuredID valueForKeyPath:@"speeding"];
        NSArray *timeOfDay = [dictInsuredID valueForKeyPath:@"timeOfDay"];
        
        
        NSInteger loopCounter = 0;
        
        if (sizeOfWeeklyData > 8) {
            loopCounter = sizeOfWeeklyData - 8;
            
            for (loopCounter; loopCounter<sizeOfWeeklyData; loopCounter++) {
                
                [accelerationArray addObject:[acceleration objectAtIndex:loopCounter]];
                [brakingArray addObject:[braking objectAtIndex:loopCounter]];
                [corneringArray addObject:[cornering objectAtIndex:loopCounter]];
                [speedingArray addObject:[speeding objectAtIndex:loopCounter]];
                [timeOfDayArray addObject:[timeOfDay objectAtIndex:loopCounter]];
                
                
                
            }
            
        } else {
            loopCounter = 0;
            
            
            for (loopCounter; loopCounter<8; loopCounter++) {
                if (loopCounter<sizeOfWeeklyData) {
                    
                    [accelerationArray addObject:[acceleration objectAtIndex:loopCounter]];
                    [brakingArray addObject:[braking objectAtIndex:loopCounter]];
                    [corneringArray addObject:[cornering objectAtIndex:loopCounter]];
                    [speedingArray addObject:[speeding objectAtIndex:loopCounter]];
                    [timeOfDayArray addObject:[timeOfDay objectAtIndex:loopCounter]];
                    
                } else {
                    [accelerationArray addObject:@"0"];
                    [brakingArray addObject:@"0"];
                    [corneringArray addObject:@"0"];
                    [speedingArray addObject:@"0"];
                    [timeOfDayArray addObject:@"0"];
                }
                
                
            }
            
        }
        
        
        scoringEntity.weeklyAcceleration = accelerationArray;
        scoringEntity.weeklyBraking = brakingArray;
        scoringEntity.weeklyCornering = corneringArray;
        scoringEntity.weeklySpeeding = speedingArray;
        scoringEntity.weeklyTimeOfDay = timeOfDayArray;
        
    }
    
    [scoringPageDatabase insertDatabase:scoringEntity];
    
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



@end
