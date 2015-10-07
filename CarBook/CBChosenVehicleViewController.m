//
//  CBChosenVehicleViewController.m
//  CarBook
//
//  Created by Raja T S Sekhar on 08/05/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBChosenVehicleViewController.h"
#import "CBDBMethods.h"
#import "UIImage+Resize.h"
#import "NSDate+TimeAgo.h"

@interface CBChosenVehicleViewController ()

@end

@implementation CBChosenVehicleViewController
@synthesize _strVINID;
- (void)viewDidLoad {
    [super viewDidLoad];
    getCarName = [[NSMutableArray alloc] init];
    [getCarName addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    arrReturnCsvFile = [[NSMutableArray alloc] init];
    _arrTrack = [[NSMutableArray alloc]init];
    [_arrTrack addObjectsFromArray:[[CBDBMethods sharedTools]getTracksDetail]];
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
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [getCarName count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (_stationServiceId)  {
        NSMutableDictionary *vehicleDict = [getCarName objectAtIndex:indexPath.row];
        cell.textLabel.text = [vehicleDict objectForKey:@"StationName"];
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"LastServiceDate"]];
    }
    else if (_stationMileageId){
        NSMutableDictionary *vehicleDict = [_arrTrack objectAtIndex:indexPath.row];
        cell.textLabel.text = [vehicleDict objectForKey:@"stationName"];
        cell.detailTextLabel.text =[NSString stringWithFormat:@"%@",[vehicleDict objectForKey:@"TrackDate"]];
    }
    else{
        NSMutableDictionary *vehicleDict = [getCarName objectAtIndex:indexPath.row];
        cell.textLabel.text = [vehicleDict objectForKey:@"CarName"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n%@",[vehicleDict objectForKey:@"StationName"],[vehicleDict objectForKey:@"LastServiceDate"]];
        cell.detailTextLabel.numberOfLines = 3;
        NSArray *paths = [[Constants sharedPath] getDocumentPath];
        NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[vehicleDict objectForKey:@"PhotoURL"]];
        UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
        cell.imageView.image = [image thumbnailImage:48 transparentBorder:1 cornerRadius:3 interpolationQuality:kCGInterpolationDefault];
        cell.textLabel.textColor =[ UIColor whiteColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
    uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
    if (_vehicleServiceId) {
        NSString * strVehstaQuery = [NSString stringWithFormat:@"select * from tblServiceDetails WHERE VDId = %@ order by SDId Desc",_vehicleServiceId];
        NSMutableArray * strVehStaArrayQuery = [NSMutableArray arrayWithObject:strVehstaQuery];
        arrReturnCsvFile = [[CBDBMethods sharedTools] exportVehicleDetailsWithSelectTable:strVehStaArrayQuery];
        NSLog(@"csvFilePath %@",arrReturnCsvFile);
    }
    else if (_vehicleMileageId){
        NSString * strVehMilQuery = [NSString stringWithFormat:@"select * from tblTrackMileage WHERE VDId = %@",_vehicleMileageId];
        NSMutableArray * arrayQuery = [NSMutableArray arrayWithObject:strVehMilQuery];
        arrReturnCsvFile = [[CBDBMethods sharedTools] exportVehicleDetailsWithSelectTable:arrayQuery];
        NSLog(@"csvFilePath %@",arrReturnCsvFile);
    }
    else if (_stationServiceId){
        NSString * strStaSerQuery = [NSString stringWithFormat:@"select * from tblServiceDetails WHERE SSId = %@",_stationServiceId];
        NSMutableArray * staArrayQuery = [NSMutableArray arrayWithObject:strStaSerQuery];
        arrReturnCsvFile = [[CBDBMethods sharedTools] exportVehicleDetailsWithSelectTable:staArrayQuery];
        NSLog(@"csvFilePath %@",arrReturnCsvFile);
    }
    else{
        NSString * strStaMilQuery = [NSString stringWithFormat:@"select * from tblTrackMileage WHERE TMId = ? %@",_stationMileageId];
        NSMutableArray * staArrayQuery = [NSMutableArray arrayWithObject:strStaMilQuery];
        arrReturnCsvFile = [[CBDBMethods sharedTools] exportVehicleDetailsWithSelectTable:staArrayQuery];
        NSLog(@"csvFilePath %@",arrReturnCsvFile);
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
    uncheckCell.accessoryType = UITableViewCellAccessoryNone;
}
-(IBAction)Export:(id)sender{
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
