//
//  CBVehicleMainViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 10/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBVehicleMainViewController.h"
#import "CBStrings.h"
#import "CBVehicleViewController.h"
#import "CBVehicleServiceStationController.h"
#import "CBMapViewController.h"
#import "CBTrackMileageListViewController.h"
#import "CBSettingsViewController.h"
#import "CBReportViewController.h"
#import "Constants.h"
#import "CBDBMethods.h"
#import "CBExportViewController.h"
#import "CBTrackMileageAddViewController.h"
@interface CBVehicleMainViewController ()

@end

@implementation CBVehicleMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    self.title = [[CBStrings sharedStrings] getString:@"Main_Name"];
    [self setNavigationBar];
    [[Constants sharedPath] setLocalNotification];
    arrMenuTitle = [[NSMutableArray alloc] initWithObjects:@"Vehicles",@"Service Stations",@"Report",@"Map",@"Export",@" Track Mileage", nil];
    notificationLabel.backgroundColor = [[CBStrings sharedStrings]colorFromString:@"404040"];
    //arrimgTitle = [[NSMutableArray alloc]initWithObjects:@"vehicles_trim.png",@"Stations_trim.png",@"Report_trim.png",@"Map_trim.png",@"Export_trim.png",@"clock.png", nil];
}
- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.backgroundColor = [[CBStrings sharedStrings]colorFromString:@"494949"];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.navigationItem.rightBarButtonItems = [self getTopMenuRight];
   // self.navigationItem.leftBarButtonItems = [self getTopMenuLeft];
    self.navigationItem.hidesBackButton = YES;
}
/*- (NSMutableArray *)getTopMenuRight {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    UIImage *image = [UIImage imageNamed:@"Settings.png"];
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width-25, image.size.height-25)];
    [btnDeveloper setImage:image forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(loadSettingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (NSMutableArray *)getTopMenuLeft {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    UIImage *image = [UIImage imageNamed:@"About.png"];
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width-25, image.size.height-25)];
    [btnDeveloper setImage:image forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(loadSettingView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}*/

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
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
    cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow.png"]];
    //cell.backgroundColor =[[CBStrings sharedStrings]colorFromString:@"D6D6D6"];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    //cell.imageView.image = [UIImage imageNamed:[arrimgTitle objectAtIndex:indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        [self loadVehicleView];
    } else if(indexPath.row == 1) {
        [self loadStationView];
    } else if(indexPath.row == 2) {
        [self loadReportView];
    } else if(indexPath.row == 3) {
        [self loadMapView];
    } else if(indexPath.row == 4) {
        [self loadExportView];
    }
    else if(indexPath.row ==5) {
        [self loadAddFuel];
    }
}
-(IBAction)loadExportView{
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBExportViewController alloc] initWithNibName:@"CBExportViewController" bundle:nil];
    } else {
        viewController = [[CBVehicleViewController alloc] initWithNibName:@"CBExportViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)loadVehicleView {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleViewController alloc] initWithNibName:@"CBVehicleViewController" bundle:nil];
    } else {
        viewController = [[CBVehicleViewController alloc] initWithNibName:@"CBVehicleViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)loadStationView {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleServiceStationController alloc] initWithNibName:@"CBVehicleServiceStationController" bundle:nil];
    } else {
        viewController = [[CBVehicleServiceStationController alloc] initWithNibName:@"CBVehicleServiceStationController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)loadServiceView:(id)sender {
    CBVehicleServiceStationController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleServiceStationController alloc] initWithNibName:@"CBVehicleServiceStationController" bundle:nil];
        viewController.strViewName = @"Service";
    } else {
        viewController = [[CBVehicleServiceStationController alloc] initWithNibName:@"CBVehicleServiceStationController_iPad" bundle:nil];
        viewController.strViewName = @"Service";
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)loadMapView {
    if ((NO == [[Constants sharedPath] isNetworkAvailable])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                            message:[[CBStrings sharedStrings] getAlertMessage:@"NoNetwork"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBMapViewController alloc] initWithNibName:@"CBMapViewController" bundle:nil];
    } else {
        viewController = [[CBMapViewController alloc] initWithNibName:@"CBMapViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)loadAddFuel{
    
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBTrackMileageListViewController alloc] initWithNibName:@"CBTrackMileageListViewController" bundle:nil];
    } else {
        viewController = [[CBTrackMileageListViewController alloc] initWithNibName:@"CBTrackMileageListViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
   
}
- (IBAction)loadMileageView:(id)sender{
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBTrackMileageAddViewController alloc] initWithNibName:@"CBTrackMileageAddViewController" bundle:nil];
    } else {
        viewController = [[CBTrackMileageAddViewController alloc] initWithNibName:@"CBTrackMileageAddViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)loadSettingView {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBSettingsViewController alloc] initWithNibName:@"CBSettingsViewController" bundle:nil];
    } else {
        viewController = [[CBSettingsViewController alloc] initWithNibName:@"CBSettingsViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)loadReportView {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBReportViewController alloc] initWithNibName:@"CBReportViewController" bundle:nil];
    } else {
        viewController = [[CBReportViewController alloc] initWithNibName:@"CBReportViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
