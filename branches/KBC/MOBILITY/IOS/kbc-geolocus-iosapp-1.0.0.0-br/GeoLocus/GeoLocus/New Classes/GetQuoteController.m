//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "GetQuoteController.h"

#import "GetQuoteDatabase.h"
#import "GetQuoteEntity.h"
#import "Reachability.h"

#import "ServiceConstants.h"

@interface GetQuoteController () {
    
     NSDictionary *dictionary;
    BOOL pageStillLoading;
    NSUInteger errorCodeGetQuote;
 
}

@end

@implementation GetQuoteController


- (NSString*) getCurrentDate {
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy/MM/dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    return currentDate;
}


- (GetQuoteEntity *) getQuoteData:(NSString *)insuredID :(NSString *)resultToken {
    
    
    NSLog(@"inside getQuoteData method of GetQuoteController.");
    
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [self getCurrentDate];
    
    
    NSLog(@"Current Date: %@",currentDate);
    
    GetQuoteEntity *getQuoteEntity = [[GetQuoteEntity alloc] init];
    GetQuoteDatabase* getQuoteDatabase = [[GetQuoteDatabase alloc] init];
    
   
    NSLog(@"getQuoteEntity: %@",getQuoteEntity);
    
    
        if (![self connected]) {
            NSLog(@"Internet is not connected");
            
            getQuoteEntity = [getQuoteDatabase fetchLastQuoteByInsuredId:insuredID];
            return getQuoteEntity;
            // not connected
        }else {
            NSLog(@"Internet is connected");
            
              pageStillLoading = YES;
            
            NSString *urlAsString = [NSString stringWithFormat:GETQUOTEURL,insuredID];
            
            NSLog(@"get quote service url: %@", urlAsString);
            
            NSURL *url = [NSURL URLWithString:urlAsString];
            NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url];
            
            [request setHTTPMethod:@"GET"];
            
            [request setValue:resultToken forHTTPHeaderField:@"SPRING_SECURITY_REMEMBER_ME_COOKIE"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            
            [request setTimeoutInterval:600];
            
            [[NSURLConnection alloc]initWithRequest:request delegate:self startImmediately:YES];
            
            while (pageStillLoading) {
                [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
            
        }
 
    
    if(errorCodeGetQuote == 404) {
        
        getQuoteEntity.errorMessage = @"404 Not Found";
        
        getQuoteEntity.coveragedetails = NULL;
        getQuoteEntity.finalpremium = @"0";
        getQuoteEntity.jobnumber = @"0";
        getQuoteEntity.premiumsubtotal = @"0";
        getQuoteEntity.taxvalue = @"0";
        getQuoteEntity.ubidiscount = @"0";
        
        
    }else if(errorCodeGetQuote == 500) {
        
        getQuoteEntity.errorMessage = @"Server is unavailable.Kinldy retry after sometime";

        getQuoteEntity.coveragedetails = NULL;
        getQuoteEntity.finalpremium = @"0";
        getQuoteEntity.jobnumber = @"0";
        getQuoteEntity.premiumsubtotal = @"0";
        getQuoteEntity.taxvalue = @"0";
        getQuoteEntity.ubidiscount = @"0";

        
    } else if(errorCodeGetQuote == 412) {
        
        getQuoteEntity.errorMessage = @"Precondition failed.";
        
        getQuoteEntity.coveragedetails = NULL;
        getQuoteEntity.finalpremium = @"0";
        getQuoteEntity.jobnumber = @"0";
        getQuoteEntity.premiumsubtotal = @"0";
        getQuoteEntity.taxvalue = @"0";
        getQuoteEntity.ubidiscount = @"0";

        
    } else {
        
        if ([getQuoteDatabase fetchQuoteByCurrentDate:insuredID: currentDate] != NULL) {
            getQuoteEntity = [getQuoteDatabase fetchQuoteByCurrentDate:insuredID: currentDate];
            NSLog(@"Data is not null..!!");
            
        }else {
            
            getQuoteEntity = [getQuoteDatabase fetchLastQuoteDetails];
        }

        
    }

    
    return getQuoteEntity;
    
}



- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
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
    NSLog(@"inside didReceiveResponse");
    
    NSLog(@"inside didReceiveResponse response= %@",response);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    
    errorCodeGetQuote = [httpResponse statusCode];
    
}


- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"inside didFailWithError = %@",error);
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    NSError *e;
    dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&e];
//    NSLog(@"dictionary = %@", dictionary);
    
    GetQuoteDatabase* getQuoteDatabase = [[GetQuoteDatabase alloc] init];
    GetQuoteEntity *getQuoteEntity = [[GetQuoteEntity alloc] init];
    
    getQuoteEntity.currentDate = [self getCurrentDate];
    
    
    if(errorCodeGetQuote == 200) {
        
        
        if ([dictionary count] != 0) {
            
            getQuoteEntity.coveragedetails = [dictionary objectForKey:@"coveragedetails"];
            getQuoteEntity.finalpremium = [dictionary objectForKey:@"finalpremium"];
            getQuoteEntity.jobnumber = [dictionary objectForKey:@"jobnumber"];
            getQuoteEntity.premiumsubtotal = [dictionary objectForKey:@"premiumsubtotal"];
            getQuoteEntity.taxvalue = [dictionary objectForKey:@"taxvalue"];
            getQuoteEntity.ubidiscount = [dictionary objectForKey:@"ubidiscount"];
            
            
            
        } else {
            
            getQuoteEntity.coveragedetails = NULL;
            
            getQuoteEntity.finalpremium = @"0";
            getQuoteEntity.jobnumber = @"0";
            getQuoteEntity.premiumsubtotal = @"0";
            getQuoteEntity.taxvalue = @"0";
            getQuoteEntity.ubidiscount = @"0";
            
        }
        
        [getQuoteDatabase insertGetQuoteData:getQuoteEntity];
        
        
        
        
    }
    
    
}

// delegate method
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Finished Loading");
    
    GetQuoteDatabase* getQuoteDatabase = [[GetQuoteDatabase alloc] init];
    if ([getQuoteDatabase fetchLastQuoteDetails] != NULL) {
       
        NSLog(@"Data is not null..!!");
        
    }
    
    pageStillLoading = NO;
    
}



@end
