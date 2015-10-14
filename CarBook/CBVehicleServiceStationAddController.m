//
//  CBVehicleServiceStationAddController.m
//  CarBook
//
//  Created by Raja Sekhar on 10/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//
#define kOFFSET_FOR_KEYBOARD 80.0

#import "CBVehicleServiceStationAddController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "CustomCell.h"

@interface CBVehicleServiceStationAddController ()
@end

UITextField *textField;
NSString *strName,*strContact,*strCity,*strPhone,*strAddress,*strNote;
NSArray *cellNib;
CustomCell *cellView;

@implementation CBVehicleServiceStationAddController
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}
- (void)viewWillAppear:(BOOL)animated {
    [self setNavigationBar];
    arrStation = [[NSMutableArray alloc] init];
    arrDerStation = [[NSMutableArray alloc] init];
    strName = @"",strContact = @"",strCity = @"",strPhone = @"",strAddress = @"",strNote = @"";
    arrStation = [[CBDBMethods sharedTools] getServiceStationDetails];
    if (_SStanID != nil) {
        arrUpdate = [[NSMutableArray alloc] init];
        [arrUpdate addObjectsFromArray:[[CBDBMethods sharedTools] getStationWithMap:_SStanID]];
        NSMutableDictionary *stationDict = [arrUpdate lastObject];
        strName = [NSString stringWithFormat:@"%@",[stationDict objectForKey:@"stationName"]];
        strCity = [NSString stringWithFormat:@"%@",[stationDict objectForKey:@"AddCity"]];
        strPhone = [NSString stringWithFormat:@"%@",[stationDict objectForKey:@"PhoneNo"]];
        strContact = [NSString stringWithFormat:@"%@",[stationDict objectForKey:@"ContactNo"]];
        strNote = [NSString stringWithFormat:@"%@",[stationDict objectForKey:@"Notes"]];
        strAddress = [NSString stringWithFormat:@"%@",[stationDict objectForKey:@"Address"]];

        self.title = [[CBStrings sharedStrings] getPageTitle:@"StationEditPage"];
    } else {
        self.title = [[CBStrings sharedStrings] getPageTitle:@"StationAddPage"];
    }
    for (NSDictionary *dict in arrStation) {
        [arrDerStation addObject:[dict objectForKey:@"stationName"]];
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

#pragma mark- Keyboard
- (void) keyboardDidShow:(NSNotification *)notification {
    NSDictionary* info = [notification userInfo];
    CGRect kbRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    kbRect = [self.view convertRect:kbRect fromView:nil];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, (kbRect.size.height), 0.0);
    tblSSAdd.contentInset = contentInsets;
}

#pragma mark- TextFieldDelegates
- (BOOL)textFieldShouldReturn:(UITextField *) txtField {
    textField = txtField;
    [textField resignFirstResponder];
    if (_SStanID != nil) {
        return YES;
    }
    cellView = (CustomCell *)[cellNib objectAtIndex:3];
    textField = (UITextField *)[cellView viewWithTag:txtField.tag+1];
    if(textField.returnKeyType != UIReturnKeyDone){
        [textField becomeFirstResponder];
    }
    return YES;
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 435;
    }
    return 640;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    cellView = (CustomCell *)[tableView dequeueReusableCellWithIdentifier:@"ServiceCellIdentifier"];
    if (cellView == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            cellNib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell" owner:self options:nil];
        } else {
            cellNib = [[NSBundle mainBundle] loadNibNamed:@"CustomCell_iPad" owner:self options:nil];
        }
        cellView = (CustomCell *)[cellNib objectAtIndex:3];
        [cellView setSelectionStyle:UITableViewCellSelectionStyleNone];
        cellView.backgroundColor = [UIColor clearColor];
        cellView.textLabel.textColor = [UIColor whiteColor];
    }
    cellView.txtServName.text = strName;
    cellView.txtServName.delegate = self;
    [cellView.txtServName addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
    cellView.txtAddCity.text = strCity;
    cellView.txtAddCity.delegate = self;
    [cellView.txtAddCity addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
    cellView.txtPhone.text = strPhone;
    cellView.txtPhone.delegate = self;
    [cellView.txtPhone addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
    cellView.txtContact.text = strContact;
    cellView.txtContact.delegate = self;
    [cellView.txtContact addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
    cellView.serviceAddr.text = strNote;
    cellView.serviceAddr.delegate = self;
    [cellView.serviceAddr addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];
    cellView.Notes.text = strNote;
    cellView.Notes.delegate = self;
    [cellView.Notes addTarget:self action:@selector(textFieldValueChanges:) forControlEvents:UIControlEventEditingChanged];

    return cellView;
}
- (void)textFieldValueChanges:(UITextField *)txtField {
    if (txtField.tag == 1) {
        strName = txtField.text;
    } else if (txtField.tag == 2) {
        strCity = txtField.text;
    } else if (txtField.tag == 3) {
        strAddress = txtField.text;
    } else if (txtField.tag == 4) {
        strPhone = txtField.text;
    } else if (txtField.tag == 5) {
        strContact = txtField.text;
    } else {
        strNote = txtField.text;
    }
}
- (IBAction)saveServiceStations:(id)sender {
    if ((NO == [[Constants sharedPath] isNetworkAvailable])) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                            message:[[CBStrings sharedStrings] getAlertMessage:@"NoNetwork"]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    NSMutableArray *key = [[NSMutableArray alloc] initWithObjects:@"stationName",@"AddCity",@"Address",@"PhoneNo",@"ContactNo",@"Notes", nil];
    NSMutableArray *value = [[NSMutableArray alloc] initWithObjects:strName,strCity,strAddress,strPhone,strContact,strNote, nil];
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
    [self showProgressHud];
    NSString *MapAdd = [NSString stringWithFormat:@"%@,%@",strCity,strAddress];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", [MapAdd stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString *result = [NSString stringWithContentsOfURL:[NSURL URLWithString:req] encoding:NSUTF8StringEncoding error:NULL];
        NSData *jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        id results = [jsonDictionary objectForKey:@"results"];
        NSString *latcenter,*lngcenter;
        for(id stuff in results) {
            latcenter = [[[stuff objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lat"];
            lngcenter = [[[stuff objectForKey:@"geometry"] objectForKey:@"location"] objectForKey:@"lng"];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([results count] == 0) {
                [self hideProgressHud];
                UIAlertView *errAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                                   message:[[CBStrings sharedStrings] getAlertMessage:@"alertLocation"]
                                                                  delegate:nil
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil];
                [errAlert show];
                return;
            }
            NSMutableDictionary *Dict = [[NSMutableDictionary alloc] initWithObjects:value forKeys:key];
            [Dict setObject:latcenter forKey:@"Latitude"];
            [Dict setObject:lngcenter forKey:@"Longitude"];
            if (_SStanID == nil) {
                if ([[arrDerStation valueForKey:@"lowercaseString"] containsObject:[strName lowercaseString]]) {
                    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                                       message:[[CBStrings sharedStrings] getAlertMessage:@"AlreadyStation"]
                                                                      delegate:nil
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                    [addAlert show];
                } else {
                    [[CBDBMethods sharedTools] insertServiceDetails:Dict];
                    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                                       message:[[CBStrings sharedStrings] getAlertMessage:@"AddServiceStation"]
                                                                      delegate:self
                                                             cancelButtonTitle:@"OK"
                                                             otherButtonTitles:nil];
                    [addAlert show];
                }
            } else {
                [Dict setObject:_SStanID forKey:@"SSId"];
                [[CBDBMethods sharedTools] updateServiceStations:Dict];
                UIAlertView *updateAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                                      message:[[CBStrings sharedStrings] getAlertMessage:@"updateStation"]
                                                                     delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                [updateAlert show];
            }
            [self hideProgressHud];
        });
    });
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

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self goBack];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
