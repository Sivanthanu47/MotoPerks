//
//  CBVehicleDetailsViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 22/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBVehicleDetailsViewController.h"
#import "CBTrackMileageViewController.h"
#import "CBVehicleEditViewController.h"
#import "CBVehicleServiceStationLogController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "Constants.h"

@interface CBVehicleDetailsViewController ()
@end

@implementation CBVehicleDetailsViewController

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
    self.title = [_strVehicleName capitalizedString];
    [self setNavigationBar];
    [self loadView];
    arrVehData = [[NSMutableArray alloc] init];
    arrServiceLog = [[NSMutableArray alloc] init];
    [arrVehData addObjectsFromArray:[[CBDBMethods sharedTools] getSingleVehicleDetail:_strVehicleID]];
    [arrServiceLog addObjectsFromArray:[[CBDBMethods sharedTools] getCorrespondingServiceLog:_strVehicleID]];
    [tblVehicle reloadData];
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
    [btnDeveloper setTitle:@"Edit" forState:UIControlStateNormal];
    [btnDeveloper setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goToEditView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goToEditView {
    CBVehicleEditViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleEditViewController alloc] initWithNibName:@"CBVehicleEditViewController" bundle:nil];
        viewController.editDict = [arrVehData lastObject];
    } else {
        viewController = [[CBVehicleEditViewController alloc] initWithNibName:@"CBVehicleEditViewController_iPad" bundle:nil];
        viewController.editDict = [arrVehData lastObject];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 120;
    }
    if (indexPath.section == 4) {
        return 60;
    }
    return 50;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        if (indexPath.section == 0) {
            [cell setAccessoryType:UITableViewCellAccessoryNone];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSMutableDictionary *dict = [arrVehData objectAtIndex:indexPath.row];
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(tblVehicle.frame.size.width/1.5, cell.frame.origin.y+5, tblVehicle.frame.size.width/3.2, cell.frame.size.height*2.5)];
            [imgView.layer setCornerRadius:5.0];
            [imgView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
            [imgView.layer setBorderWidth:1.0];
            NSArray *paths = [[Constants sharedPath] getDocumentPath];
            NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[dict objectForKey:@"PhotoURL"]];
            UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
            imgView.image = image;
            [imgView setContentMode:UIViewContentModeScaleAspectFit];
            [cell addSubview:imgView];
            cell.textLabel.text = [NSString stringWithFormat:@"%@\n%@",[dict objectForKey:@"Owner"],[dict objectForKey:@"InsuranceDate"]];
            cell.textLabel.numberOfLines = 3;
        }
        if (indexPath.section == 1) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSMutableDictionary *dict = [arrVehData objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"Last Date: %@",[dict objectForKey:@"LastServiceDate"]];
            cell.textLabel.numberOfLines = 2;
        }
        if (indexPath.section == 2) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.text = @"Mileage";
            cell.textLabel.textColor = [UIColor blueColor];
        }
        if (indexPath.section == 3) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.text = @"Station";
            cell.textLabel.textColor = [UIColor blueColor];
        }
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        cell.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Owner Details";
    }
    if (section == 1) {
        return @"Service Date";
    }
    if (section == 2) {
        return @"Track Mileage";
    }
    return @"Service Station";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
    v.backgroundView.backgroundColor = [UIColor whiteColor];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        NSMutableDictionary *trackDict = [arrVehData objectAtIndex:indexPath.row];
        NSMutableArray *Track = [[NSMutableArray alloc] init];
        [Track addObjectsFromArray:[[CBDBMethods sharedTools] getCorrespondingTrackID:nil WithVehicle:[trackDict objectForKey:@"VDId"]]];
        if ([Track count] <= 0 ) {
            UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                               message:[[CBStrings sharedStrings] getAlertMessage:@"emptyTrack"]
                                                              delegate:nil
                                                     cancelButtonTitle:@"OK"
                                                     otherButtonTitles:nil];
            [addAlert show];
            return;
        }
        CBTrackMileageViewController *viewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            viewController = [[CBTrackMileageViewController alloc] initWithNibName:@"CBTrackMileageViewController" bundle:nil];
            viewController.isDeleteCheck = NO;
            viewController.arrTrack = Track;
        } else {
            viewController = [[CBTrackMileageViewController alloc] initWithNibName:@"CBTrackMileageViewController_iPad" bundle:nil];
            viewController.isDeleteCheck = NO;
            viewController.arrTrack = Track;
        }
        [self.navigationController pushViewController:viewController animated:YES];
    } else if (indexPath.section == 3) {
        NSMutableDictionary *trackDict = [arrVehData objectAtIndex:indexPath.row];
        CBVehicleServiceStationLogController *viewController;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            viewController = [[CBVehicleServiceStationLogController alloc] initWithNibName:@"CBVehicleServiceStationLogController" bundle:nil];
            viewController.strVINID = [trackDict objectForKey:@"VIN"];
        } else {
            viewController = [[CBVehicleServiceStationLogController alloc] initWithNibName:@"CBVehicleServiceStationLogController_iPad" bundle:nil];
            viewController.strVINID = [trackDict objectForKey:@"VIN"];
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
- (IBAction)deleteVehicle:(id)sender {
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                          message:[[CBStrings sharedStrings] getAlertMessage:@"deleteVehicle"]
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes",nil];
    [deleteAlert show];
}

#pragma mark - AlertViewDelegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSMutableDictionary *dict = [arrVehData objectAtIndex:0];
        [[CBDBMethods sharedTools] deleteVehicle:[dict objectForKey:@"VDId"]];
        [self goBack];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
        [[Constants sharedPath] setLocalNotification];
        [self removeImage:[dict objectForKey:@"PhotoURL"]];
    }
}
- (void)removeImage:(NSString *)fileName {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = [[Constants sharedPath] getDocumentPath];
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileName];
    NSError *error;
    BOOL success = [fileManager removeItemAtPath:filePath error:&error];
    if (success) {
        UIAlertView *removeSuccessFulAlert=[[UIAlertView alloc]initWithTitle:@"Congratulation:" message:@"Successfully removed" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [removeSuccessFulAlert show];
    }
    else {
        NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
