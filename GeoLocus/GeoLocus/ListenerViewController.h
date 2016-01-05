//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@class MLTableAlert;

@interface ListenerViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
    IBOutlet UITableView *listenerTable;
    
    NSMutableArray *listenerArray;
    NSArray *providerListArray;
    NSString *providerSelectedVal;
    NSMutableArray *listenerValueArray;
    
    UIPickerView *intervalPicker;
    NSMutableArray *intervalListArr;
    NSString *pickerValue;
    
    int tableIndexVal;
    
    FMDatabase *db;
    NSString *defaultDBPath;
    NSString *dbPath;
    NSString *provider;
    NSString *notifydistance;
    NSString *notifytime;
    NSString *providerVal;

}

@property(nonatomic,strong)UITableView *listenerTable;
@property (strong, nonatomic) MLTableAlert *alert;
@property (nonatomic, strong) IBOutlet UITextField *rowsNumField;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;
@property(nonatomic,strong)NSString *pickerValue;

-(IBAction)done:(id)sender;

@end
