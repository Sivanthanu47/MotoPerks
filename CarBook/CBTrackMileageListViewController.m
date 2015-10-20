//
//  CBTrackMileageListViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 23/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBTrackMileageListViewController.h"
#import "CBTrackMileageAddViewController.h"
#import "CBTrackMileageViewController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "UIImage+Resize.h"

@interface CBTrackMileageListViewController ()
@end

@implementation CBTrackMileageListViewController
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
    self.title = [[CBStrings sharedStrings] getPageTitle:@"TrackPage"];
    [self setNavigationBar];
    searchbar.text =@"";
    arrTracks = [[NSMutableArray alloc] init];
    [arrTracks addObjectsFromArray:[[CBDBMethods sharedTools] getTracksDetail]];
    [tblTrack reloadData];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goNext {
    dispatch_async( dispatch_get_main_queue(), ^{
        UIViewController *viewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            viewController = [[CBTrackMileageAddViewController alloc] initWithNibName:@"CBTrackMileageAddViewController" bundle:nil];
        } else {
            viewController = [[CBTrackMileageAddViewController alloc] initWithNibName:@"CBTrackMileageAddViewController_iPad" bundle:nil];
        }
        [self.navigationController pushViewController:viewController animated:YES];
    });
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrTracks count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    NSMutableDictionary *trackDict = [arrTracks objectAtIndex:indexPath.row];
    cell.textLabel.text = [trackDict objectForKey:@"CarName"];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    NSString *TrackDate = [NSString stringWithFormat:@"%@",[trackDict objectForKey:@"TrackDate"]];
    NSDate *date = [NSDate date];
    NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init];
    [prefixDateFormatter setDateFormat:@"dd/MM/yyy"];
    date = [prefixDateFormatter dateFromString:TrackDate]; //enter yourdate
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
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Tracked on %@ %@ ",dateString,prefixDateString];
    cell.detailTextLabel.numberOfLines = 3;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    NSArray *paths = [[Constants sharedPath] getDocumentPath];
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[trackDict objectForKey:@"PhotoURL"]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    cell.imageView.image = [image thumbnailImage:48 transparentBorder:1 cornerRadius:3 interpolationQuality:kCGInterpolationDefault];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableDictionary *trackDict = [arrTracks objectAtIndex:indexPath.row];
    NSMutableArray *Track = [[NSMutableArray alloc] init];
    [Track addObjectsFromArray:[[CBDBMethods sharedTools] getCorrespondingTrackID:[trackDict objectForKey:@"TMId"] WithVehicle:nil]];
    CBTrackMileageViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBTrackMileageViewController alloc] initWithNibName:@"CBTrackMileageViewController" bundle:nil];
        viewController.isDeleteCheck= YES;
        viewController.arrTrack = Track;
    } else {
        viewController = [[CBTrackMileageViewController alloc] initWithNibName:@"CBTrackMileageViewController_iPad" bundle:nil];
        viewController.isDeleteCheck= YES;
        viewController.arrTrack = Track;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark - SearchBar Delegates
- (void)searchTableView {
    [arrTracks addObjectsFromArray:[[CBDBMethods sharedTools] searchingTrackMileageName:searchbar.text]];
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [arrTracks removeAllObjects];
    if ([[searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        [arrTracks addObjectsFromArray:[[CBDBMethods sharedTools] getTracksDetail]];
    } else if ([searchText length] > 0) {
        [self searchTableView];
    }
    [tblTrack reloadData];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchbar.text =@"";
    [arrTracks removeAllObjects];
    [arrTracks addObjectsFromArray:[[CBDBMethods sharedTools] getTracksDetail]];
    [tblTrack reloadData];
    [searchbar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchbar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
