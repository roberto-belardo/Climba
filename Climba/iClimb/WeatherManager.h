//
//  WeatherManager.h
//  iClimb
//
//  Created by Roberto Belardo on 26/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

@import Foundation;
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa/ReactiveCocoa.h>
#import "WeatherCondition.h"

@interface WeatherManager : NSObject //<CLLocationManagerDelegate>

//+ (instancetype)sharedManager;

@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;

- (void)findWeatherForecastsForLatitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude;

@end
