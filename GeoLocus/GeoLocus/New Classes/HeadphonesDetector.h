//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <Foundation/Foundation.h>

@protocol HeadphonesDetectorDelegate;

@interface HeadphonesDetector : NSObject {
	id<HeadphonesDetectorDelegate> delegate;	
}

@property (nonatomic, strong) id<HeadphonesDetectorDelegate> delegate;
@property (nonatomic, readonly) BOOL headphonesArePlugged;

+ (HeadphonesDetector *) sharedDetector;

@end


@protocol HeadphonesDetectorDelegate <NSObject>

- (void) headphonesDetectorStateChanged: (HeadphonesDetector *) headphonesDetector;

@end