//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "ListenerViewController.h"
#import "MLTableAlert.h"

@interface ListenerViewController ()

@end

@implementation ListenerViewController

@synthesize listenerTable,rowsNumField,alert,resultLabel,pickerValue;

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

    listenerTable.backgroundColor = [UIColor clearColor];
    intervalPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 280, 320, 200)];
    intervalPicker.delegate = self;
    intervalPicker.showsSelectionIndicator = YES;
    intervalPicker.backgroundColor = [UIColor grayColor];

    intervalPicker.hidden = YES;
    [self.view addSubview:intervalPicker];
    
    // get data from db
    
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

    listenerArray = [[NSMutableArray alloc]initWithObjects:@"Provider (GPS/Network/Both)",@"Minimum notify distance",@"Minimum notify time", nil];
    providerListArray = [provider componentsSeparatedByString:@","];
    listenerValueArray = [[NSMutableArray alloc]initWithObjects:provider,notifydistance,notifytime, nil];
    
//    intervalListArr = [[NSMutableArray alloc] initWithObjects:@"10 sec",@"20 sec",@"30 sec",@"40 sec",@"50 sec",@"1 min",@"2 min",@"3 min",@"4 min",@"5 min",@"10 min",@"20 min", nil];
    
    intervalListArr = [[NSMutableArray alloc] initWithObjects:@"10 sec",@"20 sec",@"30 sec",@"40 sec",@"50 sec",@"60 sec",@"120 sec",@"180 sec",@"240 sec",@"300 sec",@"360 sec",@"420 sec", nil];

}

-(void)getDataFromDb
{
    if (![db open]) {
        NSLog(@"Ooops");
        return;
    }
    
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
    
    while ([rs next]) {
        NSLog(@"%@",
              [rs stringForColumn:@"provider"]);
        
        provider = [rs stringForColumn:@"provider"];
        notifydistance = [rs stringForColumn:@"notifydistance"];
        notifytime = [rs stringForColumn:@"notifytime"];
        providerVal = [rs stringForColumn:@"providervalue"];
    }
    NSLog(@"Text One:%@\n%@\n%@\n%@",provider,notifydistance,notifytime,providerVal);
    
}

#pragma Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [listenerArray count];
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
		[valLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[cell.contentView addSubview:valLabel];
    }
    
    UILabel *textLabel = (UILabel *)[cell viewWithTag:1001];
	UILabel *valLabel = (UILabel *)[cell viewWithTag:1002];
    
    textLabel.text = [listenerArray objectAtIndex:indexPath.row];
    
    if (![providerSelectedVal length]==0) {
        valLabel.text = [listenerValueArray objectAtIndex:indexPath.row];
    }else{
        valLabel.text = [listenerValueArray objectAtIndex:indexPath.row];
    }
    

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Pushing next view
    
    tableIndexVal = indexPath.row;
    
    if ([db open] != YES) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        return; //VERY IMPORTANT
    }

    
    if (indexPath.row==0) {
        // create the alert
        self.alert = [MLTableAlert tableAlertWithTitle:@"Choose an option..." cancelButtonTitle:@"Cancel" numberOfRows:^NSInteger (NSInteger section)
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
                          
                          providerListArray = [[NSMutableArray alloc]initWithObjects:@"GPS",@"Network Provider",@"Both", nil];
                          cell.textLabel.text = [providerListArray objectAtIndex:indexPath.row];
                          return cell;
                      }];
        
        // Setting custom alert height
        self.alert.height = 100;
        
        // configure actions to perform
        [self.alert configureSelectionBlock:^(NSIndexPath *selectedIndex){
            self.resultLabel.text = [NSString stringWithFormat:@"Selected Index\nSection: %d Row: %d", selectedIndex.section, selectedIndex.row];
            NSLog(@"Alert selected Text:%@",[providerListArray objectAtIndex:selectedIndex.row]);
            providerSelectedVal = [providerListArray objectAtIndex:selectedIndex.row];
            
            // Replace provider value with selected value and update DB
            
            BOOL success = NO;
            
            [db beginTransaction];
            success = [db executeUpdate:@"UPDATE geoLocus SET provider = ?",providerSelectedVal];
            
            if (success) {
                NSLog(@"OK");
                [db commit];
                
                FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
                
                while ([rs next]) {
                    NSLog(@"%@",
                          [rs stringForColumn:@"provider"]);
                    NSString *replaceProtocolValue;
                    replaceProtocolValue = [rs stringForColumn:@"provider"];
                    [listenerValueArray replaceObjectAtIndex:tableIndexVal withObject:replaceProtocolValue];
                    
                }
                //            [db close];
            }else {
                NSLog(@"FAIL");
            }

            [listenerTable reloadData];
            
        } andCompletionBlock:^{
            self.resultLabel.text = @"Cancel Button Pressed\nNo Cells Selected";
        }];
        
        // show the alert
        [self.alert show];
        

    }else
    {
        intervalPicker.hidden = NO;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

#pragma Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [intervalListArr count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [intervalListArr objectAtIndex:row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    BOOL success = NO;
    
    if ([db open] != YES) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        return; //VERY IMPORTANT
    }
    
    if (tableIndexVal==1) {
        [db beginTransaction];
        success = [db executeUpdate:@"UPDATE geoLocus SET notifydistance = ?", [intervalListArr objectAtIndex:row]];
        
        if (success) {
            NSLog(@"OK");
            [db commit];
            
            FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
            
            while ([rs next]) {
                NSLog(@"%@",
                      [rs stringForColumn:@"notifydistance"]);
                NSString *replaceWithUpdatedData;
                replaceWithUpdatedData = [rs stringForColumn:@"notifydistance"];
                pickerValue = replaceWithUpdatedData ;
                [listenerValueArray replaceObjectAtIndex:tableIndexVal withObject:pickerValue];
                
            }
        }else {
            NSLog(@"FAIL");
        }

    }else if (tableIndexVal==2)
    {
        [db beginTransaction];
        success = [db executeUpdate:@"UPDATE geoLocus SET notifytime = ?", [intervalListArr objectAtIndex:row]];
        
        if (success) {
            NSLog(@"OK");
            [db commit];
            
            FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
            
            while ([rs next]) {
                NSLog(@"%@",
                      [rs stringForColumn:@"notifytime"]);
                NSString *replaceWithUpdatedData;
                replaceWithUpdatedData = [rs stringForColumn:@"notifytime"];
                pickerValue = replaceWithUpdatedData ;
                [listenerValueArray replaceObjectAtIndex:tableIndexVal withObject:pickerValue];
                
            }
        }else {
            NSLog(@"FAIL");
        }

    }

//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:2.0];
//    CGAffineTransform transform=CGAffineTransformMakeTranslation(0, 480);
//    intervalPicker.transform=transform;
//    [UIView commitAnimations];//dismiss the view controller which contains the picker view

    intervalPicker.hidden = YES;
    
    [listenerTable reloadData];
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
