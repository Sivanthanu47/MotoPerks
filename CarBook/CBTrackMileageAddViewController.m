//
//  CBTrackMileageAddViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 23/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBTrackMileageAddViewController.h"
#import "CBAddGasStationViewController.h"
#import "CustomCell.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "CBSettingsViewController.h"
#import "CBTrackMileageListViewController.h"
#import "CBChosenStationViewController.h"
@interface CBTrackMileageAddViewController ()

@end
int diskm;
NSString * intOldkm;
UITextField *textField;
NSString *strStationName,*strTrackDate,*strTrackCar,*strCMRead,*strRate,*strQuantity,*strEditcost;
int intCuread = 0,intOldread = 0,intOldfuel = 0, customTblHeight = 0,selectCarIndex = 0,selectStationIndex = 0;
UIView *customView;
NSArray *cellNib;
CustomCell *cellView;
UITextView * alertTextView;

int ImgEdgeHieght;
int CellHeight,customRateViewHeight = 340;
@implementation CBTrackMileageAddViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    strKm = [NSString stringWithFormat:@"%d",diskm];
    intOldkm = [[NSUserDefaults standardUserDefaults]objectForKey:@"txtkm"];
}


- (void)viewWillAppear:(BOOL)animated {
    customTblHeight = 216;
    customRateViewHeight = 340;
    self.title = [[CBStrings sharedStrings] getPageTitle:@"TrackAddPage"];
    [self setNavigationBar];
    [self customViewCreate];
    arrCarData = [[NSMutableArray alloc] init];
    [arrCarData addObjectsFromArray:[[CBDBMethods sharedTools] getVehicleDetails]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        ImgEdgeHieght = (self.view.frame.size.width-52);
    } else {
        ImgEdgeHieght = (self.view.frame.size.width-76);
    }
    strStationName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"GasName"]];
    NSLog(@"Gas Name %@",strStationName);
    [tblTxtField reloadData];
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
    [btnDeveloper setTitle:@"Save" forState:UIControlStateNormal];
    [btnDeveloper setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(savedTrackDetails) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)goHome {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBTrackMileageListViewController alloc] initWithNibName:@"CBTrackMileageListViewController" bundle:nil];
    } else {
        viewController = [[CBTrackMileageListViewController alloc] initWithNibName:@"CBTrackMileageListViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];

}

- (IBAction)savedTrackDetails {
    NSMutableArray *key = [[NSMutableArray alloc] initWithObjects:@"Rate",@"Quantity",@"fuelCost",@"CMRead",@"CarName",@"StationName",@"TrackDate", nil];
    NSMutableArray *value = [[NSMutableArray alloc] initWithObjects:strRate,strQuantity,strEditcost,strCMRead,strTrackCar,strStationName,strTrackDate, nil];
    __block BOOL isNull = NO;
    [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@""] || (obj == nil)) {
            *stop = YES;
            isNull = YES;
        }
    }];
    if (isNull == YES || [key count] != [value count]) {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"NoText"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
        return;
    }
    if (intOldread >= [strCMRead integerValue]) {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"lowValue"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
        return;
    }
    
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                       message:[[CBStrings sharedStrings] getAlertMessage:@"AddTrack"]
                                                      delegate:self
                                             cancelButtonTitle:@"OK"
                                             otherButtonTitles:nil];
    [addAlert show];
    NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithObjects:value forKeys:key];
    [[CBDBMethods sharedTools] inserTrackDetails:Dict];
    [[NSUserDefaults standardUserDefaults]setObject:strCMRead forKey:@"CMRead"];
    [self goHome];
}


- (void)customViewCreate {
    tblcar = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, customTblHeight)];
    tblcar.delegate = self;
    tblcar.dataSource = self;
    tblcar.backgroundColor = [UIColor whiteColor];
    customView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + customTblHeight)), self.view.frame.size.width, (self.navigationController.navigationBar.frame.size.height + customTblHeight))];
    
}
- (IBAction)showCarList {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SelectCarTrack"];
    [textField resignFirstResponder];
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hiddenCustomView)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(selectedCarName)];
    [pickerDateToolbar setItems:@[cancelBtn,flexSpace,doneBtn] animated:NO];
    [customView addSubview:pickerDateToolbar];
    customView.hidden = TRUE;
    [customView addSubview:tblcar];
    [self.view addSubview:customView];
    customView.hidden = FALSE;
    [tblcar reloadData];
}

- (IBAction)showStationList {
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBAddGasStationViewController alloc] initWithNibName:@"CBAddGasStationViewController" bundle:nil];
    } else {
        viewController = [[CBAddGasStationViewController alloc] initWithNibName:@"CBAddGasStationViewController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)hiddenCustomView {
    customView.hidden = TRUE;
}

- (void)selectedCarName {
    BOOL selectCar = [[NSUserDefaults standardUserDefaults] boolForKey:@"SelectCarTrack"];
    if (selectCar) {
        NSMutableDictionary *vehicleDict = [arrCarData objectAtIndex:selectCarIndex];
        strTrackCar = [vehicleDict objectForKey:@"CarName"];
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:DATEFORMAT];
        strTrackDate = [NSString stringWithFormat:@"%@",[DateFormatter stringFromDate:[NSDate date]]];
        [tblTxtField reloadData];
        customView.hidden = TRUE;
}
}
#pragma mark- TextFieldDelegates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)txtField {
    textField = txtField;
    [textField resignFirstResponder];
    customView.hidden = TRUE;
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)txtField {
    textField = txtField;
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *) txtField {
    if (textField.tag==1) {
        float rate = [cellView.txtRate.text intValue];
        float costvalue = [alertTextView.text floatValue];
        float quantityText = (rate/costvalue);
        strQuantity = [NSString stringWithFormat:@"%f",quantityText];
        cellView.txtQuantity.text =strQuantity;
        }
    else{
    float costvalue = [alertTextView.text floatValue];
    float quantity = [cellView.txtQuantity.text floatValue];
    int rateText = (quantity * costvalue);
    strRate = [NSString stringWithFormat:@"%d",rateText];
    cellView.txtRate.text = strRate;
    }
    textField = txtField;
    [textField resignFirstResponder];
    cellView = (CustomCell *)[cellNib objectAtIndex:5];
    textField = (UITextField *)[cellView viewWithTag:txtField.tag+1];
    [textField becomeFirstResponder];
    return YES;
}

#pragma mark- KeyboardDelegates

- (void) keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbRect.size.height), 0.0);
    tblTxtField.contentInset = contentInsets;
}

#pragma mark- tableViewDelegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the height of rows in the table view.
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblcar) {
        return 50.0;
    } else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            return 410.0;
        }
        return 525.0;
    }
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblcar) {
        return [arrCarData count];
    }
    return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView == tblcar){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        NSMutableDictionary *vehicleDict = [arrCarData objectAtIndex:indexPath.row];
        cell.textLabel.text = [vehicleDict objectForKey:@"CarName"];
    } else {
        cellView = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"TrackMileageCellIdentifier"];
        if (cellView == nil) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                cellNib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            } else {
                cellNib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_iPad" owner:self options:nil];
            }
        
            cellView = (CustomCell *)[cellNib objectAtIndex:5];
            [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }
        [cellView.btnTrackCar addTarget:self action:@selector(showCarList) forControlEvents:UIControlEventTouchUpInside];
        [cellView.btnTrackCar.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cellView.btnTrackCar.layer setBorderWidth:1.0];
        if (strTrackCar == nil || [strTrackCar isEqual:@"(null)"]) {
            [cellView.btnTrackCar setTitle:@"Car Name" forState:UIControlStateNormal];
        } else {
            [cellView.btnTrackCar setTitle:strTrackCar forState:UIControlStateNormal];
        }
        UIImage *imgDown = [UIImage imageNamed:@"arrow_down.png"];
        [cellView.btnTrackCar setImage:imgDown forState:UIControlStateNormal];
        [cellView.btnTrackCar setImageEdgeInsets:UIEdgeInsetsMake(0,ImgEdgeHieght,0,0)];
        
        [cellView.lblTrackDate.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cellView.lblTrackDate.layer setBorderWidth:1.0];
        if (strTrackDate == nil) {
            cellView.lblTrackDate.text = @"Current Date";
        } else {
            cellView.lblTrackDate.text = strTrackDate;
        }
        if (strStationName == nil ||[strStationName isEqual:@"(null)"]) {
            cellView.txtGasName.placeholder = @"Station Name";
        }
        else{
             cellView.txtGasName.text = strStationName;
        }
        [cellView.btnGasName addTarget:self action:@selector(showStationList) forControlEvents:UIControlEventTouchUpInside];
        [cellView.btnCost setTitle:@"1 Litre cost Rs. 60" forState:UIControlStateNormal];
        [cellView.btnCost addTarget:self action:@selector(showCost) forControlEvents:UIControlEventTouchUpInside];
        [cellView.btnRate addTarget:self action:@selector(showRate) forControlEvents:UIControlEventTouchUpInside];
        [cellView.btnQuantity addTarget:self action:@selector(showQuantity) forControlEvents:UIControlEventTouchUpInside];
        [cellView.txtGasName addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
        cellView.txtCMRead.delegate = self;
        [cellView.txtCMRead addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
        cellView.txtCMRead.placeholder  = @"Current KM Reading";
        cellView.txtRate.delegate = self;
        [cellView.txtRate addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
        cellView.txtRate.placeholder  = @"Rate";
        cellView.txtQuantity.delegate = self;
        [cellView.txtQuantity addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
        cellView.txtQuantity.placeholder  = @"Quantity";
        return cellView;
    }
    return cell;
}
-(void)showCost{
    alertTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 250, 60)];
    alertTextView.backgroundColor = [UIColor lightGrayColor];
    alertTextView.delegate = self;
    alertTextView.font = [UIFont boldSystemFontOfSize:16.0];
    alertTextView.textColor = [UIColor whiteColor];
    alertTextView.text = @"60";
   UIAlertView * editAlertView = [[UIAlertView alloc] initWithTitle:@"Edit Note" message:@"1 Litre Cost is Rs" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
    CGFloat system_version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (system_version < 7.0) {
        [editAlertView addSubview:alertTextView];
    } else {
        [editAlertView setValue:alertTextView forKey:@"accessoryView"];
    }
    [editAlertView show];
}
-(void)showRate{
    cellView.FirstarrImgView.hidden = NO;
    cellView.SectarrImgView.hidden = YES;
    cellView.txtQuantity.userInteractionEnabled =NO;
    cellView.txtRate.userInteractionEnabled =YES;

}
-(void)showQuantity{
    cellView.SectarrImgView.hidden = NO;
    cellView.FirstarrImgView.hidden = YES;
    cellView.txtRate.userInteractionEnabled =NO;
    cellView.txtQuantity.userInteractionEnabled =YES;

}
- (void)textFieldValueChanges:(UITextField *)txtField {
    if (txtField.tag == 1) {
        strRate = txtField.text;
   } else if (txtField.tag == 2) {
        strQuantity = txtField.text;
    } else if (txtField.tag == 3) {
        strCMRead = txtField.text;
    }
    else if(textField.tag == 4){
        strStationName =textField.text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblcar) {
        UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectCarIndex = indexPath.row;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SelectCarTrack"];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblcar) {
        UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
}

#pragma mark - AlertViewDelegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    strEditcost = [NSString stringWithFormat:@" 1 Litre Cost is Rs %@",alertTextView.text];
    [cellView.btnCost setTitle:strEditcost forState:UIControlStateNormal];
    NSLog(@"alertView %@",alertTextView.text);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
