//
//  CBTrackMileageViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 30/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBTrackMileageViewController.h"
#import "CBStrings.h"
#import "CBDBMethods.h"

@interface CBTrackMileageViewController ()

@end
NSMutableDictionary *trackDict;
@implementation CBTrackMileageViewController
@synthesize arrTrack;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    self.title = [[CBStrings sharedStrings] getPageTitle:@"TrackPage"];
    [self setNavigationBar];
    trackDict = [arrTrack lastObject];
    txtCar.text = [NSString stringWithFormat:@"%@",[trackDict objectForKey:@"CarName"]];
    txtDate.text = [NSString stringWithFormat:@"%@",[trackDict objectForKey:@"TrackDate"]];
    txtStation.text = [NSString stringWithFormat:@"%@",[trackDict objectForKey:@"stationName"]];
    //int intCMR = [[trackDict objectForKey:@"CMRead"] integerValue] + [[trackDict objectForKey:@"TrackKM"] integerValue];
    txtCMRead.text = [NSString stringWithFormat:@"Current Meter Read: %@ Mtr",[trackDict objectForKey:@"CMRead"]];
    txtKM.text = [NSString stringWithFormat:@"%@ Km",[trackDict objectForKey:@"TrackKM"]];
    [[NSUserDefaults standardUserDefaults]setObject:txtKM.text forKey:@"txtkm"];
    txtFuel.text = [NSString stringWithFormat:@"%@ %@",[trackDict objectForKey:@"NewFuel"],[trackDict objectForKey:@"FuelType"]];
    NSLog(@"txtFuel%@",[trackDict objectForKey:@"NewFuel"]);
    NSArray *paths = [[Constants sharedPath] getDocumentPath];
    NSString *imagePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[trackDict objectForKey:@"PhotoURL"]];
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    [imgCar.layer setCornerRadius:5.0];
    [imgCar.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [imgCar.layer setBorderWidth:1.0];
    imgCar.image = image;
    [imgCar setContentMode:UIViewContentModeScaleAspectFit];
    if (_isDeleteCheck) {
        deleteButton.hidden = NO;
    }
    else{
        deleteButton.hidden = YES;
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

- (IBAction)deleteTrackMileage:(id)sender {
    UIAlertView *addAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                       message:[[CBStrings sharedStrings] getAlertMessage:@"deleteTrack"]
                                                      delegate:self
                                             cancelButtonTitle:@"No"
                                             otherButtonTitles:@"Yes",nil];
    [addAlert show];
}


#pragma mark - AlertViewDelegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSMutableDictionary *dict = [arrTrack lastObject];
        CBDBMethods *CBDeleteTrack = [[CBDBMethods alloc] init];
        [CBDeleteTrack deleteTrackMileage:[dict objectForKey:@"TMId"]];
        [self goBack];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
