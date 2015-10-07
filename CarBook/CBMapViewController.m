//
//  CBMapViewController.m
//  CarBook
//
//  Created by Raja Sekhar on 11/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "CBMapViewController.h"
#import <MapKit/MapKit.h>
#import "CBStrings.h"
#import "CBDBMethods.h"
#import "MapViewAnnotation.h"

@interface CBMapViewController ()
@end

#define METERS_PER_MILE 160.0
#define MINIMUM_ZOOM_ARC 0.014
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360

@implementation CBMapViewController
@synthesize stationID;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated {
    self.title = @"Location";
    [self setNavigationBar];
    arrMap = [[NSMutableArray alloc] init];
    if (stationID == nil) {
        [arrMap addObjectsFromArray:[[CBDBMethods sharedTools] getServiceStationDetails]];
    } else {
        [arrMap addObjectsFromArray:[[CBDBMethods sharedTools] getStationWithMap:stationID]];
    }
    if ([arrMap count] <= 0 ) {
        return;
    }
    [mapView addAnnotations:[self createAnnotations]];
    [self zoomMapViewToFitAnnotations:mapView];
}
- (void)setNavigationBar {
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blueColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor blueColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.leftBarButtonItems = [self getTopMenuLeft];
    self.navigationItem.rightBarButtonItems = [self getTopMenuRight];
}
- (NSMutableArray *)getTopMenuLeft {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    CGRect frameimgdeveloper = CGRectMake(0, 0, 44, 27);
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:frameimgdeveloper];
    [btnDeveloper setTitle:@"Back" forState:UIControlStateNormal];
    [btnDeveloper setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (NSMutableArray *)getTopMenuRight {
    NSMutableArray *barButtonItems = [[NSMutableArray alloc] init];
    CGRect frameimgdeveloper = CGRectMake(0, 0, 50, 27);
    UIButton *btnDeveloper = [[UIButton alloc] initWithFrame:frameimgdeveloper];
    [btnDeveloper setTitle:@"Home" forState:UIControlStateNormal];
    [btnDeveloper setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnDeveloper addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barbtnDeveloper = [[UIBarButtonItem alloc] initWithCustomView:btnDeveloper];
    [barButtonItems addObject:barbtnDeveloper];
    return barButtonItems;
}
- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)goHome {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - MKMapViewDelegate Methods
- (NSMutableArray *)createAnnotations {
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    for (NSDictionary *row in arrMap) {
        NSString *title = [row objectForKey:@"stationName"];
        CLLocationCoordinate2D coord;
        coord.latitude = [[row objectForKey:@"Latitude"] doubleValue];
        coord.longitude = [[row objectForKey:@"Longitude"] doubleValue];
        MapViewAnnotation *annotation = [[MapViewAnnotation alloc] initWithTitle:title AndCoordinate:coord];
        [annotations addObject:annotation];
    }
    return annotations;
}
- (void)zoomMapViewToFitAnnotations:(MKMapView *)map {
    NSArray *annotations = map.annotations;
    NSUInteger count = [map.annotations count];
    MKMapPoint points[count];
    for(int i=0; i<count; i++) {
        CLLocationCoordinate2D coord = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coord);
    }
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    if(region.span.latitudeDelta > MAX_DEGREES_ARC) {
        region.span.latitudeDelta  = MAX_DEGREES_ARC;
    }
    if(region.span.longitudeDelta > MAX_DEGREES_ARC) {
        region.span.longitudeDelta = MAX_DEGREES_ARC;
    }
    if(region.span.latitudeDelta  < MINIMUM_ZOOM_ARC) {
        region.span.latitudeDelta  = MINIMUM_ZOOM_ARC;
    }
    if(region.span.longitudeDelta < MINIMUM_ZOOM_ARC) {
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    if(count == 1) {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:YES];
}
- (MKAnnotationView *) mapView:(MKMapView *)thisMapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *busStopViewIdentifier = @"BusStopViewIdentifier";
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[thisMapView dequeueReusableAnnotationViewWithIdentifier:busStopViewIdentifier];
    if(annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:busStopViewIdentifier];
    }
    annotationView.pinColor = MKPinAnnotationColorGreen;
    annotationView.animatesDrop = TRUE;
    annotationView.canShowCallout = YES;
    return annotationView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
