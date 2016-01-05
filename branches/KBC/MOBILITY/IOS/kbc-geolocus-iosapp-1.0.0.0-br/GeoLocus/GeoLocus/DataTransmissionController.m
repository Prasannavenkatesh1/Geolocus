//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "DataTransmissionController.h"

@interface DataTransmissionController ()

@end

@implementation DataTransmissionController

@synthesize pickerValue;
@synthesize dataTransTable;

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

    dataTransTable.backgroundColor = [UIColor clearColor];
    
 
    seconds = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60"];
    
    minutes = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",@"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",@"60"];
    
    hours = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24"];

    // assumes global UIPickerView declared. Move the frame to wherever you want it
    intervalPicker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 300, self.view.frame.size.width, 200)];
    intervalPicker.dataSource = self;
    intervalPicker.delegate = self;
    intervalPicker.hidden = YES;
    intervalPicker.backgroundColor = [UIColor grayColor];
    
    UILabel *hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(42, intervalPicker.frame.size.height / 2 - 15, 75, 30)];
    hourLabel.text = @"hour";
    [intervalPicker addSubview:hourLabel];
    
    UILabel *minsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + (intervalPicker.frame.size.width / 3), intervalPicker.frame.size.height / 2 - 15, 75, 30)];
    minsLabel.text = @"min";
    [intervalPicker addSubview:minsLabel];
    
    UILabel *secsLabel = [[UILabel alloc] initWithFrame:CGRectMake(42 + ((intervalPicker.frame.size.width / 3) * 2), intervalPicker.frame.size.height / 2 - 15, 75, 30)];
    secsLabel.text = @"sec";
    [intervalPicker addSubview:secsLabel];
    
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

    transIntervaArr = [[NSMutableArray alloc]initWithObjects:@"Transmission interval", nil];
    
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
              [rs stringForColumn:@"transmissioninterval"]);
        
        transmissionInterval = [rs stringForColumn:@"transmissioninterval"];
    }
    NSLog(@"Text One:%@",transmissionInterval);
    
}

#pragma Table
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [transIntervaArr count];
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
        
        UILabel* textLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5,150,50)];
		textLabel.tag = 1001;
		textLabel.backgroundColor = [UIColor clearColor];
        textLabel.textAlignment = NSTextAlignmentLeft;
		textLabel.textColor = [UIColor whiteColor];
		textLabel.numberOfLines = 3;
		[textLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[cell.contentView addSubview:textLabel];
        
        UILabel* valLabel = [[UILabel alloc] initWithFrame:CGRectMake(230,5,85,50)];
		valLabel.tag = 1002;
		valLabel.backgroundColor = [UIColor clearColor];
        valLabel.textAlignment = NSTextAlignmentRight;
		valLabel.textColor = [UIColor grayColor];
		valLabel.numberOfLines = 3;
		[valLabel setFont:[UIFont boldSystemFontOfSize:14]];
		[cell.contentView addSubview:valLabel];
    }

    UILabel *textLabel = (UILabel *)[cell viewWithTag:1001];
	UILabel *valLabel = (UILabel *)[cell viewWithTag:1002];
    
    textLabel.text = [transIntervaArr objectAtIndex:indexPath.row];
    if (![pickerValue length]==0) {
        valLabel.text = pickerValue;
    }else{
        valLabel.text = transmissionInterval;

    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Pushing next view
    
    intervalPicker.hidden = NO;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

#pragma Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
//    return [intervalListArr count];
    
    if(component == 0)
    {
        return [hours count];
    }else if (component == 1)
    {
        return [minutes count];
    }else if (component == 2)
    {
        return [seconds count];
    }else
    {
        return 60;
        
    }

}

//-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    return [intervalListArr objectAtIndex:row];
//}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    NSInteger row1, row2, row3;
    id row1SelVal;
    id row2SelVal;
    id row3SelVal;
    
    
    row1 = (int)[intervalPicker selectedRowInComponent:0];
    row2 = (int)[intervalPicker selectedRowInComponent:1];
    row3 = (int)[intervalPicker selectedRowInComponent:2];
    
    row1SelVal = [hours objectAtIndex:row1];
    row2SelVal = [minutes objectAtIndex:row2];
    row3SelVal = [seconds objectAtIndex:row3];
    
    
    NSLog(@"%@ %@ %@",row1SelVal,row2SelVal,row3SelVal);
    
    int result = [row3SelVal intValue] + ([row2SelVal intValue]*60) + ([row1SelVal intValue]*3600);
    
    NSLog(@"%d",result);
    
    NSString *interval = [NSString stringWithFormat:@"%d", result];

    BOOL success = NO;
    
    if ([db open] != YES) {
        NSLog(@"DB Error %d: %@", [db lastErrorCode], [db lastErrorMessage]);
        return; //VERY IMPORTANT
    }
    
    [db beginTransaction];
//    success = [db executeUpdate:@"UPDATE geoLocus SET transmissioninterval = ?", [intervalListArr objectAtIndex:row]];
    success = [db executeUpdate:@"UPDATE geoLocus SET transmissioninterval = ?", interval];

    
    if (success) {
        NSLog(@"OK");
        [db commit];
        
        FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"SELECT * From geoLocus"]];
        
        while ([rs next]) {
            NSLog(@"%@",
                  [rs stringForColumn:@"transmissioninterval"]);
            NSString *replaceWithUpdatedData;
            replaceWithUpdatedData = [rs stringForColumn:@"transmissioninterval"];
            pickerValue = replaceWithUpdatedData ;
            
        }
        //            [db close];
    }else {
        NSLog(@"FAIL");
    }

    [dataTransTable reloadData];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *columnView = [[UILabel alloc] initWithFrame:CGRectMake(35, 0, self.view.frame.size.width/3 - 35, 50)];
    columnView.backgroundColor = [UIColor whiteColor];
    columnView.textColor = [UIColor blueColor];
    columnView.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    columnView.text = [NSString stringWithFormat:@"%lu", (long)row];
    columnView.textAlignment = NSTextAlignmentLeft;
    
    return columnView;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 50;
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
