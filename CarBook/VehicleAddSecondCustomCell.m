//
//  VehicleAddSecondCustomCell.m
//  CarBook
//
//  Created by Raja Sekhar on 26/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "VehicleAddSecondCustomCell.h"

@implementation VehicleAddSecondCustomCell
@synthesize firstService,SerKmInt,serMonthInterval,txtNote,lastServiceDate,txtAddress,sellerName,ChoSerSwitch;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
@end
