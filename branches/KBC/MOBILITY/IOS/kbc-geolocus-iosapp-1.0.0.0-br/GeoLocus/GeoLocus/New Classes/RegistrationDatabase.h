//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "RegistrationEntity.h"

@interface RegistrationDatabase : NSObject

-(NSString*) fetchLastInsuredID;
-(void) createLoginDatabase;
- (void) insertLoginDatabase:(RegistrationEntity *) registrationEntity;
-(RegistrationEntity*) fetchByDeviceIDAndUsername:(NSString *) deviceID:(NSString *) userName;
-(NSString*) fetchLastDeviceID;
-(RegistrationEntity*) fetchDataByDate: (NSString *) currentDate;
-(RegistrationEntity*) fetchDataByUsername: (NSString *) userName;
-(NSString*) fetchTokenByInsuredID: (NSString *) insuredID;
-(NSString*) fetchCountryCodeByDeviceID: (NSString *) deviceID;
-(NSString*) fetchAccountIdByInsuredID :(NSString *)insuredID;
-(NSString*) fetchAccountCodeByInsuredID :(NSString *)insuredID;

@end
