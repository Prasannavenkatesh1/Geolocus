//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

@interface RegistrationEntity : NSObject

@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *insuredID;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *key;



@property (nonatomic, strong) NSString *firstName;
@property (nonatomic, strong) NSString *lastName;
@property (nonatomic, strong) NSString *displayName;
@property (nonatomic, strong) NSString *countryName;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *isAgree;



@property (nonatomic, strong) NSString *accountID;
@property (nonatomic, strong) NSString *isActive;
@property (nonatomic, strong) NSString *agreementNumber;
@property (nonatomic, strong) NSString *countryCode;
@property (nonatomic, strong) NSString *isDeleted;
@property (nonatomic, strong) NSString *endDate;
@property (nonatomic, strong) NSString *insuredType;
@property (nonatomic, strong) NSString *issueDate;
@property (nonatomic, strong) NSString *languageCode;
//@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *profileName;
@property (nonatomic, strong) NSString *uomCategoryID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, strong) NSString *currentDate;


@property (nonatomic, strong) NSString *serviceToken;

@property (nonatomic, strong) NSString *accountCode;


@end
