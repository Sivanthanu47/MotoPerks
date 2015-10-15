//
//  CBAddGasStationViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 19/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBAddGasStationViewController.h"
#import "Constants.h"
#import "CBStrings.h"
#import "FMDatabase.h"
@interface CBAddGasStationViewController ()
@end

NSString *selectGasName;

@implementation CBAddGasStationViewController
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
    frequentImg.hidden=YES;
    self.title = [[CBStrings sharedStrings] getPageTitle:@"GasPage"];
    [self setNavigationBar];
    arrGasStation = [[NSMutableArray alloc] init];
    selectGasName = nil;
    if ((NO == [[Constants sharedPath] isNetworkAvailable])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                            message:[[CBStrings sharedStrings] getAlertMessage:@"NoNetwork"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    locationManager = [[CLLocationManager alloc] init];
    [locationManager setDelegate:self];
    locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    locationManager.distanceFilter=kCLDistanceFilterNone;
    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
        NSUInteger code = [CLLocationManager authorizationStatus];
        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
            // choose one request according to your business.
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                [locationManager requestAlwaysAuthorization];
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
                [locationManager  requestWhenInUseAuthorization];
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
        }
    }
    [locationManager startUpdatingLocation];
    [self showProgressHud];
}
-(IBAction)SelectedButton:(UIButton *)sender{
    if(sender.tag == 0){
        frequentImg.hidden = NO;
        nearByImage.hidden = YES;
        
        }
    else{
        frequentImg .hidden = YES;
        nearByImage.hidden= NO;
    }
}
- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(goBack)];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectedGasStation)];
    self.navigationItem.leftBarButtonItem = cancelBtn;
    self.navigationItem.rightBarButtonItem = doneBtn;
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
    [btnDeveloper addTarget:self action:@selector(selectedGasStation) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)selectedGasStation {
    if (selectGasName != nil) {
        [[NSUserDefaults standardUserDefaults] setObject:selectGasName forKey:@"GasName"];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrGasStation count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSDictionary *gasDict = [arrGasStation objectAtIndex:indexPath.row];
    cell.textLabel.text = [gasDict objectForKey:@"name"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    cell.detailTextLabel.text = [gasDict objectForKey:@"vicinity"];
    cell.detailTextLabel.numberOfLines = 3;
    UIImage *image = [UIImage imageNamed:@"gas_station-50.png"];
    cell.imageView.image = image;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
    uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
    NSDictionary *gasDict = [arrGasStation objectAtIndex:indexPath.row];
    selectGasName = [gasDict objectForKey:@"name"];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
    uncheckCell.accessoryType = UITableViewCellAccessoryNone;
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
    [locationManager startUpdatingLocation];
}
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLLocation *currentLocation = newLocation;
    if (currentLocation != nil) {
        NSString *url = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/search/json?location=%f,%f&radius=%f&types=gas_station&sensor=true&key=%@", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude,[manager desiredAccuracy],kGOOGLE_API_KEY];
        NSURL *googleRequestURL=[NSURL URLWithString:url];
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        });
        NSLog(@"Radius %f URL %@",[manager desiredAccuracy],url);
    } else {
        [self hideProgressHud];
    }
}

- (void)fetchedData:(NSData *)responseData {
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    arrGasStation = [json objectForKey:@"results"];
    [tblGas reloadData];
    [self hideProgressHud];
}

#pragma mark - MBProgressHUD
- (void)showProgressHud {
    if (![_HUD isHidden]) {
        [_HUD removeFromSuperview];
        _HUD = nil;
    }
    _HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_HUD];
    _HUD.delegate = self;
    _HUD.square = YES;
    [_HUD show:YES];
}
- (void)hideProgressHud {
    [_HUD hide:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
