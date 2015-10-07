//
//  CBVehicleServiceDetailViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 11/02/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBVehicleServiceDetailViewController.h"
#import "CustomCell.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "UIImage+Resize.h"

NSInteger indexpathRow;
int intTotalCost,selectServiceIndex = 0;
NSString *selectType,*currentDate,*strCost,*strNote;
NSMutableDictionary *ServiceDict;
UIView *dateView;

@interface CBVehicleServiceDetailViewController ()
@end

@implementation CBVehicleServiceDetailViewController
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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(ShowKeyBoard:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    self.title = [[CBStrings sharedStrings] getPageTitle:@"ServiceDetailsPage"];
    arrCar = [[NSMutableArray alloc] init];
    arrType = [[NSMutableArray alloc] initWithObjects:@"Repair",@"Washing",@"Others", nil];
    arrNotifi = [[NSMutableArray alloc] init];
    [arrNotifi addObjectsFromArray:[[CBDBMethods sharedTools] getNotificationDetail:_VehicleID]];
    [arrCar addObjectsFromArray:[[CBDBMethods sharedTools] getSingleVehicleDetail:_VehicleID]];
    [self setNavigationBar];
    [self customViewCreate];
    [self tableViewReload];
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
-(void)tableViewReload {
    intTotalCost = 0;
    selectType = @"Select Type";
    strNote = @"";
    strCost = @"";
    arrService = [[NSMutableArray alloc] init];
    [arrService addObjectsFromArray:[[CBDBMethods sharedTools] getCorrespondingServiceLog:_VehicleID]];
    for (NSDictionary *Dict in arrService) {
        intTotalCost = intTotalCost + [[Dict objectForKey:@"Cost"] integerValue];
    }
    tblService.contentInset = UIEdgeInsetsZero;
    [tblService reloadData];
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblRepair) {
        return 50.0;
    }
    if (indexPath.row == 0) {
        return 130.0;
    }
    return 180;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblRepair) {
        return [arrType count];
    }
    int count = [arrService count];
    return count + 2;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *repairCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView == tblRepair) {
        if (repairCell == nil) {
            repairCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        [repairCell setAccessoryType:UITableViewCellAccessoryNone];
        repairCell.textLabel.text = [NSString stringWithFormat:@"%@",[arrType objectAtIndex:indexPath.row]];
    } else {
        CustomCell *cellMain = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        CustomCell *cellAdd = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        CustomCell *cellView = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cellMain == nil) {
            NSArray *nib;
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            } else {
                nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_iPad" owner:self options:nil];
            }
            cellMain = (CustomCell *)[nib objectAtIndex:0];
            cellAdd = (CustomCell *)[nib objectAtIndex:1];
            cellView = (CustomCell *)[nib objectAtIndex:2];
            [cellMain setSelectionStyle:UITableViewCellSelectionStyleNone];
            cellMain.textLabel.textColor = [UIColor whiteColor];
        }
        if (indexPath.row == 0) {
            NSMutableDictionary *carDict = [arrCar objectAtIndex:indexPath.row];
            cellMain.carlbl.text = [NSString stringWithFormat:@"%@",[carDict objectForKey:@"CarName"]];
            cellMain.stationlbl.text = [NSString stringWithFormat:@"%@",[carDict objectForKey:@"StationName"]];
            if (intTotalCost == 0) {
                cellMain.totcatlbl.hidden = YES;
            } else {
                cellMain.totcatlbl.hidden = NO;
                cellMain.totcatlbl.text = [NSString stringWithFormat:@"Total Cost: %d",intTotalCost];
            }
            return cellMain;
        } else if (indexPath.row == 1) {
            cellAdd.txtNote.delegate = self;
            cellAdd.txtNote.text = strNote;
            [cellAdd.txtNote.layer setBorderColor:[[UIColor grayColor] CGColor]];
            [cellAdd.txtNote.layer setBorderWidth:1.0];
            cellAdd.txtCost.delegate = self;
            cellAdd.txtCost.text = strCost;
            cellAdd.txtCost.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [cellAdd.txtCost addTarget:self action:@selector(getCostFromTextField:) forControlEvents:UIControlEventEditingChanged];
            NSDateFormatter *df = [[NSDateFormatter alloc] init];
            [df setDateFormat:DATEFORMAT];
            cellAdd.datelbl.text = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
            currentDate = [NSString stringWithFormat:@"%@",[df stringFromDate:[NSDate date]]];
            [cellAdd.btnAdd addTarget:self action:@selector(saveServiceDetails) forControlEvents:UIControlEventTouchUpInside];
            [cellAdd.btnType addTarget:self action:@selector(showCustomView) forControlEvents:UIControlEventTouchUpInside];
            [cellAdd.btnType setTitle:selectType forState:UIControlStateNormal];
            return cellAdd;
        } else {
            NSUInteger indexRow;
            indexRow = indexPath.row - 2;
            NSMutableDictionary *Dict = [arrService objectAtIndex:indexRow];
            cellView.typelbl.text = [NSString stringWithFormat:@"%d. %@",indexRow + 1,[Dict objectForKey:@"TypeOfService"]];
            cellView.txtNoteLbl.text = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"Note"]];
            cellView.costlbl.text = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"Cost"]];
            cellView.datelbl.text = [NSString stringWithFormat:@"%@",[Dict objectForKey:@"Date"]];
            cellView.btnDelete.tag = indexRow;
            [cellView.btnDelete addTarget:self action:@selector(deleteServiceType:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cellView;
    }
    return repairCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblRepair) {
        UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectServiceIndex = indexPath.row;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SelectServiceType"];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblRepair) {
        UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
}
- (void)saveServiceDetails {
    NSMutableDictionary *dictVehicle = [arrCar lastObject];
    NSMutableArray *key = [[NSMutableArray alloc] initWithObjects:@"TypeOfService",@"Note",@"Cost",@"CarName",@"Date",@"StationName",@"TravelKM",@"ServiceInterval",@"SSId",@"VDId", nil];
    NSMutableArray *value = [[NSMutableArray alloc] initWithObjects:selectType,strNote,strCost,[dictVehicle objectForKey:@"CarName"],currentDate,[dictVehicle objectForKey:@"StationName"],[dictVehicle objectForKey:@"TravelKM"],[dictVehicle objectForKey:@"ServiceInterval"],[dictVehicle objectForKey:@"SSId"],[dictVehicle objectForKey:@"VDId"], nil];
    __block BOOL isNull = NO;
    [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ((obj == nil) || [obj isEqualToString:@""]) {
            *stop = YES;
            isNull = YES;
        }
    }];
    if (isNull == YES) {
        UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"NoText"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [errAlert show];
        return;
    }
    ServiceDict = [[NSMutableDictionary alloc] initWithObjects:value forKeys:key];
    [[CBDBMethods sharedTools] inserServiceLog:ServiceDict];
    
    NSString *notiDate = [[Constants sharedPath] getNextServiceDate:[ServiceDict objectForKey:@"Date"] withMonth:[dictVehicle objectForKey:@"ServiceInterval"]];
    [ServiceDict setObject:notiDate forKey:@"NextServiceDate"];
    if ([arrNotifi count] > 0) {
        [[CBDBMethods sharedTools] updateLocalNotification:ServiceDict];
    } else {
        [[CBDBMethods sharedTools] insertNotification:ServiceDict];
    }
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                       message:[[CBStrings sharedStrings] getAlertMessage:@"AddServiceDetail"]
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    addAlert.title = @"AddService";
    [addAlert show];
}
- (IBAction)deleteServiceType:(UIButton *)sender {
    indexpathRow = sender.tag;
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                          message:[[CBStrings sharedStrings] getAlertMessage:@"DeleteServiceType"]
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
    deleteAlert.title = @"Delete";
    [deleteAlert show];
}
- (void)getCostFromTextField:(UITextField *)textField {
    strCost = [NSString stringWithFormat:@"%@",textField.text];
}
- (void)showCustomView {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SelectServiceType"];
    dateView.hidden = TRUE;
    [dateView addSubview:tblRepair];
    [self.view addSubview:dateView];
    dateView.hidden = FALSE;
    [tblRepair reloadData];
}
- (void)selectRepairType {
    BOOL selectRepair = [[NSUserDefaults standardUserDefaults] boolForKey:@"SelectServiceType"];
    if (selectRepair) {
        selectType = [NSString stringWithFormat:@"%@",[arrType objectAtIndex:selectServiceIndex]];
        [tblService reloadData];
    }
    dateView.hidden = TRUE;
}
- (IBAction)hiddenCustomView {
    dateView.hidden = TRUE;
}
- (void)customViewCreate {
    tblRepair = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 216)];
    tblRepair.delegate = self;
    tblRepair.dataSource = self;
    dateView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + 216)), self.view.frame.size.width, (self.navigationController.navigationBar.frame.size.height + 216))];
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hiddenCustomView)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectRepairType)];
    [pickerDateToolbar setItems:@[cancelBtn,flexSpace,doneBtn] animated:NO];
    [dateView addSubview:pickerDateToolbar];
    tblRepair.backgroundColor = [UIColor whiteColor];
}

#pragma mark- TextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    dateView.hidden = TRUE;
    return YES;
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    dateView.hidden = TRUE;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        tblService.contentOffset = CGPointMake(0, ((self.view.frame.size.height - tblService.frame.size.height)));
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    strNote = [NSString stringWithFormat:@"%@",textView.text];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - KeyBoardDelegate
- (void) ShowKeyBoard:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbRect.size.height), 0.0);
    tblService.contentInset = contentInsets;
}

#pragma mark - MailComposer
- (void)displayMailComposerSheet {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
        mc.mailComposeDelegate = self;
        [mc setSubject:[[CBStrings sharedStrings] getString:@"app_name"]];
        [mc setMessageBody:[NSString stringWithFormat:@"Type of Service : %@\nCar Name : %@\nStation Name : %@\nNext Service Date : %@\nCost : %@\nNote : %@",[ServiceDict objectForKey:@"TypeOfService"],[ServiceDict objectForKey:@"CarName"],[ServiceDict objectForKey:@"StationName"],[ServiceDict objectForKey:@"NextServiceDate"],[ServiceDict objectForKey:@"Cost"],[ServiceDict objectForKey:@"Note"]] isHTML:NO];
        [self presentViewController:mc animated:YES completion:NULL];
    } else {
        UIAlertView *errMessage = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                             message:[[CBStrings sharedStrings] getString:@"alertMailComposer"]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errMessage show];
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - MessageComposer
- (void)displaySMSComposerSheet {
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *mc = [[MFMessageComposeViewController alloc] init];
        mc.messageComposeDelegate = self;
        [mc setSubject:[[CBStrings sharedStrings] getString:@"app_name"]];
        [mc setBody:[NSString stringWithFormat:@"Type of Service : %@\nCar Name : %@\nStation Name : %@\nNext Service Date : %@\nCost : %@\nNote : %@",[ServiceDict objectForKey:@"TypeOfService"],[ServiceDict objectForKey:@"CarName"],[ServiceDict objectForKey:@"StationName"],[ServiceDict objectForKey:@"NextServiceDate"],[ServiceDict objectForKey:@"Cost"],[ServiceDict objectForKey:@"Note"]]];
        [self presentViewController:mc animated:YES completion:NULL];
    } else {
        UIAlertView *errMessage = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                             message:[[CBStrings sharedStrings] getString:@"alertMessageComposer"]
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
        [errMessage show];
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            NSLog(@"SMS cancelled");
            break;
        case MessageComposeResultSent:
            NSLog(@"SMS Sent");
            break;
        case MessageComposeResultFailed:
            NSLog(@"SMS Failed");
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"Delete"]) {
        if (buttonIndex == 1) {
            NSDictionary *serDict = [arrService objectAtIndex:indexpathRow];
            [[CBDBMethods sharedTools] deleteServiceLog:[serDict objectForKey:@"SDId"]];
        } else {
            return;
        }
    }
    [self tableViewReload];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[Constants sharedPath] setLocalNotification];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
