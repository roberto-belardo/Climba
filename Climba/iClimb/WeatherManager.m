//
//  WeatherManager.m
//  iClimb
//
//  Created by Roberto Belardo on 26/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "WeatherManager.h"
#import "WeatherClient.h"

@interface WeatherManager ()

@property (nonatomic, strong, readwrite) CLLocation *currentLocation;
@property (nonatomic, strong, readwrite) NSArray *dailyForecast;
@property (nonatomic, strong) WeatherClient *client;

@end

@implementation WeatherManager

//+ (instancetype)sharedManager {
//    static id _sharedManager = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        _sharedManager = [[self alloc] init];
//    });
//    
//    return _sharedManager;
//}

- (id)init {
    if (self = [super init]) {
        
        _client = [[WeatherClient alloc] init];
        
        [[[[RACObserve(self, currentLocation) ignore:nil]

           flattenMap:^(CLLocation *newLocation) {
               return [RACSignal merge:@[[self updateDailyForecast]]];
           }] deliverOn:RACScheduler.mainThreadScheduler]

         subscribeError:^(NSError *error) {
             NSLog(@"ERROR: There was a problem fetching the latest weather.");
         }];
    }
    return self;
}

- (void)findWeatherForecastsForLatitude:(CLLocationDegrees)latitude Longitude:(CLLocationDegrees)longitude {
    self.currentLocation = [[CLLocation alloc] initWithLatitude:(latitude) longitude:longitude];
}

- (RACSignal *)updateDailyForecast {
    return [[self.client fetchDailyForecastForLocation:self.currentLocation.coordinate] doNext:^(NSArray *conditions) {
        
        if (conditions) {
            self.dailyForecast = conditions;
        }
    }];
}

@end
