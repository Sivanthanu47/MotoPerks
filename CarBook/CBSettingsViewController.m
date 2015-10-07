//
//  CBSettingsViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 12/01/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBSettingsViewController.h"
#import "CBStrings.h"
#import "Constants.h"
#import "CBDBMethods.h"

int chosenFuelRow = 0,chosenRemRow = 0;
int chosenFuelSection = 0,chosenRemSection = 0;
BOOL action;

@interface CBSettingsViewController ()
@end

@implementation CBSettingsViewController

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
    [tblSettings.layer setCornerRadius:kCornerRadius];
    [tblSettings.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [tblSettings.layer setBorderWidth:kBorderWidth];
   
}
- (void)viewWillAppear:(BOOL)animated {
    self.title = [[CBStrings sharedStrings] getPageTitle:@"SettingsPage"];
    arrFuel = [NSArray arrayWithObjects:@"Petrol", @"Diesel",@"Gasoline", nil];
    arrRem = [NSArray arrayWithObjects:@"Reminder / Alert",@"OneDay",@"OneWeek",@"Kilometers",@"Above 4000 km",@"4000km", nil];
    arrSendRem = [NSArray arrayWithObjects:@"SMS",@"EMail",@"Application", nil];
    [self setNavigationBar];
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

#pragma mark - TableViewDelegates
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [arrSendRem count];
    }
    if (section == 1) {
        BOOL notifin = [[NSUserDefaults standardUserDefaults] boolForKey:@"Notification"];
        if (!notifin) {
            return 1;
        }
        return [arrRem count];
    }
    return [arrFuel count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"S%1ldR%1ld",(long)indexPath.section,(long)indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
        if (indexPath.section == 0) {
            BOOL Sms = [[NSUserDefaults standardUserDefaults] boolForKey:@"SMS"];
            BOOL Email = [[NSUserDefaults standardUserDefaults] boolForKey:@"EMail"];
            BOOL Application = [[NSUserDefaults standardUserDefaults] boolForKey:@"Application"];
            if (Sms && indexPath.row == 0) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            if (Email && indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            if (Application && indexPath.row == 2) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            cell.textLabel.text = [arrSendRem objectAtIndex:indexPath.row];
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                UISwitch *aSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                aSwitch.tag = [indexPath row];
                CGRect rect = tblSettings.frame;
                CGRect switchRect = aSwitch.frame;
                switchRect.origin = CGPointMake((rect.size.width-5) - (aSwitch.frame.size.width),cell.frame.size.height/7);
                aSwitch.frame = switchRect;
                [aSwitch addTarget:self action:@selector(switchSwitched:) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:aSwitch];
                BOOL notifin = [[NSUserDefaults standardUserDefaults] boolForKey:@"Notification"];
                if (notifin) {
                    [aSwitch setOn:YES animated:YES];
                }
                cell.textLabel.text = [arrRem objectAtIndex:indexPath.row];
            }
            if (indexPath.row == 1) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                cell.textLabel.text = [NSString stringWithFormat:@"\t%@",[arrRem objectAtIndex:indexPath.row]];
            }
            if (indexPath.row == 2) {
                BOOL week = [[NSUserDefaults standardUserDefaults] boolForKey:@"Week"];
                if (week) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                }
                cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                cell.textLabel.text = [NSString stringWithFormat:@"\t%@",[arrRem objectAtIndex:indexPath.row]];
            }
            if (indexPath.row==3) {
                cell.textLabel.text = [arrRem objectAtIndex:indexPath.row];
                
            }
            if (indexPath.row == 4) {
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                    cell.textLabel.text = [NSString stringWithFormat:@"\t%@",[arrRem objectAtIndex:indexPath.row]];
            }
            if (indexPath.row == 5) {
                    BOOL kilometer = [[NSUserDefaults standardUserDefaults] boolForKey:@"kilometer"];
                    if (kilometer) {
                        cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
                    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
                    cell.textLabel.text = [NSString stringWithFormat:@"\t%@",[arrRem objectAtIndex:indexPath.row]];
            }
        }
        if (indexPath.section == 2) {
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"fuel"] isEqual:[arrFuel objectAtIndex:indexPath.row]]) {
                chosenFuelRow = indexPath.row;
                chosenFuelSection = indexPath.section;
                _checkedFuelIndexPath = [NSIndexPath indexPathForRow:chosenFuelRow inSection:chosenFuelSection];
            }
            cell.textLabel.text = [arrFuel objectAtIndex:indexPath.row];
            petrolText = [[UITextField alloc]initWithFrame:CGRectMake(200.0, 510.0, 70.0, 30.0)];
            DieselText = [[UITextField alloc]initWithFrame:CGRectMake(200.0, 555.0, 70.0, 30.0)];
            GasText = [[UITextField alloc]initWithFrame:CGRectMake(200.0, 597.0, 70.0, 30.0)];
            DieselText.backgroundColor = [UIColor clearColor];
            DieselText.textColor = [UIColor whiteColor];
            DieselText.text =@"65.35";
            petrolText.backgroundColor = [UIColor clearColor];
            petrolText.textColor = [UIColor whiteColor];
            petrolText.text =@"70.35";
            GasText.backgroundColor = [UIColor clearColor];
            GasText.textColor = [UIColor whiteColor];
            GasText.text =@"35.35";
            petrolText.delegate =self;
            DieselText.delegate = self;
            GasText.delegate =self;
            [tblSettings addSubview:petrolText];
            [tblSettings addSubview:DieselText];
            [tblSettings addSubview:GasText];
            [[NSUserDefaults standardUserDefaults]setObject:petrolText.text forKey:@"petrolprice"];
            [[NSUserDefaults standardUserDefaults]setObject:DieselText.text forKey:@"dieselprice"];
            [[NSUserDefaults standardUserDefaults]setObject:GasText.text forKey:@"gasprice"];
        }
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *v = (UITableViewHeaderFooterView *)view;
   v.backgroundView.backgroundColor = [UIColor whiteColor];
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            if (uncheckCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SMS"];
            } else {
                uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SMS"];
            }
        } else if (indexPath.row == 1) {
            if (uncheckCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"EMail"];
            } else {
                uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"EMail"];
            }
        } else {
            if (uncheckCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Application"];
            } else {
                uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Application"];
            }
        }
    } else if (indexPath.section == 1) {
        if (indexPath.row == 2) {
            UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
            if (uncheckCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Week"];
            } else {
                uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Week"];
            }
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [[Constants sharedPath] setLocalNotification];
        }
        else if (indexPath.row == 5){
            UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:indexPath];
            if (uncheckCell.accessoryType == UITableViewCellAccessoryCheckmark) {
                uncheckCell.accessoryType = UITableViewCellAccessoryNone;
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"kilometer"];
            } else {
                uncheckCell.accessoryType = UITableViewCellAccessoryCheckmark;
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"kilometer"];
            }
            [[UIApplication sharedApplication] cancelAllLocalNotifications];
            [[Constants sharedPath] setLocalNotification];

        }
    }
    /*else if (indexPath.section == 2) {
        if (_checkedFuelIndexPath) {
            _checkedFuelIndexPath = [NSIndexPath indexPathForRow:chosenFuelRow inSection:chosenFuelSection];
            UITableViewCell *uncheckCell = [tableView cellForRowAtIndexPath:_checkedFuelIndexPath];
            uncheckCell.accessoryType = UITableViewCellAccessoryNone;
        }
        chosenFuelRow = indexPath.row;
        chosenFuelSection = indexPath.section;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        _checkedFuelIndexPath = [NSIndexPath indexPathForRow:chosenFuelRow inSection:chosenFuelSection];
        [[NSUserDefaults standardUserDefaults] setObject:[arrFuel objectAtIndex:indexPath.row] forKey:@"fuel"];
    }*/
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)txtField {
    petrolText.text = @"";
    DieselText.text = @"";
    GasText.text = @"";
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    petrolText = textField;
    DieselText = textField;
    GasText = textField;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *) txtField {
    [txtField resignFirstResponder];
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Remainders:";
    }
    if (section == 1) {
        return @"Remainders Options:";
    }
    return @"Fuel:";
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25;
}
- (void)switchSwitched:(UISwitch *)sender {
    if (sender.on) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Notification"];
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Notification"];
    }
    [tblSettings reloadData];
    [[Constants sharedPath] setLocalNotification];
}
@end
