//
//  CBReportViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 25/02/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBReportViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    IBOutlet UITableView *tblReport;
    NSMutableArray *arrReport;
    IBOutlet UISearchBar *searchbar;
}
@end
