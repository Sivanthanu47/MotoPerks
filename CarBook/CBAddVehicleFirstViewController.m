//
//  CBAddVehicleViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 05/11/14.

//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 30.0

#import "CBAddVehicleFirstViewController.h"
#import "CBAddVehicleSecondViewController.h"
#import "VehicleAddFirstCustomCell.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "OverlayView.h"

@interface CBAddVehicleFirstViewController ()

@end

UITextField *textField;
NSString *strReg,*strInsDate,*strPhotoURL,*strFuelType;
NSInteger intBtnTag = 0;
UIImageView *imgView;
UIView *dateView;
int pickerHieght = 0;
VehicleAddFirstCustomCell *cellView;
NSArray *cellNib;
int ImgEdgeHieght;
UIImage *chosenImage;
@implementation CBAddVehicleFirstViewController
@synthesize dictData;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    strReg = @"Registration Date",strPhotoURL = @"",strInsDate = @"Date",chosenImage = nil;
    dictData = [[NSMutableDictionary alloc] init];
    arrFuelType = [NSArray arrayWithObjects:@"Petrol",@"Diesel",@"Gasoline", nil];
   
}
- (void)viewWillAppear:(BOOL)animated {
    pickerHieght = 216;
    self.title = [[CBStrings sharedStrings] getPageTitle:@"AddVehiclePage"];
    picker = [[UIImagePickerController alloc] init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        ImgEdgeHieght = (self.view.frame.size.width-52);
    } else {
        ImgEdgeHieght = (self.view.frame.size.width-76);
    }
    [self setNavigationBar];
    [self customViewCreate];
    if ([dictData count] > 0) {
        [self loadView];
         [tblAddFirst reloadData];
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
    [textField resignFirstResponder];
    dateView.hidden = TRUE;
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)txtField {
    textField = txtField;
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *) txtField {
    textField = txtField;
    [textField resignFirstResponder];
    return YES;
}

#pragma mark- KeyboardDelegates
- (void) keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbRect.size.height), 0.0);
    tblAddFirst.contentInset = contentInsets;
}
- (void) keyboardWillBeHidden:(NSNotification *)notification {
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    tblAddFirst.contentInset = contentInsets;
    tblAddFirst.scrollIndicatorInsets = contentInsets;
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 670;
    }
    return 820;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cellView = (VehicleAddFirstCustomCell *)[tableView dequeueReusableCellWithIdentifier:@"VehicleAddFirstIdentifier"];
    if (cellView == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            cellNib = [[NSBundle mainBundle] loadNibNamed:@"VehicleAddFirstCustomCell" owner:self options:nil];
        } else {
            cellNib = [[NSBundle mainBundle] loadNibNamed:@"VehicleAddFirstCustomCell_iPad" owner:self options:nil];
        }
        cellView = (VehicleAddFirstCustomCell *)[cellNib lastObject];
        [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cellView.btnFuelType setTitle:strFuelType forState:UIControlStateNormal];
    [cellView.btnDate setTitle:strInsDate forState:UIControlStateNormal];
    [cellView.btnReg setTitle:strReg forState:UIControlStateNormal];
    cellView.backgroundColor = [UIColor clearColor];
    UIImage *img = [UIImage imageNamed:@"arrow_down.png"];
    cellView.txtOwner.delegate = self;
    if ([dictData objectForKey:@"Owner"]) {
        cellView.txtOwner.text = [dictData objectForKey:@"Owner"];
    }
       cellView.txtCarName.delegate = self;
    if ([dictData objectForKey:@"CarName"]) {
        cellView.txtCarName.text = [dictData objectForKey:@"CarName"];
    }
  
   cellView.Address.text = @"Address";
   cellView.Address.textColor = [UIColor blackColor];
   cellView.Address.delegate = self;
    if ([dictData objectForKey:@"Address"]) {
        cellView.Address.text = [dictData objectForKey:@"Address"];
    }
    [cellView.btnReg setTitle:@"Registration Date" forState:UIControlStateNormal];
    [cellView.btnReg.layer setBorderWidth:1.0];
    [cellView.btnReg.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [cellView.btnReg addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [cellView.btnReg setImage:img forState:UIControlStateNormal];
    [cellView.btnReg setImageEdgeInsets:UIEdgeInsetsMake(0,ImgEdgeHieght,0,0)];
    [cellView.btnReg setTitleEdgeInsets:UIEdgeInsetsMake(0,-(img.size.width - 5),0,0)];
    NSString *regDate = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"RegisterDate"]];
    if (regDate == nil || [regDate isEqual:@"(null)"]) {
        [cellView.btnReg setTitle:@"Registration Date" forState:UIControlStateNormal];
    } else {
        [cellView.btnReg setTitle:regDate forState:UIControlStateNormal];
    }
    cellView.txtCMRead.delegate = self;
    if ([dictData objectForKey:@"CMStartRead"]) {
        cellView.txtCMRead.text = [dictData objectForKey:@"CMStartRead"];
    }
    if (strFuelType == nil || [strFuelType isEqual:@"(null)"]) {
        [cellView.btnFuelType setTitle:@"Fuel type" forState:UIControlStateNormal];
    }
    else{
        [cellView.btnFuelType setTitle:strFuelType forState:UIControlStateNormal];
    }
    [cellView.btnFuelType addTarget:self action:@selector(addPicker) forControlEvents:UIControlEventTouchUpInside];
    [cellView.btnFuelType.layer setCornerRadius:5.0];
    [cellView.btnFuelType.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [cellView.btnFuelType.layer setBorderWidth:1.0];
    [cellView.btnFuelType setImage:img forState:UIControlStateNormal];
    [cellView.btnFuelType setImageEdgeInsets:UIEdgeInsetsMake(0,ImgEdgeHieght,0,0)];
    [cellView.btnDate.layer setBorderWidth:1.0];
    [cellView.btnDate setTitle:@"Date" forState:UIControlStateNormal];
    [cellView.btnDate.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [cellView.btnDate addTarget:self action:@selector(showDatePicker:) forControlEvents:UIControlEventTouchUpInside];
    [cellView.btnDate setImage:img forState:UIControlStateNormal];
    [cellView.btnDate setImageEdgeInsets:UIEdgeInsetsMake(0,ImgEdgeHieght,0,0)];
    [cellView.btnDate setTitleEdgeInsets:UIEdgeInsetsMake(0,-(img.size.width - 5),0,0)];
    NSString *insurDate = [NSString stringWithFormat:@"%@",[dictData objectForKey:@"InsuranceDate"]];
    if (insurDate == nil || [insurDate isEqual:@"(null)"]) {
        [cellView.btnDate setTitle:@"Date" forState:UIControlStateNormal];
    } else {
        [cellView.btnDate setTitle:insurDate forState:UIControlStateNormal];
    }
    return cellView;
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
    myPickerView.frame = CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, pickerHieght);
    myPickerView.showsSelectionIndicator = YES;
    popoverView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + pickerHieght)), self.view.frame.size.width, (self.navigationController.navigationBar.frame.size.height + pickerHieght))];
    NSLog(@" navigation height %f",(self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + pickerHieght)));
    popoverView.backgroundColor = [UIColor whiteColor];
    [popoverView addSubview:myPickerView];
    [popoverView addSubview:pickerToolbar];
    [self.view addSubview:popoverView];
}
-(void)pickerDone{
    [cellView.btnFuelType setTitle:strFuelType forState:UIControlStateNormal];
    [myPickerView removeFromSuperview];
    [pickerToolbar removeFromSuperview];
    [popoverView removeFromSuperview];
    [myPickerView reloadAllComponents];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow: (NSInteger)row inComponent:(NSInteger)component {
    [cellView.btnFuelType setTitle:[NSString stringWithFormat:@"%@",[arrFuelType objectAtIndex:row]] forState:UIControlStateNormal];
    strFuelType =[arrFuelType objectAtIndex:row];
    [[NSUserDefaults standardUserDefaults]setObject:strFuelType forKey:@"Strfueltype"];
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
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    dateView.hidden = TRUE;
    if ([textView.text isEqualToString:@"Address"]) {
         textView.text =@"";
    }
    else{
         textView =textView;
    }
   
       if  (self.view.frame.origin.y >= 0)
       {
           [self setViewMovedUp:YES];
       }
    [textView resignFirstResponder];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        tblAddFirst.contentOffset = CGPointMake(0, ((self.view.frame.size.height - tblAddFirst.frame.size.height)));
    }

return YES;

}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]){
        textView =textView;
    }
    [textView resignFirstResponder];
    if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }

    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
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

- (IBAction)goNext:(id)sender {
    NSMutableArray *key = [[NSMutableArray alloc] initWithObjects:@"CarName",@"InsuranceDate",@"RegisterDate",@"FuelType",@"CMRead",@"Owner",@"Address", nil];
    NSMutableArray *value = [[NSMutableArray alloc] initWithObjects:cellView.txtCarName.text,strInsDate,strReg,strFuelType,cellView.txtCMRead.text,cellView.txtOwner.text,cellView.Address.text, nil];
  
    __block BOOL isNull = NO;
    [value enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ((obj == nil) || ([[obj stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] < 1 || [obj isEqualToString:@""])) {
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
        return;
    }
  NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithObjects:value forKeys:key];
    [dictData setValuesForKeysWithDictionary:Dict];
CBAddVehicleSecondViewController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBAddVehicleSecondViewController alloc] initWithNibName:@"CBAddVehicleSecondViewController" bundle:nil];
        viewController.addCarDetails = Dict;
    } else {
        viewController = [[CBAddVehicleSecondViewController alloc] initWithNibName:@"CBAddVehicleSecondViewController_iPad" bundle:nil];
        viewController.addCarDetails = Dict;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)customViewCreate {
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, pickerHieght)];
    dateView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, (self.view.frame.size.height-(self.navigationController.navigationBar.frame.size.height + pickerHieght)), self.view.frame.size.width, (self.navigationController.navigationBar.frame.size.height + pickerHieght))];
    UIToolbar *pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.view.frame.size.width, self.navigationController.navigationBar.frame.size.height)];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(hiddenCustomView)];
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(pickerDateChanged)];
    [pickerDateToolbar setItems:@[cancelBtn,flexSpace,doneBtn] animated:NO];
    [dateView addSubview:pickerDateToolbar];
    _datePicker.datePickerMode = UIDatePickerModeDate;
    [_datePicker setDate:[NSDate date]];
    _datePicker.backgroundColor = [UIColor whiteColor];
}
- (void) showDatePicker:(UIButton *)sender {
    [textField resignFirstResponder];
    intBtnTag = sender.tag;
    dateView.hidden = TRUE;
    [dateView addSubview:_datePicker];
    [self.view addSubview:dateView];
    dateView.hidden = FALSE;
    
}
- (IBAction)hiddenCustomView {
    dateView.hidden = TRUE;
}
- (IBAction)pickerDateChanged {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:DATEFORMAT];
    if (intBtnTag == 2) {
        strReg = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_datePicker.date]];
        [cellView.btnReg setTitle:strReg forState:UIControlStateNormal];
    } else {
        strInsDate = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:_datePicker.date]];
        [cellView.btnDate setTitle:strInsDate forState:UIControlStateNormal];
    }
    dateView.hidden = TRUE;
}

#pragma mark - AlertViewDelegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self goBack];
}

#pragma mark - RotateOrientationDelegates
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
