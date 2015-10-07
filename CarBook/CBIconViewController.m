//
//  CBIconViewController.m
//  CarBook
//
//  Created by Raja T S Sekhar on 24/08/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "CBIconViewController.h"
#import "CBStrings.h"
@interface CBIconViewController ()

@end

@implementation CBIconViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    iconsArray = [NSArray arrayWithObjects:@"Car",@"Van",@"Traveller",@"Minivan",@"Sportscar",@"Wagon",@"Truck",@"Bike",@"Scooter", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [iconsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [iconsArray objectAtIndex:indexPath.row];
    cell.backgroundColor =[UIColor clearColor];
    cell.textLabel.textColor = [[CBStrings sharedStrings]colorFromString:@"2B4074"];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
