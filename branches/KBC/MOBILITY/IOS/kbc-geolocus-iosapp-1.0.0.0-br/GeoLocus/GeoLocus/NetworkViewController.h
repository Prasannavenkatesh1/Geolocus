//Created by Insurance H3 Team
//
//GeoLocus App
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

@class MLTableAlert;

@interface NetworkViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    FMDatabase *db;
    NSString *defaultDBPath;
    NSString *dbPath;
    
    IBOutlet UITableView *networkTable;
    
    NSMutableArray *networkArray;
    NSMutableArray *networkValueArray;
    NSArray *protocolArray;
    NSArray *dataUploadtype;
    
    int selectedRowIndex;
    UITextField *networkTxtField;
    NSString *alertSelectedProtocol;
    NSString *alertSelectedDatatype;


    NSString *hostName;
    NSString *port;
    NSString *protocols;
    NSString *dataUploadType;
    NSString *syncronization;

}

@property(nonatomic,strong)UITableView *networkTable;
@property (strong, nonatomic) MLTableAlert *alert;
@property (nonatomic, strong) IBOutlet UITextField *rowsNumField;
@property (nonatomic, strong) IBOutlet UILabel *resultLabel;


-(IBAction)done:(id)sender;

@end
