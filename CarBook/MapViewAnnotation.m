//
//  MapAnnotation.m
//  CarBook
//
//  Created by Raja Sekhar on 12/12/14.
//  Copyright (c) 2014 Raja Sekhar. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation

@synthesize coordinate=_coordinate;

@synthesize title=_title;

-(id) initWithTitle:(NSString *) title AndCoordinate:(CLLocationCoordinate2D)coordinate {
    self = [super init];
    _title = title;
    _coordinate = coordinate;
    return self;
}

@end
