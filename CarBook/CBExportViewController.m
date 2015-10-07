//
//  CBExportViewController.m
//  CarBook
//
//  Created by Raja T S Sekhar on 01/05/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBExportViewController.h"
#import "CBChosenVehicleViewController.h"
#import "CBChosenStationViewController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "AppDelegate.h"
#import "FMDatabase.h"
#import "CHCSVParser.h"

@interface CBExportViewController ()
@end

int chosenPanelSection = 0;

@implementation CBExportViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    arrReturnCsvFile = [[NSMutableArray alloc] init];
    getCarName = [[NSMutableArray alloc] init];
    arrSSDetails = [[NSMutableArray alloc]init];
    [getCarName addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    [arrSSDetails addObjectsFromArray:[[CBDBMethods sharedTools] getServiceStationDetails]];
    arrTrack = [[NSMutableArray alloc]init];
    [arrTrack addObjectsFromArray:[[CBDBMethods sharedTools]getTracksDetail]];
    firstSection = [NSArray arrayWithObjects:@"All", nil];
    secondSection = [NSArray arrayWithObjects:@"servicelist",@"Mileagelist", nil];
    thirdSection = [NSArray arrayWithObjects:@"servicelist",@"Mileagelist", nil];
    dbArray = [[NSMutableArray alloc]init];
    dbArray = [NSMutableArray arrayWithObjects:@"select * from tblVehicleDetails",@"select * from tblServiceStation",@"select * from tblTrackMileage",@"select * from tblServiceDetails",nil];
    self.title = [[CBStrings sharedStrings] getPageTitle:@"ExportPage"];
    [self setNavigationBar];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
        return @"ALL";
    if (section == 1)
        return @"VehicleWise";
    return @"StationWise";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return [firstSection count];
    }
    else if (section == 1){
        return [secondSection count];
    }
    return [thirdSection count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[firstSection objectAtIndex:indexPath.row]];
        cell.detailTextLabel.text = @"Vehicles Mileages Stations Services";
        cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    else if (indexPath.section == 1){
        if (getCarName.count > 1 ) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[secondSection objectAtIndex:indexPath.row]];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
        }
    }
    else{
        if (arrSSDetails.count > 0) {
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            cell.textLabel.text = [NSString stringWithFormat:@"%@",[thirdSection objectAtIndex:indexPath.row]];
            cell.textLabel.font = [UIFont boldSystemFontOfSize:20.0];
        }
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CBChosenVehicleViewController * viewController;
    NSMutableDictionary *vehicleDict = [getCarName objectAtIndex:indexPath.row];
    NSMutableDictionary *MileageDict = [arrTrack objectAtIndex:indexPath.row];
    if (indexPath.section == 0) {
        arrReturnCsvFile = [[CBDBMethods sharedTools] exportVehicleDetailsWithSelectTable:dbArray];
        NSLog(@"csvFilePath %@",arrReturnCsvFile);
       [self Export];
    }
    else if (indexPath.section == 1){
        if (indexPath.row==0) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                viewController = [[CBChosenVehicleViewController alloc] initWithNibName:@"CBChosenVehicleViewController" bundle:nil];
                viewController.vehicleServiceId = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"VDId"]];
            }else {
                viewController = [[CBChosenVehicleViewController alloc] initWithNibName:@"CBChosenVehicleViewController_iPad" bundle:nil];
                viewController.vehicleServiceId = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"VDId"]];
            }
        }
        else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                viewController = [[CBChosenVehicleViewController alloc] initWithNibName:@"CBChosenVehicleViewController" bundle:nil];
                viewController.vehicleMileageId = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"VDId"]];
            }else {
                viewController = [[CBChosenVehicleViewController alloc] initWithNibName:@"CBChosenVehicleViewController_iPad" bundle:nil];
                viewController.vehicleMileageId = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"VDId"]];
            }
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else{
        if (indexPath.row==0) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                viewController = [[CBChosenVehicleViewController alloc] initWithNibName:@"CBChosenVehicleViewController" bundle:nil];
                viewController.stationServiceId = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"SSId"]];
            }else {
                viewController = [[CBChosenVehicleViewController alloc] initWithNibName:@"CBChosenVehicleViewController_iPad" bundle:nil];
                viewController.stationServiceId = [NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"SSId"]];
            }
        }
        else{
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                viewController = [[CBChosenVehicleViewController alloc] initWithNibName:@"CBChosenVehicleViewController" bundle:nil];
                viewController.stationMileageId = [NSString stringWithFormat:@"%@",[MileageDict objectForKey:@"TMId"]];
            }else {
                viewController = [[CBChosenVehicleViewController alloc] initWithNibName:@"CBChosenVehicleViewController_iPad" bundle:nil];
                viewController.stationMileageId = [NSString stringWithFormat:@"%@",[MileageDict objectForKey:@"TMId"]];
            }
        }
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
-(void)Export{
    if ([MFMailComposeViewController canSendMail]) {
        NSArray *sendTo = [NSArray arrayWithObject:@"siva@agaramsystems.com"];
        MFMailComposeViewController *mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Order CSV"];
        [mailViewController setMessageBody:@"Your message goes here." isHTML:NO];
        [mailViewController setToRecipients:sendTo];
        for (NSString *csvFilePath in arrReturnCsvFile) {
            [mailViewController addAttachmentData:[NSData dataWithContentsOfFile:csvFilePath]
                                         mimeType:@"text/csv"
                                         fileName:@"Orderlist.csv"];
        }
        [self presentViewController:mailViewController animated:YES completion:nil];
    } else {
        NSLog(@"Device is unable to send email in its current state.");
        UIAlertView *message = [[UIAlertView alloc]
                                initWithTitle:@"Failed to Send Mail!"
                                message:@"Please make sure that you have logged in to the Mail."
                                delegate:nil
                                cancelButtonTitle:@"OK"
                                otherButtonTitles:nil];
        [message show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Result: canceled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Result: saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Result: sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Result: failed");
            break;
        default:
            NSLog(@"Result: not sent");
            break;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}
@end
