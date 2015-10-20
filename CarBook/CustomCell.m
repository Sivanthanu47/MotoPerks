//
//  CustomCell.m
//  CustomUITableViewCell
//
//  Created by Kshitiz Ghimire on 3/18/11.
//  Copyright 2011 Javra Software. All rights reserved.
//

#import "CustomCell.h"

@implementation CustomCell

@synthesize carlbl,stationlbl,totcatlbl,datelbl,txtNoteLbl,costlbl,typelbl,txtCost,txtNote,btnType,btnDelete,btnAdd,btnFuelType,btnMonth,btnKM;
@synthesize txtServName,txtAddPlace,txtAddCity,txtPhone,txtEmail,txtMap,imgServName,imgAddPlace,imgAddCity,imgPhone,imgEmail,imgMap,txtFuelType,txtRate,txtQuantity,FirstarrImgView,SectarrImgView,lblMonthChange,lblkmChange,btnCost,txtContact,serviceAddr,Notes,txtVicinity;
@synthesize txtGasName,txtTrackCMRead,txtTrackFuel,txtTrackKM,btnTrackCar,btnGasName, lblTrackDate,lblFuelType;
@synthesize lblStationName,lblStationAdd,lblStationKm,btnMapPin,btnRate,btnQuantity;
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
