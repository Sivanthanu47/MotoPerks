//
//  CBVehicleServiceStationViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 10/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBVehicleServiceStationController : UIViewController<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate> {
    NSMutableArray *arrSSDetails,*arrKM;
    IBOutlet UITableView *tblStation;
    IBOutlet UISearchBar *searchbar;
}
@property (nonatomic,strong) NSString *strViewName;
@end