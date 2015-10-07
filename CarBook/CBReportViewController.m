//
//  CBReportViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 25/02/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBReportViewController.h"
#import "LineChartViewController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "UIImage+Resize.h"

@interface CBReportViewController ()
@end

@implementation CBReportViewController
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
    self.title = [[CBStrings sharedStrings] getPageTitle:@"ReportPage"];
    [self setNavigationBar];
    searchbar.text =@"";
    arrReport = [[NSMutableArray alloc] init];
    [arrReport addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    [tblReport reloadData];
}
- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrReport count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSMutableDictionary *reportDict = [arrReport objectAtIndex:indexPath.row];
    cell.textLabel.text = [reportDict objectForKey:@"CarName"];
    NSString *LastServiceDate = [NSString stringWithFormat:@"%@",[reportDict objectForKey:@"LastServiceDate"]];
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Recentltly serviced on %@ %@ in %@",dateString,prefixDateString,[reportDict objectForKey:@"StationName"]];
    cell.detailTextLabel.numberOfLines = 3;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    NSArray *paths = [[Constants sharedPath] getDocumentPath];
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[reportDict objectForKey:@"PhotoURL"]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageView.image = [image thumbnailImage:48 transparentBorder:1 cornerRadius:3 interpolationQuality:kCGInterpolationDefault];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *chartDict = [arrReport objectAtIndex:indexPath.row];
    NSMutableArray *Track = [[NSMutableArray alloc] init];
    [Track addObjectsFromArray:[[CBDBMethods sharedTools] getCorrespondingTrackID:nil WithVehicle:[chartDict objectForKey:@"VDId"]]];
    if ([Track count] <= 0 ) {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"emptyTrack"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
        return;
    }
    LineChartViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[LineChartViewController alloc] initWithNibName:@"LineChartViewController" bundle:nil];
        viewController.vehiName = [chartDict objectForKey:@"CarName"];
        viewController.VehiID = [chartDict objectForKey:@"VDId"];
    } else {
        viewController = [[LineChartViewController alloc] initWithNibName:@"LineChartViewController_iPad" bundle:nil];
        viewController.vehiName = [chartDict objectForKey:@"CarName"];
        viewController.VehiID = [chartDict objectForKey:@"VDId"];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - SearchBar Delegates
- (void)searchTableView {
    [arrReport addObjectsFromArray:[[CBDBMethods sharedTools] searchingVehicleName:searchbar.text]];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [arrReport removeAllObjects];
    if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        [arrReport addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    } else if ([searchText length] > 0) {
        [self searchTableView];
    }
    [tblReport reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchbar.text =@"";
    [arrReport removeAllObjects];
    [arrReport addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    [tblReport reloadData];
    [searchbar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchbar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
