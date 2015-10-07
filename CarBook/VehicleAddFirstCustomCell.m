//
//  VehicleAddFirstCustomCell.m
//  CarBook
//
//  Created by Raja Sekhar on 26/03/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import "VehicleAddFirstCustomCell.h"

@implementation VehicleAddFirstCustomCell
@synthesize txtOwner,txtLic,txtCarName,txtVIN,txtInsName,txtCMRead,txtFuel,btnDate,btnReg,btnTake,btnPick,btnFuelType,ImgVehicle,Address;
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
