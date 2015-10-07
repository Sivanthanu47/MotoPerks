//
//  CBMapViewController.h
//  CarBook
//
//  Created by Raja Sekhar on 11/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface CBMapViewController : UIViewController<MKMapViewDelegate> {
    IBOutlet MKMapView *mapView;
    CLLocationCoordinate2D coordinate;
    NSMutableArray *arrMap;
}
@property(nonatomic, strong) NSString *stationID;
@end
