//
//  CBVehicleServiceStationViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 10/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBVehicleServiceStationViewController.h"
#import "CBVehicleDetailsViewController.h"
#import "CBMapViewController.h"
#import "CBVehicleServiceDetailViewController.h"
#import "CBVehicleServiceStationAddController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "Constants.h"
#import "UIImage+Resize.h"

@interface CBVehicleServiceStationViewController ()

@end

@implementation CBVehicleServiceStationViewController
@synthesize StationId;
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
    self.title = _serStationName;
    [self setNavigationBar];
    arrVecData = [[NSMutableArray alloc] init];
    [arrVecData addObjectsFromArray:[[CBDBMethods sharedTools] getSingleStationwithVehicle:StationId]];
    [tblView reloadData];
}
- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = [self getTopMenuLeft];
    self.navigationItem.rightBarButtonItems = [self getTopMenuRight];
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
    CGRect frameimgdeveloper = CGRectMake(0, 0, 50, 27);
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:frameimgdeveloper];
    [btnDeveloper setTitle:@"Home" forState:UIControlStateNormal];
    [btnDeveloper setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrVecData count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:18.0];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12.0];
    NSInteger serialNo = indexPath.row+1;
    NSMutableDictionary *dict = [arrVecData objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld. %@",(long)serialNo,[dict objectForKey:@"CarName"]];
    cell.detailTextLabel.text = [dict objectForKey:@"LastServiceDate"];
    NSArray *paths = [[Constants sharedPath] getDocumentPath];
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[dict objectForKey:@"PhotoURL"]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageView.image = [image thumbnailImage:48 transparentBorder:1 cornerRadius:3 interpolationQuality:kCGInterpolationDefault];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor =[ UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *vehicleDict = [arrVecData objectAtIndex:indexPath.row];
    CBVehicleServiceDetailViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleServiceDetailViewController alloc] initWithNibName:@"CBVehicleServiceDetailViewController" bundle:nil];
        viewController.VehicleID = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"VDId"]];
    } else {
        viewController = [[CBVehicleServiceDetailViewController alloc] initWithNibName:@"CBVehicleServiceDetailViewController_iPad" bundle:nil];
        viewController.VehicleID = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"VDId"]];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
