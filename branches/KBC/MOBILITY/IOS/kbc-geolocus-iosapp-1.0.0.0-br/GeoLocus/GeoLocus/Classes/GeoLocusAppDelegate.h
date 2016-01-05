//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <UIKit/UIKit.h>
#import "CoreLocationController.h"

@class GeoLocusViewController;

@interface GeoLocusAppDelegate : UIResponder <UIApplicationDelegate>
{
    UIWindow *window;
    GeoLocusViewController *viewController;
}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet GeoLocusViewController *viewController;

@end
