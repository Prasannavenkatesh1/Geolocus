//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

@interface SettingsEntity : NSObject


@property (nonatomic, strong) NSString *hostname;
@property (nonatomic, strong) NSString *port;
@property (nonatomic, strong) NSString *frequency;
@property (nonatomic, strong) NSString *protocols;
@property (nonatomic, strong) NSString *datauploadtype;
@property (nonatomic, strong) NSString *transmissioninterval;
@property (nonatomic, strong) NSString *collectioninterval;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) NSString *notifydistance;
@property (nonatomic, strong) NSString *notifytime;
@property (nonatomic, strong) NSString *providervalue;

@property (nonatomic, strong) NSString *voiceAlert;


@end
