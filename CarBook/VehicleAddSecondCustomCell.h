//
//  VehicleAddSecondCustomCell.h
//  CarBook
//
//  Created by Raja Sekhar on 26/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VehicleAddSecondCustomCell : UITableViewCell
@property (nonatomic, retain) IBOutlet UIButton *firstService,*SerKmInt,*lastServiceDate,*serMonthInterval;
@property (nonatomic, retain) IBOutlet UITextView *txtNote,*txtAddress;
@property (nonatomic, retain) IBOutlet UITextField *sellerName;
@property (nonatomic, retain) IBOutlet UISwitch *ChoSerSwitch;
@end
