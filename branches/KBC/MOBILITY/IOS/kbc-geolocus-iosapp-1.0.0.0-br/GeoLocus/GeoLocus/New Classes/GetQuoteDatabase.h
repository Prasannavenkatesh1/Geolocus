//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>
#import "GetQuoteEntity.h"

@interface GetQuoteDatabase : NSObject


-(void) createGetQuoteDatabase;

-(void) insertGetQuoteData:(GetQuoteEntity *)getQuoteEntity;

-(GetQuoteEntity*) fetchLastQuoteByInsuredId: (NSString *) insuredId;

-(GetQuoteEntity*) fetchQuoteByCurrentDate: (NSString *) insuredId: (NSString *) date;

-(GetQuoteEntity*) fetchLastQuoteDetails;

@end
