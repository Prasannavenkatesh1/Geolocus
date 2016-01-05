//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "LeaderBoardController.h"
#import "LeaderBoardEntity.h"
#import "LeaderBoardDatabase.h"
#import "Reachability.h"

#import "ServiceConstants.h"

@interface LeaderBoardController () {
    
    NSDictionary *leaderBoardData;
    NSDictionary *rankDetailsDictionary;
    NSDictionary *dictInsuredID;
    
    NSArray *leaderBoardHistoryResult;
    NSArray *leaderBoardTopperResult;
    
    NSMutableArray *resultantleaderboardArray;
    
    BOOL flag;
    BOOL pageStillLoading;
    
    BOOL currentData;
    
    NSMutableData *passData;
    
}

@end


@implementation LeaderBoardController

@synthesize lbData;


//-(NSMutableDictionary*) getLeaderBoardData:(NSString *) insuredID:(NSString *) resultToken :(NSString *)counterName {


-(NSMutableDictionary*) getLeaderBoardData:(NSString *) insuredID:(NSString *) resultToken :(NSString *)counterName:(NSString *)accountId {
    
    NSLog(@"inside getLeaderBoardData method of LeaderBoardController.");
    
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Date: %@",currentDate);
    
    LeaderBoardDatabase* leaderBoardDatabase = [[LeaderBoardDatabase alloc] init];
    
    leaderBoardTopperResult = [leaderBoardDatabase fetchLeaderBoardLastData:currentDate];
    
    //leaderBoardHistoryResult = [leaderBoardDatabase fetchLeaderBoardHistoryLastData:currentDate: counterName];
    
    
    //NSLog(@"leaderBoardTopperResult in controller = %@", leaderBoardTopperResult);
    //NSLog(@"leaderBoardHistoryResult in controller = %@", leaderBoardHistoryResult);
    
    
    if (([self getCurrentMonth:leaderBoardHistoryResult] == NO) || ([self getCurrentMonth:leaderBoardTopperResult] == NO))  {
        
        if (![self connected]) {
            NSLog(@"Internet is not connected");
            // not connected
        }else {
            NSLog(@"Internet is connected");
            
            pageStillLoading = YES;
            flag = NO;
            
            
            //                NSString *leaderBoardURL = [NSString stringWithFormat:@"https://54.193.31.22/sei/report/leaderboard/relative/getrankhistory?count=5&accountId=1&insuredId=%@&type=IN",insuredID];
            
            NSString *leaderBoardURL = [NSString stringWithFormat:LEADERBOARDHISTORYURL,accountId,insuredID,counterName];
            
            NSLog(@"leaderBoard service URL: %@",leaderBoardURL);
            
            
            NSURL *url = [NSURL URLWithString:leaderBoardURL];
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
            [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request setHTTPMethod:@"GET"];
            [request setValue:resultToken forHTTPHeaderField:@"SPRING_SECURITY_REMEMBER_ME_COOKIE"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            
            [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
            
            
            while (pageStillLoading) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            NSLog(@"Data is not null..!!");
            
            
            pageStillLoading = YES;
            flag = YES;
            
            
            //                NSString *leaderBoardToppersURL = [NSString stringWithFormat:@"https://54.193.31.22/sei/report/leaderboard/toppers?count=4&accountId=1&insuredId=%@&type=IN", insuredID];
            
            NSString *leaderBoardToppersURL = [NSString stringWithFormat:LEADERBOARDTOPPERSURL, accountId, insuredID,counterName];
            
            //NSLog(@"leaderBoardTopper service URL: %@",leaderBoardToppersURL);
            
            NSURL *urlTopper = [NSURL URLWithString:leaderBoardToppersURL];
            NSMutableURLRequest * requestTopper = [NSMutableURLRequest requestWithURL:urlTopper];
            [requestTopper addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [requestTopper setHTTPMethod:@"GET"];
            [requestTopper setValue:resultToken forHTTPHeaderField:@"SPRING_SECURITY_REMEMBER_ME_COOKIE"];
            [requestTopper setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            
            [[NSURLConnection alloc]initWithRequest:requestTopper delegate:self startImmediately:YES];
            
            while (pageStillLoading) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            NSLog(@"Data is not null in topper's url..!!");
            
        }
    }
    
    
    leaderBoardTopperResult = [leaderBoardDatabase fetchLeaderBoardLastData:currentDate];
    leaderBoardHistoryResult = [leaderBoardDatabase fetchLeaderBoardHistoryLastData:currentDate: counterName];
    
    
    //NSLog(@"leaderBoardHistoryResult: %@", leaderBoardHistoryResult);
    
    NSMutableDictionary *leaderBoardResult = [[NSMutableDictionary alloc] init];
    [leaderBoardResult setValue:leaderBoardTopperResult forKey:@"topperData"];
    [leaderBoardResult setValue:leaderBoardHistoryResult forKey:@"historyData"];
    
    //NSLog(@"dictionary leaderBoardResult= %@", leaderBoardResult);
    
    return leaderBoardResult;
    
    
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




-(BOOL) getCurrentMonth:(NSArray *)leaderBoardArray {
    
    currentData = NO;
    // NSLog(@"initial value of history array = %@",[leaderBoardArray firstObject]);
    
    NSDictionary *leaderBoardDetails = [leaderBoardArray firstObject];
    
    //NSLog(@"initial value of history array = %@",leaderBoardDetails);
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Date: %@",currentDate);
    
    NSString *currentDateValue = [currentDate substringWithRange:NSMakeRange(0,7)];
    NSLog(@"value of current date value in getCurrentMonth is= %@",currentDateValue);
    
    if (leaderBoardDetails == (NSDictionary*) [NSNull null]) {
        
        currentData = NO;
    } else {
        
        NSString *databaseCurrentDate = [leaderBoardDetails valueForKeyPath:@"currentDate"];
        
        NSString *databaseCurrentValue = [databaseCurrentDate substringWithRange:NSMakeRange(0,7)];
        NSLog(@"value of databaseCurrentValue in getCurrentMonth is= %@",databaseCurrentValue);
        
        if ([currentDateValue caseInsensitiveCompare:databaseCurrentValue] == NSOrderedSame) {
            currentData = YES;
        } else {
            
            currentData = NO;
        }
        
    }
    
    
    return currentData;
    
    
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


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [passData appendData:data];
    
    NSLog(@"connection didReceiveData");
    
    
    NSError *e;
    
    
    LeaderBoardEntity *leaderBoardEntity = [[LeaderBoardEntity alloc] init];
    LeaderBoardDatabase* leaderBoardDatabase = [[LeaderBoardDatabase alloc] init];
    
    
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Date: %@",currentDate);
    
    
    if (flag == NO) {
        
        leaderBoardData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&e];
//        NSLog(@"dictionary = %@", leaderBoardData);
        rankDetailsDictionary = [leaderBoardData valueForKeyPath:@"rankDetails"];
//        NSLog(@"rankDetails = %@",rankDetailsDictionary);
        
        
        NSInteger sizeOfHistoryData = [rankDetailsDictionary count];
//        NSLog(@"size of rankDetails = %d",sizeOfHistoryData);
        
        NSArray *processDate = [rankDetailsDictionary valueForKeyPath:@"processDate"];
        NSArray *totalDistanceCovered = [rankDetailsDictionary valueForKeyPath:@"totalDistanceCovered"];
        NSArray *currentRank = [rankDetailsDictionary valueForKeyPath:@"currentRank"];
        
        for (int i=0; i<4; i++){
            
            if(i<sizeOfHistoryData) {
                
                leaderBoardEntity.processdate = [processDate objectAtIndex:i];
                leaderBoardEntity.distanceDriven = [totalDistanceCovered objectAtIndex:i];
                leaderBoardEntity.currentRank = [currentRank objectAtIndex:i];
                leaderBoardEntity.currentDate = currentDate;
                
                [leaderBoardDatabase insertLeaderBoardHistoryDatabase:leaderBoardEntity];
                
            }
            
        }
        
        pageStillLoading = NO;
        
    } else if (flag == YES) {
        
        leaderBoardData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&e];
//        NSLog(@"dictionary = %@", leaderBoardData);
        rankDetailsDictionary = [leaderBoardData valueForKeyPath:@"rankDetails"];
//        NSLog(@"rankDetails = %@",rankDetailsDictionary);
        
        NSArray *rankingIdData = [rankDetailsDictionary valueForKeyPath:@"rankingId"];
        NSArray *insuredIdData = [rankDetailsDictionary valueForKeyPath:@"insuredId"];
        NSArray *previousRankData = [rankDetailsDictionary valueForKeyPath:@"previousRank"];
        NSArray *currentRankData = [rankDetailsDictionary valueForKeyPath:@"currentRank"];
        NSArray *driverScoreData = [rankDetailsDictionary valueForKeyPath:@"driverScore"];
        NSArray *locationData = [rankDetailsDictionary valueForKeyPath:@"locationName"];
        
        NSInteger sizeOfData = [rankDetailsDictionary count];
        NSLog(@"size of rankDetails = %d",sizeOfData);
        
        for (int i = 0; i<sizeOfData; i++) {
            
            leaderBoardEntity.rankingId = [rankingIdData objectAtIndex:i];
            leaderBoardEntity.insuredId = [insuredIdData objectAtIndex:i];
            leaderBoardEntity.previousRank = [previousRankData objectAtIndex:i];
            leaderBoardEntity.currentRank = [currentRankData objectAtIndex:i];
            leaderBoardEntity.driverScore = [driverScoreData objectAtIndex:i];
            leaderBoardEntity.location = [locationData objectAtIndex:i];
            leaderBoardEntity.currentDate = currentDate;
            
            [leaderBoardDatabase insertLeaderBoardDatabase:leaderBoardEntity];
            
        }
        
        leaderBoardTopperResult = [leaderBoardDatabase fetchLeaderBoardLastData:currentDate];
        
        pageStillLoading = NO;
    }
    
}


- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}




-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    passData = [[NSMutableData alloc] init];
    
    NSLog(@"inside didReceiveResponse");
    
    NSLog(@"inside didReceiveResponse response= %@",response);
    
    // NSLog(@"The HTTP parsed body is %@", [response body]);
    
    //    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    //    NSDictionary *fields = [HTTPResponse allHeaderFields];
    //    NSString *cookie = [fields valueForKey:@"Set-Cookie"];
    //
    
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"inside didFailWithError = %@",error);
	//label.text = [NSString stringWithFormat:@"Connection failed: %@", [error description]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished Loading");
    pageStillLoading = NO;
    NSError *error;
    
    NSLog(@"currentRequest = %@", connection.currentRequest.URL.absoluteString);

    lbData = [NSJSONSerialization JSONObjectWithData:passData options:NSJSONReadingMutableLeaves error:&error];
//    NSLog(@"responseValue = %@", lbData);

    
}



@end
