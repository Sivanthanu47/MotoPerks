//
//  CBVechileViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 05/11/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBVehicleViewController.h"
#import "CBAddVehicleFirstViewController.h"
#import "CBVehicleDetailsViewController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "UIImage+Resize.h"
#import "NSDate+TimeAgo.h"
@interface CBVehicleViewController ()

@end

@implementation CBVehicleViewController

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
    self.title = [[CBStrings sharedStrings] getPageTitle:@"HomePage"];
    [self setNavigationBar];
    searchbar.text =nil;
    getCarName = [[NSMutableArray alloc] init];
    [getCarName addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    [tblCar reloadData];
}
- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(goNext)];
    self.navigationItem.rightBarButtonItem = addButton;
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
    CGRect frameimgdeveloper = CGRectMake(0, 0, 80, 27);
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:frameimgdeveloper];
    [btnDeveloper setTitle:@"Add" forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goNext) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleMainViewController alloc] initWithNibName:@"CBVehicleMainViewController" bundle:nil];
    } else {
        viewController = [[CBVehicleMainViewController alloc] initWithNibName:@"CCBVehicleMainViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)goNext {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBAddVehicleFirstViewController alloc] initWithNibName:@"CBAddVehicleFirstViewController" bundle:nil];
    } else {
        viewController = [[CBAddVehicleFirstViewController alloc] initWithNibName:@"CBAddVehicleFirstViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
-(void)setDateFormat{
    NSDate *date = [NSDate date];
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setDateFormat:@"yyy-dd-MM"];
    date = [prefixDateFormatter dateFromString:@"2014-6-03"]; //enter yourdate
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@"EEEE MMMM d"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:date] intValue];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    NSString *dateString = [prefixDateString stringByAppendingString:suffix];
    NSLog(@"%@", dateString);
}
#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [getCarName count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    NSMutableDictionary *vehicleDict = [getCarName objectAtIndex:indexPath.row];
    [[NSUserDefaults standardUserDefaults]setValue:vehicleDict forKey:@"dict"];
    cell.textLabel.text = [vehicleDict objectForKey:@"CarName"];
    NSString *LastServiceDate = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"LastServiceDate"]];
    NSDate *date = [NSDate date];
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setDateFormat:@"dd/MM/yyy"];
    date = [prefixDateFormatter dateFromString:LastServiceDate]; //enter yourdate
    [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [prefixDateFormatter setDateFormat:@" MMMM yyy"];
    NSString *prefixDateString = [prefixDateFormatter stringFromDate:date];
    NSDateFormatter *monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
    [monthDayFormatter setDateFormat:@"d"];
    int date_day = [[monthDayFormatter stringFromDate:date] intValue];
    NSString * dateStr = [NSString stringWithFormat:@"%d",date_day];
    NSString *suffix_string = @"|st|nd|rd|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|th|st|nd|rd|th|th|th|th|th|th|th|st";
    NSArray *suffixes = [suffix_string componentsSeparatedByString: @"|"];
    NSString *suffix = [suffixes objectAtIndex:date_day];
    NSString *dateString = [dateStr stringByAppendingString:suffix];
   cell.detailTextLabel.text = [NSString stringWithFormat:@"Recentltly serviced on %@ %@ ",dateString,prefixDateString];
    cell.detailTextLabel.numberOfLines = 3;
    NSString *nextdate = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"NextServiceDate"]];
    NSDate *callDate = [[NSDate alloc] init];
    NSString *calculateDays = [callDate calculateNSDate:nextdate];
    if ([calculateDays integerValue] <= 2) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Red.png"]];
    } else if (([calculateDays integerValue] >= 3) && ([calculateDays integerValue] <= 7)) {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Yellow.png"]];
    }else {
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Green.png"]];
    }
    NSArray *paths = [[Constants sharedPath] getDocumentPath];
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[vehicleDict objectForKey:@"PhotoURL"]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageView.image = [image thumbnailImage:48 transparentBorder:1 cornerRadius:3 interpolationQuality:kCGInterpolationDefault];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor blackColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *vehicleDict = [getCarName objectAtIndex:indexPath.row];
    CBVehicleDetailsViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleDetailsViewController alloc] initWithNibName:@"CBVehicleDetailsViewController" bundle:nil];
        } else {
        viewController = [[CBVehicleDetailsViewController alloc] initWithNibName:@"CBVehicleDetailsViewController_iPad" bundle:nil];
       }
    viewController.strVehicleID = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"VDId"]];
    viewController.strVehicleName = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"CarName"]];
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - SearchBar Delegates
- (void)searchTableView {
    [getCarName addObjectsFromArray:[[CBDBMethods sharedTools] searchingVehicleName:searchbar.text]];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [getCarName removeAllObjects];
    if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        [getCarName addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    } else if ([searchText length] > 0) {
        [self searchTableView];
    }
    [tblCar reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchbar.text =@"";
    [getCarName removeAllObjects];
    [getCarName addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    [tblCar reloadData];
    [searchbar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchbar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
