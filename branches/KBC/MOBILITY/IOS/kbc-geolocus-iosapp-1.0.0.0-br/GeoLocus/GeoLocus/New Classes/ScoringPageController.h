//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "ScoringEntity.h"

@interface ScoringPageController : NSObject

- (BOOL)connected;

//-(ScoringEntity*) getweeklyScoringData: (NSString *) insuredID;

-(ScoringEntity*) getweeklyScoringData: (NSString *) insuredID: (NSString *) resultToken: (NSString *) accountId: (NSString *) accountCode;

@end
