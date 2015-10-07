//
//  CBAddVehicleSecondViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 11/11/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 140.0

#import "CBAddVehicleSecondViewController.h"
#import "VehicleAddSecondCustomCell.h"
#import "CBVehicleServiceStationAddController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "Constants.h"
#import "CBServiceIntervalViewController.h"
#import "CBImageViewController.h"
#import "VehicleAddFirstCustomCell.h"
@interface CBAddVehicleSecondViewController ()
@end

UITextField *textField;
NSString *strLastSerDate,*strServiceMonthInterval,*strFirstService,*strServiceKmInterval;
NSString *fileformatName;
UIView *dateView;
int picAndTblHieght = 0,selectIndexRow = 0;
VehicleAddSecondCustomCell *cellView;
NSArray *cellNib;
int ImgEdgeHieght,chosEdgeBtnHieght;

@implementation CBAddVehicleSecondViewController
@synthesize addCarDetails;
@synthesize dictData;

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardDidShowNotification object:nil];
    [_datePicker setDatePickerMode:UIDatePickerModeDate];
    [_datePicker setDate:[NSDate date]];
    dictData = [[NSMutableDictionary alloc] init];
    

   }
- (void)viewWillAppear:(BOOL)animated {
    picAndTblHieght = 216;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        ImgEdgeHieght = (self.view.frame.size.width-52);
        chosEdgeBtnHieght = (self.view.frame.size.width-65);
    } else {
        ImgEdgeHieght = (self.view.frame.size.width-76);
        chosEdgeBtnHieght = (self.view.frame.size.width-95);
    }
    self.title = [[CBStrings sharedStrings] getPageTitle:@"AddVehiclePage"];
    [self setNavigationBar];
    [self customViewCreate];
    getSerDict = [[NSMutableDictionary alloc] init];
    dictNotif = [[NSMutableDictionary alloc] init];
    arrSerName = [[NSMutableArray alloc] init];
    arrSerName = [[CBDBMethods sharedTools] getServiceStationDetails];
    NSLog(@"dictData %lu",(unsigned long)dictData.count);
    
        [tblAddsecond reloadData];

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

#pragma mark- TextFieldDelegates
-(BOOL)textFieldShouldBeginEditing:(UITextField *)txtField {
   
    textField = txtField;
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    [textField resignFirstResponder];
    dateView.hidden = TRUE;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)txtField {
    textField = txtField;
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }

    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *) txtField {
    textField = txtField;
    [textField resignFirstResponder];
    cellView = (VehicleAddSecondCustomCell *)[cellNib lastObject];
    textField = (UITextField *)[cellView viewWithTag:txtField.tag+1];
    if(textField.returnKeyType != UIReturnKeyDone){
        [textField becomeFirstResponder];
    }
    return YES;
}
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}


-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    dateView.hidden = TRUE;
    if ([textView.text isEqualToString:@"Note"]) {
        textView.text = @"";
    }
    else if([textView.text isEqualToString:@"Address"]){
        textView.text = @"";

    }
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }

    [textView resignFirstResponder];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        tblAddsecond.contentOffset = CGPointMake(0, ((self.view.frame.size.height - tblAddsecond.frame.size.height)));
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Note";
    }
    else if ([textView.text isEqualToString:@""]){
        textView.text = @"Address";
    }
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }

    [textView resignFirstResponder];
    return YES;
}- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark - keyboardDelegate
- (void) keyboardShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbRect.size.height), 0.0);
    tblchoice.contentInset = contentInsets;
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblchoice) {
        return 40;
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 360;
    }
    return 415;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblchoice) {
        return [arrSerName count];
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView == tblchoice) {
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        }
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        NSMutableDictionary *SerNameDict = [arrSerName objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[SerNameDict objectForKey:@"stationName"]];
    } else {
        cellView = (VehicleAddSecondCustomCell *)[tableView dequeueReusableCellWithIdentifier:nil];
        if (cellView == nil) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                cellNib = [[NSBundle mainBundle] loadNibNamed:@"VehicleAddSecondCustomCell" owner:self options:nil];
            } else {
                cellNib = [[NSBundle mainBundle] loadNibNamed:@"VehicleAddSecondCustomCell_iPad" owner:self options:nil];
            }
            cellView = (VehicleAddSecondCustomCell *)[cellNib lastObject];
            [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        NSString *firstService = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"FirstService"]];

         [cellView.firstService setTitle:firstService forState:UIControlStateNormal];
        cellView.sellerName.delegate = self;
        if ([dictData objectForKey:@"Sellername"]) {
            cellView.sellerName.text = [dictData objectForKey:@"Sellername"];
        }
        cellView.txtAddress.delegate = self;
        if ([dictData objectForKey:@"ownerAddr"]) {
            cellView.txtAddress.text = [dictData objectForKey:@"ownerAddr"];
        }
        cellView.txtNote.delegate = self;
        if ([dictData objectForKey:@"Note"]) {
            cellView.txtNote.text = [dictData objectForKey:@"Note"];
        }
    
        strServiceKmInterval=[[NSUserDefaults standardUserDefaults]objectForKey:@"kmType"];
        strServiceMonthInterval=[[NSUserDefaults standardUserDefaults]objectForKey:@"monthType"];
        UIImage *img = [UIImage imageNamed:@"arrow_down.png"];
        cellView.txtNote.delegate = self;
        [cellView.txtNote.layer setBorderWidth:1.0];
        [cellView.txtNote.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        cellView.txtAddress.delegate = self;
        [cellView.txtAddress.layer setBorderWidth:1.0];
        [cellView.txtAddress.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        cellView.sellerName.delegate = self;
        [cellView.sellerName.layer setBorderWidth:1.0];
        [cellView.sellerName.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cellView.lastServiceDate.layer setBorderWidth:1.0];
        [cellView.lastServiceDate.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cellView.lastServiceDate addTarget:self action:@selector(showDatePicker) forControlEvents:UIControlEventTouchUpInside];
        [cellView.lastServiceDate setImage:img forState:UIControlStateNormal];
        [cellView.lastServiceDate setImageEdgeInsets:UIEdgeInsetsMake(0,ImgEdgeHieght,0,0)];
        [cellView.lastServiceDate setTitleEdgeInsets:UIEdgeInsetsMake(0,-(img.size.width - 5),0,0)];
        NSString *lastService = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"LastServiceDate"]];
        if (lastService == nil || [lastService isEqual:@"(null)"]) {
            [cellView.lastServiceDate setTitle:@"Last Service Date" forState:UIControlStateNormal];
        } else {
            [cellView.lastServiceDate setTitle:lastService forState:UIControlStateNormal];
        }
        [cellView.firstService.layer setBorderWidth:1.0];
        [cellView.firstService.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cellView.firstService addTarget:self action:@selector(showDate) forControlEvents:UIControlEventTouchUpInside];
        [cellView.firstService setImage:img forState:UIControlStateNormal];
        [cellView.firstService setImageEdgeInsets:UIEdgeInsetsMake(0,ImgEdgeHieght,0,0)];
        [cellView.firstService setTitleEdgeInsets:UIEdgeInsetsMake(0,-(img.size.width - 5),0,0)];
        if (firstService == nil || [firstService isEqual:@"(null)"]) {
            [cellView.firstService setTitle:@"First Service Date" forState:UIControlStateNormal];
        } else {
            [cellView.firstService setTitle:firstService forState:UIControlStateNormal];
        }

        [cellView.SerKmInt.layer setBorderWidth:1.0];
        [cellView.SerKmInt.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cellView.SerKmInt addTarget:self action:@selector(ServicePage) forControlEvents:UIControlEventTouchUpInside];
        [cellView.SerKmInt setImage:img forState:UIControlStateNormal];
        [cellView.SerKmInt setImageEdgeInsets:UIEdgeInsetsMake(0,ImgEdgeHieght,0,0)];
        [cellView.SerKmInt setTitleEdgeInsets:UIEdgeInsetsMake(0,-(img.size.width - 5),0,0)];
        
        [cellView.serMonthInterval.layer setBorderWidth:1.0];
        [cellView.serMonthInterval.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cellView.serMonthInterval addTarget:self action:@selector(ServicePage) forControlEvents:UIControlEventTouchUpInside];
        [cellView.serMonthInterval setImage:img forState:UIControlStateNormal];
        [cellView.serMonthInterval setImageEdgeInsets:UIEdgeInsetsMake(0,ImgEdgeHieght,0,0)];
        [cellView.serMonthInterval setTitleEdgeInsets:UIEdgeInsetsMake(0,-(img.size.width - 5),0,0)];
        NSString * byMonth =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"monthType"]];
        NSString * byKm =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"kmType"]];
        if (byMonth == nil || [byMonth isEqual:@"(null)"]) {
            [cellView.serMonthInterval setTitle:@"ByMonth" forState:UIControlStateNormal];
        }
        else{
            [cellView.serMonthInterval setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"monthType"] forState:UIControlStateNormal];

        }
        if (byKm == nil || [byKm isEqual:@"(null)"]) {
            [cellView.SerKmInt setTitle:@"ByKm" forState:UIControlStateNormal];
        }
        else{
            [cellView.SerKmInt setTitle:[[NSUserDefaults standardUserDefaults]objectForKey:@"kmType"] forState:UIControlStateNormal];
            
        }
        return cellView;
    }
    return cell;
}

-(void)ServicePage{
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBServiceIntervalViewController alloc] initWithNibName:@"CBServiceIntervalViewController" bundle:nil];
    } else {
        viewController = [[CBServiceIntervalViewController alloc] initWithNibName:@"CBServiceIntervalViewController_iPad" bundle:nil];
}
     [self.navigationController pushViewController:viewController animated:YES];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblchoice) {
        UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectIndexRow = indexPath.row;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SelectedStationAdd"];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblchoice) {
        UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryNone;
    }
}
- (IBAction)saveCarDetails:(id)sender {
    [self showProgressHud];
    NSMutableArray *key = [[NSMutableArray alloc] initWithObjects:@"FirstService",@"ServiceMonthInterval",@"ServiceKmInterval",@"LastServiceDate",@"Sellername",@"ownerAddr",@"Note",nil];
    [key addObjectsFromArray:[addCarDetails allKeys]];
    NSMutableArray *value = [[NSMutableArray alloc] initWithObjects:strFirstService,strServiceMonthInterval,strServiceKmInterval,strLastSerDate, cellView.sellerName.text,cellView.txtAddress.text,cellView.txtNote.text,nil];
    [value addObjectsFromArray:[addCarDetails allValues]];
    __block BOOL isNull = NO;
    if (isNull == YES) {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"ErrorAddVehicleDetail"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
        return;
    }

    NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithObjects:value forKeys:key];
    [dictData setValuesForKeysWithDictionary:Dict];
    CBImageViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBImageViewController alloc] initWithNibName:@"CBImageViewController" bundle:nil];
        viewController.addCarDetails = Dict;
    } else {
        viewController = [[CBImageViewController alloc] initWithNibName:@"CBImageViewController_iPad" bundle:nil];
        viewController.addCarDetails = Dict;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)customViewCreate {
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, picAndTblHieght)];
    tblchoice = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, picAndTblHieght)];
    tblchoice.delegate = self;
    tblchoice.dataSource = self;
    dateView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + picAndTblHieght)), self.view.frame.size.width, (self.navigationController.navigationBar.frame.size.height + picAndTblHieght))];
    _datePicker.backgroundColor = [UIColor whiteColor];
    tblchoice.backgroundColor = [UIColor whiteColor];
}
- (void)showDatePicker {
    [textField resignFirstResponder];
    dateView.hidden = TRUE;
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hiddenCustomView)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDateChanged)];
    [pickerDateToolbar setItems:@[cancelBtn,flexSpace,doneBtn] animated:NO];
    [dateView addSubview:pickerDateToolbar];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setDate:[NSDate date]];
    [dateView addSubview:_datePicker];
    [self.view addSubview:dateView];
    dateView.hidden = FALSE;
}
- (void)showDate {
    [textField resignFirstResponder];
    dateView.hidden = TRUE;
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hiddenCustomView)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDate)];
    [pickerDateToolbar setItems:@[cancelBtn,flexSpace,doneBtn] animated:NO];
    [dateView addSubview:pickerDateToolbar];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setDate:[NSDate date]];
    [dateView addSubview:_datePicker];
    [self.view addSubview:dateView];
    dateView.hidden = FALSE;
}

- (IBAction)hiddenCustomView {
    dateView.hidden = TRUE;
}
- (IBAction)pickerDateChanged {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATEFORMAT];
    strLastSerDate = [NSString stringWithFormat:@"%@",[df stringFromDate:_datePicker.date]];
    [cellView.lastServiceDate setTitle:strLastSerDate forState:UIControlStateNormal];
        
    dateView.hidden = TRUE;
}
- (IBAction)pickerDate{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATEFORMAT];
    strFirstService = [NSString stringWithFormat:@"%@",[df stringFromDate:_datePicker.date]];
    [cellView.firstService setTitle:strFirstService forState:UIControlStateNormal];
    dateView.hidden = TRUE;
}

- (void)getCachesPath:(NSMutableDictionary *)dict {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[dict objectForKey:@"PhotoURL"]]];
    NSString __block *path;
    ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageRef = [representation fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
        NSNumber *timeStampObj = [NSNumber numberWithInteger: timeStamp];
        fileformatName = [[asset defaultRepresentation] filename];
        NSArray * subStr = [fileformatName componentsSeparatedByString:@"."];
        NSData *imgData;
        if ([[fileformatName pathExtension] isEqualToString:@"JPG"]) {
            imgData = UIImageJPEGRepresentation(image, 1.0);
        } else {
            imgData = UIImagePNGRepresentation(image);
        }
        NSArray *paths = [[Constants sharedPath] getDocumentPath];
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString  stringWithFormat:@"%@_%@.%@",[subStr objectAtIndex:0],timeStampObj,[subStr objectAtIndex:1]]];
        [[NSFileManager defaultManager] createFileAtPath:path contents:imgData attributes:nil];
        NSString *NextServiceDate = [[Constants sharedPath] getNextServiceDate:[dict objectForKey:@"LastServiceDate"] withMonth:[dict objectForKey:@"ServiceInterval"]];
        [dict setObject:[NSString  stringWithFormat:@"%@_%@.%@",[subStr objectAtIndex:0],timeStampObj,[subStr objectAtIndex:1]] forKey:@"PhotoURL"];
        [dict setObject:NextServiceDate forKey:@"NextServiceDate"];
        [[CBDBMethods sharedTools] insertVehicles:dict];
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"AddVehicleDetail"]
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
        [self hideProgressHud];
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[[CBDBMethods sharedTools] getVehicleDetails]];
        NSMutableDictionary *duplicateDict = [arr lastObject];
        [dict setObject:[duplicateDict objectForKey:@"VDId"] forKey:@"VDId"];
        dictNotif = dict;
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
    };
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:url resultBlock:resultsBlock failureBlock:failureBlock];
}
- (void)loadServiceStationView {
    dateView.hidden = TRUE;
    UIViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleServiceStationAddController alloc] initWithNibName:@"CBVehicleServiceStationAddController" bundle:nil];
    } else {
        viewController = [[CBVehicleServiceStationAddController alloc] initWithNibName:@"CBVehicleServiceStationAddController_iPad" bundle:nil];
    }
    [self.navigationController pushViewController:viewController animated:YES];
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

#pragma mark - AlertViewDelegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[CBDBMethods sharedTools] insertNotification:dictNotif];
    [[Constants sharedPath] setLocalNotification];
    [self goHome];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
