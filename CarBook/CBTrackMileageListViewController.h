//
//  CBTrackMileageListViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 23/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBTrackMileageListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate> {
    IBOutlet UITableView *tblTrack;
    NSMutableArray *arrTracks;
    IBOutlet UISearchBar *searchbar;
}

@end
