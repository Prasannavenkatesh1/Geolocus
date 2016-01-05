//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

@interface GetQuoteEntity : NSObject

@property (nonatomic) NSInteger id;

@property (nonatomic, assign) NSString *insuredId;
@property (nonatomic, assign) NSString *finalpremium;
@property (nonatomic, assign) NSString *jobnumber;
@property (nonatomic, assign) NSString *premiumsubtotal;
@property (nonatomic, assign) NSString *taxvalue;
@property (nonatomic, assign) NSString *ubidiscount;
@property (nonatomic, assign) NSString *currentDate;

@property (nonatomic, assign) NSString *amount;
@property (nonatomic, assign) NSString *coveragedesc;

@property (nonatomic, assign) NSString *errorMessage;

@property (nonatomic, assign) NSDictionary *coveragedetails;


@end
