//
//  FalesiaLocation.m
//  iClimb
//
//  Created by Roberto Belardo on 25/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "FalesiaLocation.h"

@interface FalesiaLocation ()
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CLLocationCoordinate2D theCoordinate;
@end

@implementation FalesiaLocation

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate {
    if ((self = [super init])) {
        if ([name isKindOfClass:[NSString class]]) {
            self.name = name;
        } else {
            self.name = @"Unknown charge";
        }
        self.theCoordinate = coordinate;
    }
    return self;
}

- (NSString *)title {
    return _name;
}

- (CLLocationCoordinate2D)coordinate {
    return _theCoordinate;
}

- (MKMapItem*)mapItem {
//    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:nil];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
