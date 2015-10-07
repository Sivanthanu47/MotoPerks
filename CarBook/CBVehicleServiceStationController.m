//
//  CBVehicleServiceStationViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 10/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBVehicleServiceStationController.h"
#import "CBVehicleServiceStationAddController.h"
#import "CBVehicleServiceStationViewController.h"
#import "CBVehicleStationDetailController.h"
#import "CBMapViewController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "CustomCell.h"

@interface CBVehicleServiceStationController ()

@end

@implementation CBVehicleServiceStationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}
- (void)viewWillAppear:(BOOL)animated {
    self.title = [[CBStrings sharedStrings] getPageTitle:@"StationsPage"];
    [self setNavigationBar];
    searchbar.text =@"";
    arrSSDetails = [[NSMutableArray alloc] init];
    arrKM = [[NSMutableArray alloc] init];
    [arrSSDetails addObjectsFromArray:[[CBDBMethods sharedTools] getServiceStationDetails]];
    [arrKM addObjectsFromArray:[[Constants sharedPath] getCurrentLocation:nil]];
    if ([arrSSDetails count] > 0) {
        [tblStation reloadData];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (_strViewName == nil) {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goNext)];
        self.navigationItem.rightBarButtonItem = addButton;
    }
    self.navigationItem.leftBarButtonItems = [self getTopMenuLeft];
}
- (NSMutableArray *)getTopMenuLeft {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    CGRect frameimgdeveloper = CGRectMake(0, 0, 44, 27);
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:frameimgdeveloper];
    [btnDeveloper setTitle:@"Back" forState:UIControlStateNormal];
    [btnDeveloper setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (NSMutableArray *)getTopMenuRight {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    CGRect frameimgdeveloper = CGRectMake(0, 0, 44, 27);
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:frameimgdeveloper];
    [btnDeveloper setTitle:@"Add" forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goNext {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleServiceStationAddController alloc] initWithNibName:@"CBVehicleServiceStationAddController" bundle:nil];
    } else {
        viewController = [[CBVehicleServiceStationAddController alloc] initWithNibName:@"CBVehicleServiceStationAddController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrSSDetails count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cellStation = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"ServiceStationsCellIdentifier"];
    if (cellStation == nil) {
        NSArray *cellNib;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            cellNib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        } else {
            cellNib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_iPad" owner:self options:nil];
        }
        cellStation = (CustomCell *)[cellNib objectAtIndex:6];
    }
    NSMutableDictionary *stationDict = [arrSSDetails objectAtIndex:indexPath.row];
    NSMutableDictionary *disDict = [arrKM objectAtIndex:indexPath.row];
    cellStation.lblStationName.text =[NSString stringWithFormat:@"%@" ,[stationDict objectForKey:@"stationName"]];
    cellStation.lblStationAdd.text = [NSString stringWithFormat:@" %@\n Address: %@\n ContactNo: %@ \n Ph no:  %@ \n",[stationDict objectForKey:@"AddCity"],[stationDict objectForKey:@"Address"],[stationDict objectForKey:@"ContactNo"],[stationDict objectForKey:@"PhoneNo"]];
    cellStation.lblStationAdd.numberOfLines=4;
    cellStation.lblStationKm.text = [NSString stringWithFormat:@"%@",[disDict objectForKey:@"distance"]];
    cellStation.btnMapPin.tag = indexPath.row;
    [cellStation.btnMapPin addTarget:self action:@selector(goToMapView:) forControlEvents:UIControlEventTouchUpInside];
    cellStation.backgroundColor = [UIColor clearColor];
    cellStation.textLabel.textColor = [UIColor blackColor];
    return cellStation;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *stationDict = [arrSSDetails objectAtIndex:indexPath.row];
    if (_strViewName == nil) {
        CBVehicleStationDetailController *viewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            viewController = [[CBVehicleStationDetailController alloc] initWithNibName:@"CBVehicleStationDetailController" bundle:nil];
            viewController.stationID = [stationDict objectForKey:@"SSId"];
        } else {
            viewController = [[CBVehicleStationDetailController alloc] initWithNibName:@"CBVehicleStationDetailController_iPad" bundle:nil];
            viewController.stationID = [stationDict objectForKey:@"SSId"];
        }
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        CBVehicleServiceStationViewController *viewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            viewController = [[CBVehicleServiceStationViewController alloc] initWithNibName:@"CBVehicleServiceStationViewController" bundle:nil];
            viewController.StationId = [stationDict objectForKey:@"SSId"];
            viewController.serStationName = [stationDict objectForKey:@"stationName"];
        } else {
            viewController = [[CBVehicleServiceStationViewController alloc] initWithNibName:@"CBVehicleServiceStationViewController_iPad" bundle:nil];
            viewController.StationId = [stationDict objectForKey:@"SSId"];
            viewController.serStationName = [stationDict objectForKey:@"stationName"];
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (void)goToMapView:(UIButton *)sender {
    if ((NO == [[Constants sharedPath] isNetworkAvailable])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                            message:[[CBStrings sharedStrings] getAlertMessage:@"NoNetwork"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSMutableDictionary *stationDict = [arrSSDetails objectAtIndex:sender.tag];
    CBMapViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBMapViewController alloc] initWithNibName:@"CBMapViewController" bundle:nil];
        viewController.stationID = [stationDict objectForKey:@"SSId"];
    } else {
        viewController = [[CBMapViewController alloc] initWithNibName:@"CBMapViewController_iPad" bundle:nil];
        viewController.stationID = [stationDict objectForKey:@"SSId"];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - SearchBar Delegates
- (void)searchTableView {
    [arrSSDetails addObjectsFromArray:[[CBDBMethods sharedTools] searchingServiceStationName:searchbar.text]];
    for (NSDictionary *stationDict in arrSSDetails) {
        [arrKM addObjectsFromArray: [[Constants sharedPath] getCurrentLocation:[stationDict objectForKey:@"SSId"]]];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [arrSSDetails removeAllObjects];
    [arrKM removeAllObjects];
    if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        [arrSSDetails addObjectsFromArray:[[CBDBMethods sharedTools] getServiceStationDetails]];
        [arrKM addObjectsFromArray: [[Constants sharedPath] getCurrentLocation:nil]];
    } else if ([searchText length] > 0) {
        [self searchTableView];
    }
    [tblStation reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchbar.text =@"";
    [arrSSDetails removeAllObjects];
    [arrKM removeAllObjects];
    [arrSSDetails addObjectsFromArray:[[CBDBMethods sharedTools] getServiceStationDetails]];
    [arrKM addObjectsFromArray: [[Constants sharedPath] getCurrentLocation:nil]];
    [tblStation reloadData];
    [searchbar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchbar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
