//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "NetworkViewController.h"
#import "MLTableAlert.h"

@interface NetworkViewController ()

@end

@implementation NetworkViewController

@synthesize networkTable;
@synthesize rowsNumField;
@synthesize alert;
@synthesize resultLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    networkTable.backgroundColor = [UIColor clearColor];
   
    defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    
    dbPath = [documentsDir stringByAppendingPathComponent:@"geoLocus.sqlite"];
    
    if([fileManager fileExistsAtPath:dbPath]==NO){
        
        defaultDBPath = [[NSBundle mainBundle] pathForResource:@"geoLocus" ofType: @"sqlite"];
        BOOL success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if(!success){
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    db = [FMDatabase databaseWithPath:dbPath];

    [self getDataFromDb];
    
    networkArray = [[NSMutableArray alloc]initWithObjects:@"Host name",@"Port",@"Protocols",@"Data upload type",@"Syncronization", nil];
    networkValueArray = [[NSMutableArray alloc]initWithObjects:hostName,port,protocols,dataUploadType,@"Not Syncronized", nil];
    protocolArray = [protocols componentsSeparatedByString:@","];
    dataUploadtype = [dataUploadType componentsSeparatedByString:@","];

}

-(void)getDataFromDb
{
    if (![db open]) {
        NSLog(@"Ooops");
        return;
    }
    networkArray = [[NSMutableArray alloc]init];
    
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
    
    while ([rs next]) {
        NSLog(@"%@",
              [rs stringForColumn:@"hostname"]);
        
        hostName = [rs stringForColumn:@"hostname"];
        port = [rs stringForColumn:@"port"];
        protocols = [rs stringForColumn:@"protocols"];
        dataUploadType = [rs stringForColumn:@"dataUploadType"];
//        syncronization = [rs stringForColumn:@"syncronization"];

    }
    NSLog(@"Text One:%@\n%@\n%@\n%@",hostName,port,protocols,dataUploadType);
   
}

#pragma mark Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [networkArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0,200,50)];
		textLabel.tag = 1001;
		textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = NSTextAlignmentLeft;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.numberOfLines = 3;
		[textLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[cell.contentView addSubview:textLabel];
        
        UILabel* valLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,20,250,50)];
		valLabel.tag = 1002;
		valLabel.backgroundColor = [UIColor clearColor];
        valLabel.textAlignment = NSTextAlignmentLeft;
		valLabel.textColor = [UIColor grayColor];
		valLabel.numberOfLines = 3;
		[valLabel setFont:[UIFont boldSystemFontOfSize:12]];
		[cell.contentView addSubview:valLabel];
    }
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1001];
	UILabel *valLabel = (UILabel *)[cell viewWithTag:1002];
    
    textLabel.text = [networkArray objectAtIndex:indexPath.row];
    
    NSLog(@"%@",networkValueArray);
        valLabel.text = [networkValueArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    selectedRowIndex = indexPath.row;
    
    
    if ([db open] != YES) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        return; //VERY IMPORTANT
    }

    if (selectedRowIndex == 0) {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Host name?"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Continue", nil];
        
        [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        networkTxtField = [message textFieldAtIndex:0];
        networkTxtField.text = [networkValueArray objectAtIndex:indexPath.row];
        
        [message show];

    }else if (selectedRowIndex == 1)
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Port?"
                                                          message:nil
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Continue", nil];
        
        [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
        networkTxtField = [message textFieldAtIndex:0];
        networkTxtField.text = [networkValueArray objectAtIndex:indexPath.row];

        [message show];

    }else if (selectedRowIndex == 2)
    {
            // create the alert
            self.alert = [MLTableAlert tableAlertWithTitle:@"Protocols" cancelButtonTitle:@"OK" numberOfRows:^NSInteger (NSInteger section)
                          {
                              if (self.rowsNumField.text == nil || [self.rowsNumField.text length] == 0 || [self.rowsNumField.text isEqualToString:@"0"])
                                  return 3;
                              else
                                  return [self.rowsNumField.text integerValue];
                          }
                                                  andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                          {
                              static NSString *CellIdentifier = @"CellIdentifier";
                              UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                              if (cell == nil)
                                  cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                              
                              protocolArray = [[NSMutableArray alloc]initWithObjects:@"Http",@"Https",@"TCP/IP", nil];
                              cell.textLabel.text = [protocolArray objectAtIndex:indexPath.row];
                              return cell;
                          }];
            
            // Setting custom alert height
            self.alert.height = 100;
            
            // configure actions to perform
            [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
                self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
                NSLog(@"Alert selected Text:%@",[protocolArray objectAtIndex:selectedIndex.row]);
                
                alertSelectedProtocol = [protocolArray objectAtIndex:selectedIndex.row];

                // Replace protocol value with selected value and update DB
                
                BOOL success = NO;
                
                [db beginTransaction];
                success = [db executeUpdate:@"UPDATE geoLocus SET protocols = ?",alertSelectedProtocol];
                
                if (success) {
                    NSLog(@"OK");
                    [db commit];
                    
                    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
                    
                    while ([rs next]) {
                        NSLog(@"%@",
                              [rs stringForColumn:@"protocols"]);
                        NSString *replaceProtocolValue;
                        replaceProtocolValue = [rs stringForColumn:@"protocols"];
                        [networkValueArray replaceObjectAtIndex:selectedRowIndex withObject:replaceProtocolValue];
                        
                    }
                    //            [db close];
                }else {
                    NSLog(@"FAIL");
                }

                [networkTable reloadData];
                
            } andCompletionBlock:^{
                self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
            }];
            
            // show the alert
            [self.alert show];
            
            
    }else if (selectedRowIndex == 3)
    {
        // create the alert
        self.alert = [MLTableAlert tableAlertWithTitle:@"Data upload type" cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
                      {
                          if (self.rowsNumField.text == nil || [self.rowsNumField.text length] == 0 || [self.rowsNumField.text isEqualToString:@"0"])
                              return 2;
                          else
                              return [self.rowsNumField.text integerValue];
                      }
                                              andCells:^UITableViewCell* (MLTableAlert *anAlert, NSIndexPath *indexPath)
                      {
                          static NSString *CellIdentifier = @"CellIdentifier";
                          UITableViewCell *cell = [anAlert.table dequeueReusableCellWithIdentifier:CellIdentifier];
                          if (cell == nil)
                              cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
                          
                          dataUploadtype = [[NSMutableArray alloc]initWithObjects:@"WiFi",@"Mobile data", nil];
                          cell.textLabel.text = [dataUploadtype objectAtIndex:indexPath.row];
                          return cell;
                      }];
        
        // Setting custom alert height
        self.alert.height = 50;
        
        // configure actions to perform
        [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
            NSLog(@"Alert selected Text:%@",[dataUploadtype objectAtIndex:selectedIndex.row]);
            alertSelectedDatatype = [dataUploadtype objectAtIndex:selectedIndex.row];
            
            // Replace protocol value with selected value and update DB
            
            BOOL success = NO;

            [db beginTransaction];
            success = [db executeUpdate:@"UPDATE geoLocus SET dataUploadType = ?",alertSelectedDatatype];
            
            if (success) {
                NSLog(@"OK");
                [db commit];
                
                FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
                
                while ([rs next]) {
                    NSLog(@"%@",
                          [rs stringForColumn:@"dataUploadType"]);
                    NSString *replaceDataUploadType;
                    replaceDataUploadType = [rs stringForColumn:@"dataUploadType"];
                    [networkValueArray replaceObjectAtIndex:selectedRowIndex withObject:replaceDataUploadType];
                    
                }
                //            [db close];
            }else {
                NSLog(@"FAIL");
            }

            [networkTable reloadData];
            
        } andCompletionBlock:^{
            self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
        }];
        
        // show the alert
        [self.alert show];

    }else if (selectedRowIndex == 4)
    {
        
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"user pressed Button Indexed 0");
        // Any action can be performed here
    }
    else
    {
        NSLog(@"user pressed Button Indexed 1");
        
        BOOL success = NO;
        
        if ([db open] != YES) {
            NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
            return; //VERY IMPORTANT
        }

        
        if (selectedRowIndex == 0) {
            
            [db beginTransaction];
            success = [db executeUpdate:@"UPDATE geoLocus SET hostname = ?", networkTxtField.text];
            
            //        FMResultSet *rs = [db executeUpdate:@"UPDATE geoLocus SET hostname = ?", networkTxtField.text];
            if (success) {
                NSLog(@"OK");
                [db commit];
                
                FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
                
                while ([rs next]) {
                    NSLog(@"%@",
                          [rs stringForColumn:@"hostname"]);
                    NSString *replaceWithUpdatedData;
                    replaceWithUpdatedData = [rs stringForColumn:@"hostname"];
                    [networkValueArray replaceObjectAtIndex:selectedRowIndex withObject:replaceWithUpdatedData];
                    
                }
                //            [db close];
            }else {
                NSLog(@"FAIL");
            }
        }else if (selectedRowIndex == 1) {
            
            
            [db beginTransaction];
            success = [db executeUpdate:@"UPDATE geoLocus SET port = ?", networkTxtField.text];
            
            if (success) {
                NSLog(@"OK");
                [db commit];
                
                FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
                
                while ([rs next]) {
                    NSLog(@"%@",
                          [rs stringForColumn:@"port"]);
                    NSString *replacePortValue;
                    replacePortValue = [rs stringForColumn:@"port"];
                    [networkValueArray replaceObjectAtIndex:selectedRowIndex withObject:replacePortValue];
                    
                }
                //            [db close];
            }else {
                NSLog(@"FAIL");
            }

        }
        [networkTable reloadData];
        // Any action can be performed here
    }
}


-(IBAction)done:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receiveDBNotification" object:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"bBNotification" object:self];

    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
