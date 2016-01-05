//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "GetQuoteEntity.h"

@interface GetQuoteController : NSObject


- (BOOL)connected;

//- (NSInteger) distanceConversion:(NSInteger *)distanceInMeters :(NSString *)country;
- (GetQuoteEntity *) getQuoteData:(NSString *)insuredID :(NSString *)resultToken;

- (NSString*) getCurrentDate;

@end
