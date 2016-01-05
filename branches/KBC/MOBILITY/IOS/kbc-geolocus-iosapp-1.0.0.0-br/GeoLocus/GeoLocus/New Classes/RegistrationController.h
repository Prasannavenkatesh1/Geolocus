//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "RegistrationEntity.h"


@interface RegistrationController : NSObject


- (BOOL)connected;

-(NSDictionary*) validateUser :(RegistrationEntity *)registrationEntity;

-(RegistrationEntity*) userLogin :(NSString *)userName :(NSString *)password;


@end
