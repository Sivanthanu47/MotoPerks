//
//  CBNoVehiclesViewController.m
//  CarBook
//
//  Created by Raja T S Sekhar on 12/08/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBNoVehiclesViewController.h"
#import "CBStrings.h"
#import "CBVehicleMainViewController.h"
@interface CBNoVehiclesViewController ()

@end

@implementation CBNoVehiclesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = [[CBStrings sharedStrings] getString:@"Main_Name"];
    
    arrMenuTitle = [[NSMutableArray alloc] initWithObjects:@"\u2705 Manage Vehicle Data",@"\u2705 Track Services",@"\u2705 Track Fuel Feeding",@"\u2705 Track Mileage", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self setNavigationBar];
}
- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barTintColor =[[CBStrings sharedStrings]colorFromString:@"535353"];
    self.navigationController.navigationBar.backgroundColor =[[CBStrings sharedStrings]colorFromString:@"535353"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton = YES;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrMenuTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [arrMenuTitle objectAtIndex:indexPath.row];
    cell.backgroundColor =[UIColor clearColor];
    cell.textLabel.textColor = [[CBStrings sharedStrings]colorFromString:@"2B4074"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
   
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
-(IBAction)Continue:(id)sender{
    UIViewController *viewController;

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleMainViewController alloc] initWithNibName:@"CBVehicleMainViewController" bundle:nil];
    } else {
        viewController = [[CBVehicleMainViewController alloc] initWithNibName:@"CBVehicleMainViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
