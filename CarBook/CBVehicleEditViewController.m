//
//  CBVehicleEditViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 03/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBVehicleEditViewController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "OverlayView.h"
#import "CustomCell.h"

@interface CBVehicleEditViewController ()

@end
UITextField *textField;
NSString *strReg,*strInsDate,*strPhotoURL,*strStaName,*strLdate,*strSID,*strOwner,*strLic,*strCarName,*strVIN,*strFuel,*strCMRead,*strInsName,*strSerInt,*strKiloMr,*strNote,*strFuelType;
NSInteger btnTagDate = 0;
UIImage *dupImgView;
int CellHeight,customViewHeight = 0;
UIView *dateView;
NSInteger selectedIndexRow;
NSArray *nib;
CustomCell *cellView;
@implementation CBVehicleEditViewController
@synthesize editDict;

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
                                             selector:@selector(keyboardDidShow:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    arrStaName = [[NSMutableArray alloc] init];
    arrStaName = [[CBDBMethods sharedTools] getServiceStationDetails];
    arrFuelType = [NSArray arrayWithObjects:@"Petrol",@"Diesel",@"Gasoline", nil];
    [self setValuesonString];
}
- (void)viewWillAppear:(BOOL)animated {
    customViewHeight = 216;
    self.title = [[CBStrings sharedStrings] getPageTitle:@"VehicleEditPage"];
    picker = [[UIImagePickerController alloc] init];
    [self setNavigationBar];
    [self customViewCreate];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        CellHeight = (self.view.frame.size.width-52);
    } else {
        CellHeight = (self.view.frame.size.width-76);
    }
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
    [btnDeveloper addTarget:self action:@selector(updateVehicleDetails) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setValuesonString {
    strOwner = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"Owner"]];
    strLic = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"License"]];
    strCarName = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"CarName"]];
    strVIN = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"VIN"]];
    strFuel = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"Fuel"]];
    strCMRead = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"CMRead"]];
    strInsName = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"InsuranceName"]];
    strSerInt = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"ServiceInterval"]];
    strKiloMr = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"TravelKM"]];
    strPhotoURL = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"PhotoURL"]];
    strReg = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"RegisterDate"]];
    strInsDate = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"InsuranceDate"]];
    strStaName = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"StationName"]];
    strSID = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"SSId"]];
    strLdate = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"LastServiceDate"]];
    strNote = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"Note"]];
    strFuelType = [NSString stringWithFormat:@"%@",[editDict objectForKey:@"FuelType"]];
    NSArray *paths = [[Constants sharedPath] getDocumentPath];
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:strPhotoURL];
    dupImgView = [UIImage imageWithContentsOfFile:imagePath];
}
- (void)ReloadTableView {
    [tblEdit reloadData];
}

#pragma mark- TextFieldDelegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)txtField {
    textField = txtField;
    dateView.hidden = TRUE;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *) txtField {
    [txtField resignFirstResponder];
    return YES;
}

#pragma mark - TextViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    dateView.hidden = TRUE;
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    strNote = textView.text;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return YES;
}

#pragma mark- KeyboardDelegates
- (void) keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbRect.size.height), 0.0);
    tblEdit.contentInset = contentInsets;
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblStationName) {
        return 50;
    }
    return 985;
}- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == tblStationName) {
        return [arrStaName count];
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *Cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (tableView == tblStationName) {
        if (Cell == nil) {
            Cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        if (tableView == tblStationName) {
            [Cell setAccessoryType:UITableViewCellAccessoryNone];
            NSMutableDictionary *dict = [arrStaName objectAtIndex:indexPath.row];
            Cell.textLabel.text = [NSString stringWithFormat:@"%@",[dict objectForKey:@"stationName"]];
        }
    }
    else {
        CustomCell *cell = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
            } else {
                nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_iPad" owner:self options:nil];
            }
            cell = (CustomCell *)[nib objectAtIndex:4];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        UIImage *imgDown = [UIImage imageNamed:@"arrow_down.png"];
        cell.txtOwner.text = strOwner;
        cell.txtOwner.delegate = self;
        [cell.txtOwner addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.txtLic.text = strLic;
        cell.txtLic.delegate = self;
        [cell.txtLic addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.txtCarName.text = strCarName;
        cell.txtCarName.delegate = self;
        [cell.txtCarName addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.txtVIN.text = strVIN;
        cell.txtVIN.delegate = self;
        [cell.txtVIN addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.btnReg setTitle:strReg forState:UIControlStateNormal];
        [cell.btnReg addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnReg.layer setCornerRadius:5.0];
        [cell.btnReg.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.btnReg.layer setBorderWidth:1.0];
        [cell.btnReg setImage:imgDown forState:UIControlStateNormal];
        [cell.btnReg setImageEdgeInsets:UIEdgeInsetsMake(0,CellHeight,0,0)];
        cell.txtFuel.text = strFuel;
        cell.txtFuel.delegate = self;
        [cell.txtFuel addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.txtCMRead.text = strCMRead;
        cell.txtCMRead.delegate = self;
        [cell.txtCMRead addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.btnTake addTarget:self action:@selector(loadCameraView) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnTake.layer setCornerRadius:5.0];
        [cell.btnTake.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.btnTake.layer setBorderWidth:1.0];
        [cell.btnPick addTarget:self action:@selector(loadPhotoView) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnPick.layer setCornerRadius:5.0];
        [cell.btnPick.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.btnPick.layer setBorderWidth:1.0];
        cell.imgView.image = dupImgView;
        [cell.imgView.layer setCornerRadius:5.0];
        [cell.imgView.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.imgView.layer setBorderWidth:1.0];
        [cell.imgView setContentMode:UIViewContentModeScaleAspectFit];
        cell.txtInsName.text = strInsName;
        cell.txtInsName.delegate = self;
        [cell.txtInsName addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.btnDate setTitle:strInsDate forState:UIControlStateNormal];
        [cell.btnDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnDate.layer setCornerRadius:5.0];
        [cell.btnDate.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.btnDate.layer setBorderWidth:1.0];
        [cell.btnDate setImage:imgDown forState:UIControlStateNormal];
        [cell.btnDate setImageEdgeInsets:UIEdgeInsetsMake(0,CellHeight,0,0)];
        [cell.btnSerName setTitle:strStaName forState:UIControlStateNormal];
        [cell.btnSerName addTarget:self action:@selector(showCustomTblView) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnSerName.layer setCornerRadius:5.0];
        [cell.btnSerName.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.btnSerName.layer setBorderWidth:1.0];
        [cell.btnSerName setImage:imgDown forState:UIControlStateNormal];
        [cell.btnSerName setImageEdgeInsets:UIEdgeInsetsMake(0,CellHeight,0,0)];
        [cell.btnFuelType setTitle:strFuelType forState:UIControlStateNormal];
        [cell.btnFuelType addTarget:self action:@selector(addPicker) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnFuelType.layer setCornerRadius:5.0];
        [cell.btnFuelType.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.btnFuelType.layer setBorderWidth:1.0];
        [cell.btnFuelType setImage:imgDown forState:UIControlStateNormal];
        [cell.btnFuelType setImageEdgeInsets:UIEdgeInsetsMake(0,CellHeight,0,0)];
        cell.txtSerInterval.text = strSerInt;
        cell.txtSerInterval.delegate = self;
        [cell.txtSerInterval addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        [cell.btnLDate setTitle:strLdate forState:UIControlStateNormal];
        [cell.btnLDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
        [cell.btnLDate.layer setCornerRadius:5.0];
        [cell.btnLDate.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.btnLDate.layer setBorderWidth:1.0];
        [cell.btnLDate setImage:imgDown forState:UIControlStateNormal];
        [cell.btnLDate setImageEdgeInsets:UIEdgeInsetsMake(0,CellHeight,0,0)];
        cell.txtKm.text = strKiloMr;
        cell.txtKm.delegate = self;
        [cell.txtKm addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];
        cell.txtViewNote.text = strNote;
        [cell.txtViewNote.layer setCornerRadius:5.0];
        [cell.txtViewNote.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
        [cell.txtViewNote.layer setBorderWidth:1.0];
        cell.txtViewNote.delegate = self;
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }
    return Cell;
}
-(void)addPicker{
    pickerToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    pickerToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerToolbar sizeToFit];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(pickerCancel:)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDone)];
    [pickerToolbar setItems:@[cancelBtn,flexSpace, doneBtn] animated:NO];
    myPickerView = [[UIPickerView alloc] init];
    myPickerView.delegate = self;
    myPickerView.showsSelectionIndicator = YES;
    CGRect pickerRect = myPickerView.bounds;
    myPickerView.bounds = pickerRect;
    myPickerView.frame = CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, customViewHeight);
    myPickerView.showsSelectionIndicator = YES;
    popoverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + customViewHeight)), self.view.frame.size.width, (self.navigationController.navigationBar.frame.size.height + customViewHeight))];
    NSLog(@" navigatio height %f",(self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + customViewHeight)));
    popoverView.backgroundColor = [UIColor whiteColor];
    [popoverView addSubview:myPickerView];
    [popoverView addSubview:pickerToolbar];
    [self.view addSubview:popoverView];
}
-(void)pickerDone{
    [myPickerView removeFromSuperview];
    [pickerToolbar removeFromSuperview];
    [popoverView removeFromSuperview];
    [myPickerView reloadAllComponents];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    strFuelType = [NSString stringWithFormat:@"%@",[arrFuelType objectAtIndex:row]];
    myPickerView.showsSelectionIndicator = YES;
    cellView = (CustomCell *)[nib objectAtIndex:4];
    [cellView.btnFuelType setTitle:strFuelType forState:UIControlStateNormal];
    [myPickerView reloadAllComponents];
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return arrFuelType.count;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return arrFuelType[row];
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    int sectionWidth = 300;
    return sectionWidth;
}
-(void)pickerCancel:(id)sender{
    popoverView.hidden=TRUE;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == tblStationName) {
        UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
        uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
        selectedIndexRow = indexPath.row;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SelectStationInEdit"];
    }
}
- (void)textFieldValueChanged:(UITextField *)txtField {
    if (txtField.tag == 1) {
        strOwner = txtField.text;
    } else if (txtField.tag == 2) {
        strLic = txtField.text;
    } else if (txtField.tag == 3) {
        strCarName = txtField.text;
    } else if (txtField.tag == 4) {
        strVIN = txtField.text;
    } else if (txtField.tag == 5) {
        strFuel = txtField.text;
    } else if (txtField.tag == 6) {
        strCMRead = txtField.text;
    } else if (txtField.tag == 7) {
        strInsName = txtField.text;
    } else if (txtField.tag == 8) {
        strSerInt = txtField.text;
    } else {
        strKiloMr = txtField.text;
    }
}
- (void)updateVehicleDetails {
    [self showProgressHud];
    NSMutableArray *value = [[NSMutableArray alloc] initWithObjects:strOwner,strLic,strLdate,strStaName,strSerInt,strCMRead,strCarName,strFuel,strInsDate,strInsName,strReg,strVIN,strNote,strKiloMr,strSID,strFuelType,[editDict objectForKey:@"VDId"], nil];
    NSMutableArray *key = [[NSMutableArray alloc] initWithObjects:@"Owner",@"License",@"LastServiceDate",@"StationName",@"ServiceInterval",@"CMRead",@"CarName",@"Fuel",@"InsuranceDate",@"InsuranceName",@"RegisterDate",@"VIN",@"Note",@"TravelKM",@"SSId",@"FuelType",@"VDId", nil];
    NSLog(@"value %@ key %@ ",value,key);
    __block BOOL isNull = NO;
    [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isEqualToString:@""] || (obj == nil)) {
            *stop = YES;
            isNull = YES;
        }
    }];
    if (isNull == YES) {
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"NoText"]
                                                          delegate:nil
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
        [self hideProgressHud];
        return;
    }
    NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithObjects:value forKeys:key];
    [self getCachesPath:Dict];
}
- (void)getCachesPath:(NSMutableDictionary *)dict {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",strPhotoURL]];
    NSString __block *path;
    ALAssetsLibraryAssetForURLResultBlock resultsBlock = ^(ALAsset *asset) {
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageRef = [representation fullScreenImage];
        UIImage *image = [UIImage imageWithCGImage:imageRef];
        NSString *fileformatName = [[asset defaultRepresentation] filename];
        NSData *imgData;
        if ([[fileformatName pathExtension] isEqualToString:@"JPG"]) {
            imgData = UIImageJPEGRepresentation(image, 1.0);
        } else {
            imgData = UIImagePNGRepresentation(image);
        }
        NSArray *paths = [[Constants sharedPath] getDocumentPath];
        path = [[paths objectAtIndex:0] stringByAppendingPathComponent:fileformatName];
        //[imgData writeToFile:path atomically:NO];
        [[NSFileManager defaultManager] createFileAtPath:path contents:imgData attributes:nil];
        NSString *NextServiceDate = [[Constants sharedPath] getNextServiceDate:strLdate withMonth:strSerInt];
        [dict setObject:NextServiceDate forKey:@"NextServiceDate"];
        if (fileformatName == nil) {
            [dict setObject:strPhotoURL forKey:@"PhotoURL"];
        } else {
            [dict setObject:fileformatName forKey:@"PhotoURL"];
        }
        [[CBDBMethods sharedTools] updateVehicleDetails:dict];
        UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                           message:[[CBStrings sharedStrings] getAlertMessage:@"UpdateVehicle"]
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
        [addAlert show];
        [self hideProgressHud];
    };
    ALAssetsLibraryAccessFailureBlock failureBlock = ^(NSError *error) {
    };
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:url resultBlock:resultsBlock failureBlock:failureBlock];
}
- (void) showDatePicker:(UIButton *)sender {
    [textField resignFirstResponder];
    btnTagDate = sender.tag;
    dateView.hidden = TRUE;
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hiddenCustomView)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(datePickerDateChanged)];
    [pickerDateToolbar setItems:@[cancelBtn,flexSpace, doneBtn] animated:NO];
    [dateView addSubview:pickerDateToolbar];
    [dateView addSubview:_datePicker];
    [self.view addSubview:dateView];
    dateView.hidden = FALSE;
}
- (void)customViewCreate {
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, customViewHeight)];
    tblStationName = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, customViewHeight)];
    tblStationName.delegate = self;
    tblStationName.dataSource = self;
    dateView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + customViewHeight)), self.view.frame.size.width, (self.navigationController.navigationBar.frame.size.height + customViewHeight))];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setDate:[NSDate date]];
    _datePicker.backgroundColor = [UIColor whiteColor];
    tblStationName.backgroundColor = [UIColor whiteColor];
}
- (IBAction)datePickerDateChanged {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:DATEFORMAT];
    if (btnTagDate == 1) {
        strReg = [NSString stringWithFormat:@"%@",[df stringFromDate:_datePicker.date]];
    } else if (btnTagDate == 2){
        strInsDate = [NSString stringWithFormat:@"%@",[df stringFromDate:_datePicker.date]];
    } else {
        strLdate = [NSString stringWithFormat:@"%@",[df stringFromDate:_datePicker.date]];
    }
    [self ReloadTableView];
    dateView.hidden = TRUE;
}
- (IBAction)hiddenCustomView {
    dateView.hidden = TRUE;
}
- (IBAction)stationNameChanged {
    BOOL selected = [[NSUserDefaults standardUserDefaults] boolForKey:@"SelectStationInEdit"];
    if (selected) {
        NSMutableDictionary *SerNameDict = [arrStaName objectAtIndex:selectedIndexRow];
        strStaName = [NSString stringWithFormat:@"%@",[SerNameDict objectForKey:@"stationName"]];
        strSID = [NSString stringWithFormat:@"%@",[SerNameDict objectForKey:@"SSId"]];
        [self ReloadTableView];
    }
    dateView.hidden = TRUE;
}
- (void)showCustomTblView {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SelectStationInEdit"];
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SelectFuelInEdit"];
    
    [textField resignFirstResponder];
    dateView.hidden = TRUE;
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hiddenCustomView)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(stationNameChanged)];
    [pickerDateToolbar setItems:@[cancelBtn,flexSpace, doneBtn] animated:NO];
    [dateView addSubview:pickerDateToolbar];
    [dateView addSubview:tblStationName];
    [self.view addSubview:dateView];
    dateView.hidden = FALSE;
    [tblStationName reloadData];
}
- (void)loadCameraView {
    [textField resignFirstResponder];
    dateView.hidden = TRUE;
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self loadCamera];
    } else {
        UIAlertView *noCameraAlert = [[UIAlertView alloc] initWithTitle:@"Camera"
                                                                message:@"Camera Not Available"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
        [noCameraAlert show];
    }
}
- (void)loadPhotoView {
    [textField resignFirstResponder];
    dateView.hidden = TRUE;
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.modalPresentationStyle = UIModalPresentationPageSheet;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)loadCamera {
    UIToolbar *toolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-55, self.view.frame.size.width, 55)];
    switchCameraButton = [[UIBarButtonItem alloc] initWithTitle:@"Front" style:UIBarButtonItemStylePlain  target:self action:@selector(switchCamera)];
    toolBar.barStyle =  UIBarStyleBlackOpaque;
    NSArray *items=[NSArray arrayWithObjects:
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel  target:self action:@selector(cancelPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera  target:self action:@selector(shootPicture)],
                    [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace  target:nil action:nil],
                    switchCameraButton,
                    nil];
    [toolBar setItems:items];
    OverlayView *overlayView=[[OverlayView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-55)];
    overlayView.opaque=NO;
    overlayView.backgroundColor=[UIColor clearColor];
    UIView *cameraView=[[UIView alloc] initWithFrame:self.view.bounds];
    [cameraView addSubview:overlayView];
    [cameraView addSubview:toolBar];
    picker.delegate = (id)self;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    picker.modalPresentationStyle = UIModalPresentationCurrentContext;
    picker.allowsEditing = NO ;
    picker.toolbarHidden = YES;
    picker.navigationBarHidden = YES;
    picker.showsCameraControls = NO;
    [picker setCameraOverlayView:cameraView];
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)shootPicture {
    [picker takePicture];
}
- (void)cancelPicture {
    [self dismissViewControllerAnimated:NO completion:NULL];
}
- (void)switchCamera {
    if(picker.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        switchCameraButton.title = @"Front";
    } else {
        picker.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        switchCameraButton.title = @"Rear";
    }
}
- (void)imagePickerController:(UIImagePickerController *)pic didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *choseImage = info [UIImagePickerControllerOriginalImage];
    dupImgView = choseImage;
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        NSData *data = UIImageJPEGRepresentation(choseImage, 1.0);
        [self toSavePhotoToCameraRoll:data];
    } else {
        strPhotoURL = [NSString stringWithFormat:@"%@",info [UIImagePickerControllerReferenceURL]];
        [self ReloadTableView];
    }
    [pic dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)pic {
    [pic dismissViewControllerAnimated:YES completion:NULL];
}
- (void)toSavePhotoToCameraRoll:(NSData *)data {
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    [lib writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        [lib assetForURL:assetURL
             resultBlock:^(ALAsset *asset) {
                 strPhotoURL = [NSString stringWithFormat:@"%@",assetURL];
                 [self ReloadTableView];
             } failureBlock:^(NSError *error) {
             }];
    }];
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
    [self goBack];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[Constants sharedPath] setLocalNotification];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
