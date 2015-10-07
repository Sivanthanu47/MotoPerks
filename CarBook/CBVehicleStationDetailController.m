//
//  CBVehicleStationDetailController.m
//  CarBook
//
//  Created by Raja Sekhar on 02/02/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBVehicleStationDetailController.h"
#import "CBVehicleServiceStationAddController.h"
#import "CBDBMethods.h"
#import "CBStrings.h"

@interface CBVehicleStationDetailController ()
@end

UILabel *customLbl;

@implementation CBVehicleStationDetailController
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
    [self setNavigationBar];
    arrImg = [[NSMutableArray alloc] initWithObjects:@"Yellow.png",@"Green.png",@"Red.png",@"Yellow.png",@"Green.png", nil];
    arrStan = [[NSMutableArray alloc] init];
    [arrStan addObjectsFromArray:[[CBDBMethods sharedTools] getStationWithMap:_stationID]];
    NSMutableDictionary *dict = [arrStan lastObject];
    self.title = [dict objectForKey:@"stationName"];
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
    CGRect frameimgdeveloper = CGRectMake(0, 0, 44, 27);
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:frameimgdeveloper];
    [btnDeveloper setTitle:@"Edit" forState:UIControlStateNormal];
    [btnDeveloper setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goEdit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goEdit {
    CBVehicleServiceStationAddController *viewController;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        viewController = [[CBVehicleServiceStationAddController alloc] initWithNibName:@"CBVehicleServiceStationAddController" bundle:nil];
        viewController.SStanID = _stationID;
    } else {
        viewController = [[CBVehicleServiceStationAddController alloc] initWithNibName:@"CBVehicleServiceStationAddController_iPad" bundle:nil];
        viewController.SStanID = _stationID;
    }
    [self.navigationController pushViewController:viewController animated:YES];
}
- (UILabel *)labelBorder {
    customLbl = [[UILabel alloc] initWithFrame:CGRectMake(tblViewStation.frame.origin.x+50, 5, tblViewStation.frame.size.width-60, 40)];
    customLbl.textColor = [UIColor grayColor];
    customLbl.font = [UIFont systemFontOfSize:18.0];
    [customLbl.layer setCornerRadius:5.0];
    [customLbl.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [customLbl.layer setBorderWidth:1.0];
    return customLbl;
}

#pragma mark- tableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        return 80;
    }
    return 50.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrImg count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        NSMutableDictionary *stationDict = [arrStan lastObject];
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.firstLineHeadIndent = 5;
        if (indexPath.row == 0) {
            lblStationName = [self labelBorder];
            lblStationName.attributedText = [[NSAttributedString alloc] initWithString:[stationDict objectForKey:@"stationName"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
            [cell addSubview:lblStationName];
        }
               if (indexPath.row == 1) {
            lblAddCity = [self labelBorder];
            lblAddCity.attributedText = [[NSAttributedString alloc] initWithString:[stationDict objectForKey:@"AddCity"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
            [cell addSubview:lblAddCity];
        }
        if (indexPath.row == 2) {
            lblAddress = [self labelBorder];
            lblAddress.attributedText = [[NSAttributedString alloc] initWithString:[stationDict objectForKey:@"Address"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
            [cell addSubview:lblAddress];
        }
        if (indexPath.row == 3) {
            lblPhone = [self labelBorder];
            lblPhone.attributedText = [[NSAttributedString alloc] initWithString:[stationDict objectForKey:@"PhoneNo"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
            [cell addSubview:lblPhone];
        }
        if (indexPath.row == 4) {
            lblContactNo = [self labelBorder];
            lblContactNo.attributedText = [[NSAttributedString alloc] initWithString:[stationDict objectForKey:@"ContactNo"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
            [cell addSubview:lblContactNo];
        }
        if (indexPath.row == 5) {
            lblNotes = [self labelBorder];
            lblNotes.attributedText = [[NSAttributedString alloc] initWithString:[stationDict objectForKey:@"Notes"] attributes:@{NSParagraphStyleAttributeName: paragraphStyle}];
            [cell addSubview:lblNotes];
        }

        NSString *imageName = [NSString stringWithFormat:@"%@",[arrImg objectAtIndex:indexPath.row]];
        UIImage *image = [UIImage imageNamed:imageName];
        cell.imageView.image = image;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor =[ UIColor whiteColor];
    }
    return cell;
}
- (IBAction)deleteStation {
    UIAlertView *deleteAlert = [[UIAlertView alloc] initWithTitle:[[CBStrings sharedStrings] getString:@"app_name"]
                                                          message:[[CBStrings sharedStrings] getAlertMessage:@"deleteStation"]
                                                         delegate:self
                                                cancelButtonTitle:@"No"
                                                otherButtonTitles:@"Yes", nil];
    [deleteAlert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [[CBDBMethods sharedTools] deleteServiceStation:_stationID];
        [self goBack];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
