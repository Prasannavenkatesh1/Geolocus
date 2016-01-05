//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "RegistrationController.h"
#import "RegistrationDatabase.h"
#import "Reachability.h"

#import "ServiceConstants.h"

@interface RegistrationController () {
    
    NSString *username;
    NSString *deviceNo;
    NSString *passwordNew;
    NSString *key;
    
    
    NSString *firstName;
    NSString *lastName;
    NSString *displayName;
    NSString *countryName;
    NSString *phoneNumber;
    NSString *gender;
    NSString *isAgree;
    
    
    NSString *token;
    
    NSDictionary *dictionary;
    NSDictionary *dictNew;
    
    
    BOOL pageStillLoading;
    BOOL registrationFlag;
    bool policyStatus;
    
    NSString *errorMessage;
    NSString *registrationStatus;
    
    NSUInteger errorCode;
    
    NSMutableData *_downloadedData;
    
    
    NSDictionary *registrationResult;
    
}

@end




@implementation RegistrationController


-(NSDictionary*) validateUser :(RegistrationEntity *)registrationEntity
{
    username = registrationEntity.userName;
    passwordNew = registrationEntity.password;
    firstName = registrationEntity.firstName;
    lastName = registrationEntity.lastName;
    displayName = registrationEntity.displayName;
    countryName = registrationEntity.countryName;
    phoneNumber = registrationEntity.phoneNumber;
    gender = registrationEntity.gender;
    isAgree = registrationEntity.isAgree;
    
    registrationStatus = @"false";
    
    key = registrationEntity.key;
    
    RegistrationDatabase* registrationDatabase = [[RegistrationDatabase alloc] init];
    RegistrationEntity *registrationEntityNew = [[RegistrationEntity alloc] init];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Date: %@",currentDate);
    
    if ([registrationDatabase fetchDataByDate:currentDate] != NULL) {
        
        registrationStatus = @"true";
       // return YES;
        
    } else {
        
        if (![self connected]) {
            NSLog(@"Internet is not connected");
            // not connected
        }else {
            NSLog(@"Internet is connected");
            
            if ([registrationEntity.key isEqualToString:@"RegisterMobileUrl"]) {
                
                registrationFlag = YES;
                
                return [self userRegistration: username: firstName: lastName: displayName: countryName: phoneNumber: gender: isAgree];
                
                
                
            } else if ([registrationEntity.key isEqualToString:@"LoginMobileUrl"]) {
                
                
                registrationFlag = NO;
                
                registrationEntityNew = [self userLogin: username: passwordNew];
                
                if ([registrationDatabase fetchDataByDate:currentDate] != NULL) {
                    
                    registrationEntityNew = [registrationDatabase fetchDataByUsername:username];
                    
                    if ((registrationEntityNew.insuredID != NULL) && ([registrationEntityNew.insuredID intValue] != 0) && ([currentDate caseInsensitiveCompare:registrationEntityNew.currentDate] == NSOrderedSame)) {
                        //  return YES;
                        
                        registrationStatus = @"true";
                        
                    }
                }
                
                
            }
            
            
        }
    }
    
    
    registrationResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",registrationStatus],@"registrationStatus",[NSString stringWithFormat:@"%@",errorMessage],@"errorMessage", nil];
    
    
    return registrationResult;
    
}

- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}



-(RegistrationEntity*) userLogin :(NSString *)userName :(NSString *)password
{
    
    NSLog(@"inside userLogin method of RegistrationController.");
    
    RegistrationEntity *registrationEntity = [[RegistrationEntity alloc] init];
    
    RegistrationDatabase* registrationDatabase = [[RegistrationDatabase alloc] init];
    
    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate = [[NSString alloc] init];
    currentDate = [DateFormatter stringFromDate:[NSDate date]];
    
    NSLog(@"Current Date: %@",currentDate);
    
    if ([registrationDatabase fetchDataByUsername:username] == NULL) {
        
        
        NSString *jsonRequest = [NSString stringWithFormat:@"j_password=%@&j_username=%@&_spring_security_remember_me=on",password, userName];
        
        NSLog(@"login service URL: %@", jsonRequest);
        
        //        NSURL *url = [NSURL URLWithString:@"https://54.193.31.22/sei/j_spring_security_check"];
        
        
        NSURL *url = [NSURL URLWithString:LOGINURL];
        
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
        
        
        [request setHTTPMethod:@"POST"];
        
        [request setValue:@"SPRING_SECURITY_REMEMBER_ME_COOKIE" forHTTPHeaderField:@"Set-Cookie"];
        
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection connectionWithRequest:request delegate:self];
        
        pageStillLoading = NO;
        
        
        while (!pageStillLoading) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        
        NSLog(@"error message after login service call is: %@", errorMessage);
        
        if ([registrationDatabase fetchDataByDate:currentDate] != NULL) {
            
            registrationEntity = [registrationDatabase fetchDataByUsername:username];
            
            if ((registrationEntity.insuredID != NULL) && ([registrationEntity.insuredID intValue] != 0) && ([currentDate caseInsensitiveCompare:registrationEntity.currentDate] == NSOrderedSame)) {
                
                return registrationEntity;
                
            }
        }
        
        
    }
    
    return registrationEntity;
    
    
}



-(NSDictionary*) userRegistration :(NSString *)username :(NSString *)firstName :(NSString *)lastName :(NSString *)displayName :(NSString *)countryName :(NSString *)phoneNumber :(NSString *)gender :(NSString *)isAgree
{
    
    
    NSLog(@"inside userRegistration method of RegistrationController.");
    
    /*
     username = @"";
     firstName = @"";
     lastName = @"";
     displayName= @"";
     countryName= @"";
     phoneNumber= @"";
     gender= @"";  */
    
    
    policyStatus = false;
    
    NSLog(@"The STRING value of policyStatus is %@", (policyStatus ? @"true" : @"false"));
    
    BOOL agreeStatus = [isAgree boolValue];
    
    NSLog(@"The STRING value of policyStatus is %@", (agreeStatus ? @"true" : @"false"));
    
    
    NSString *jsonRequest = [NSString stringWithFormat:@"{\"userName\":\"%@\",\"firstName\":\"%@\",\"lastName\":\"%@\",\"displayName\":\"%@\",\"countryCode\":\"%@\",\"primaryPhone\":\"%@\",\"gender\":\"%@\",\"isAgree\":%@,\"deviceType\":\"%@\",\"hasPolicy\":%@}",username, firstName, lastName, displayName, countryName, phoneNumber, gender, (agreeStatus ? @"true" : @"false"),  @"mobile", (policyStatus ? @"true" : @"false")];
    
    
    
    
    
    NSLog(@"Registration service URL: %@", jsonRequest);
    
    //    NSURL *url = [NSURL URLWithString:@"https://54.193.31.22/sei/proc/user/register"];
    
    
    NSURL *url = [NSURL URLWithString:REGISTRATIONURL];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setTimeoutInterval:120];
    
    [request setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: requestData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    pageStillLoading = NO;
    
    
    while (!pageStillLoading) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        
    }
    
    
    
    NSLog(@"error message after registartion service call is: %@", _downloadedData);
    
    
    NSError *e;
    dictionary = [NSJSONSerialization JSONObjectWithData:_downloadedData options:NSJSONReadingMutableLeaves error:&e];
//    NSLog(@"error message in dictionary = %@", dictionary[@"details"]);
    
    //  NSLog(@"Error message in class method = %@", errorMessage);
    
    
    
    
    //  NSLog(@"errorCode in class method = %d", errorCode);
    
    
    
    if(errorCode == 404) {
        
        errorMessage = @"404 Not Found";
        
        
    }else if(errorCode == 500) {
        
        errorMessage = @"Server is unavailable.Kinldy retry after sometime";
        
        
    } else if(errorCode == 412) {
        
        errorMessage = dictionary[@"details"];
        
    }
    
    
    
    //errorMessage = dictionary[@"details"];
    
    registrationStatus = (pageStillLoading ? @"true" : @"false");
    
    NSLog(@"Error message in class method = %@", errorMessage);
    NSLog(@"registrationStatus in class method = %@", registrationStatus);
    
    
    
    
    
    registrationResult = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@",registrationStatus],@"registrationStatus",[NSString stringWithFormat:@"%@",errorMessage],@"errorMessage", nil];
    
    NSLog(@"registrationResult in class method = %@", registrationResult);
    
    
    
    
    return registrationResult;
    
}


- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    
    NSString *serviceUsername = @"Geolocusincidents";
    NSString *servicePassword = @"G111111#";
    
    NSURLCredential *credential = [NSURLCredential credentialWithUser:serviceUsername
                                                             password:servicePassword
                                                          persistence:NSURLCredentialPersistenceForSession];
    [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
    
}



- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    
    NSLog(@"connection didReceiveData");
    
    
    NSError *e;
    dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&e];
//    NSLog(@"dictionary = %@", dictionary);
    
    
    NSLog(@"errorCode = %d", errorCode);
    
    
    [_downloadedData appendData:data];
    
    
    if (registrationFlag == NO) {
        
        //        NSError *e;
        //        dictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&e];
        //        NSLog(@"dictionary = %@", dictionary);
        
        RegistrationEntity *registrationEntity = [[RegistrationEntity alloc] init];
        
        
        registrationEntity.accountID = dictionary[@"accountId"];
        registrationEntity.isActive = dictionary[@"active"];
        registrationEntity.agreementNumber = dictionary[@"agreementNo"];
        registrationEntity.countryCode = dictionary[@"countryCode"];
        registrationEntity.isDeleted = dictionary[@"deleted"];
        registrationEntity.deviceID = dictionary[@"deviceNumber"];
        registrationEntity.endDate = dictionary[@"endDate"];
        registrationEntity.insuredID = dictionary[@"insuredId"];
        registrationEntity.insuredType = dictionary[@"insuredType"];
        registrationEntity.issueDate = dictionary[@"issueDate"];
        registrationEntity.languageCode = dictionary[@"languageCode"];
        registrationEntity.phoneNumber = dictionary[@"phone"];
        registrationEntity.profileName = dictionary[@"profileName"];
        registrationEntity.uomCategoryID = dictionary[@"uomCategoryId"];
        registrationEntity.userID = dictionary[@"userId"];
        registrationEntity.userName = dictionary[@"userName"];
        registrationEntity.password = passwordNew;
        
        registrationEntity.serviceToken = token;
        
        registrationEntity.accountCode = dictionary[@"accountCd"];
        
        RegistrationDatabase* registrationDatabase = [[RegistrationDatabase alloc] init];
        [registrationDatabase insertLoginDatabase:registrationEntity];
        
    }
    
}



- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"inside didReceiveResponse");
    
    NSLog(@"inside didReceiveResponse response= %@",response);
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
    if ([response respondsToSelector:@selector(allHeaderFields)]) {
        NSDictionary *dictionaryResponse = [httpResponse allHeaderFields];
        
        
        NSLog(@"dictionary[SPRING_SECURITY_REMEMBER_ME_COOKIE] = %@", dictionaryResponse[@"SPRING_SECURITY_REMEMBER_ME_COOKIE"]);
        
        
        token = dictionaryResponse[@"SPRING_SECURITY_REMEMBER_ME_COOKIE"];
        
        
        NSLog(@"dictionary[details] = %@", dictionaryResponse[@"details"]);
        
        
        // NSLog(dictionaryResponse[@"details"]);
    }
    
    
    
    errorCode = [httpResponse statusCode];
    
    _downloadedData = [[NSMutableData alloc] init];
    
    pageStillLoading = YES;
    
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    NSLog(@"inside didFailWithError = %@",error);
	
}


@end
