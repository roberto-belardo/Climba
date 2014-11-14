//
//  FalesiaLocation.h
//  iClimb
//
//  Created by Roberto Belardo on 25/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface FalesiaLocation : NSObject <MKAnnotation>

- (id)initWithName:(NSString*)name coordinate:(CLLocationCoordinate2D)coordinate;
- (MKMapItem*)mapItem;

@end
