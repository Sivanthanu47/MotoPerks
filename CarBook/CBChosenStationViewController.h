//
//  CBChosenStationViewController.h
//  CarBook
//
//  Created by Raja T S Sekhar on 08/05/15.
//  Copyright (c) 2015 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBChosenStationViewController : UIViewController
{
    IBOutlet UITableView * stationTable;
    IBOutlet UIButton * frequentlyUsed;
    IBOutlet UIButton * nearMe;
    IBOutlet UIImageView * arrowImg,*arrowNear;
     NSMutableArray *frequentArrGasStation, *nearMeArr ;
    NSString * strStationName;
}
-(IBAction)frequentStations:(id)sender;
-(IBAction)nearme:(id)sender;
@end
