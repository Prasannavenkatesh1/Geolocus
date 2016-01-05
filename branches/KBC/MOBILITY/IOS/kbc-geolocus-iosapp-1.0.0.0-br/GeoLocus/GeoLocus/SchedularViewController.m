//Created by Insurance H3 Team
//
//GeoLocus App
//

#import "SchedularViewController.h"
#import "DataTransmissionController.h"
#import "CollectionIntervalController.h"

@interface SchedularViewController ()

@end

@implementation SchedularViewController

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

    schedularTable.backgroundColor = [UIColor clearColor];
  schedularArray = [[NSMutableArray alloc]initWithObjects:@"Data Transmission",@"Location Data Capture", nil];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [schedularArray count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"MyIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:MyIdentifier];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.textLabel.text = [schedularArray objectAtIndex:indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //Pushing next view
    if (indexPath.row==0) {
        DataTransmissionController *dataController = [[DataTransmissionController alloc] initWithNibName:@"DataTransmissionController" bundle:nil];
        [self presentViewController:dataController animated:YES completion:nil];
    }else
    {
        CollectionIntervalController *collectionController = [[CollectionIntervalController alloc] initWithNibName:@"CollectionIntervalController" bundle:nil];
        [self presentViewController:collectionController animated:YES completion:nil];

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 60;
    
}

-(IBAction)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:Nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
