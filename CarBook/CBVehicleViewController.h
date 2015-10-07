//
//  CBVechileViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 05/11/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBVehicleViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    IBOutlet UITableView *tblCar;
    IBOutlet UISearchBar *searchbar;
    NSMutableArray *getCarName;
    NSArray *arrFuelType;
    UIToolbar *pickerToolbar;
    UIView* popoverView;
}
@end
