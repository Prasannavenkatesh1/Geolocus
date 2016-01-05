//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@interface CollectionIntervalController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    IBOutlet UITableView *dataTransTable;
    
    NSMutableArray *transIntervaArr;
    NSMutableArray *intervalListArr;
    NSString *pickerValue;
    UIPickerView *intervalPicker;
    
    FMDatabase *db;
    NSString *defaultDBPath;
    NSString *dbPath;

    NSString *collectionInterval;

    NSArray *seconds;
    NSArray *minutes;
    NSArray *hours;
}

@property(nonatomic,strong)UITableView *dataTransTable;
@property(nonatomic,strong)NSString *pickerValue;

-(IBAction)done:(id)sender;

@end
