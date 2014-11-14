//
//  WeatherDailyForecast.m
//  iClimb
//
//  Created by Roberto Belardo on 26/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "WeatherDailyForecast.h"

@implementation WeatherDailyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey {

    NSMutableDictionary *paths = [[super JSONKeyPathsByPropertyKey] mutableCopy];

    paths[@"tempHigh"] = @"temp.max";
    paths[@"tempLow"] = @"temp.min";

    return paths;
}

@end
