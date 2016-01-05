//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface SchedularViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray *schedularArray;
    IBOutlet UITableView *schedularTable;
    
    FMDatabase *db;
    NSString *defaultDBPath;
    NSString *dbPath;

}

-(IBAction)done:(id)sender;

@end
