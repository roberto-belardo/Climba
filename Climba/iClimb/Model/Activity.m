//
//  Activity.m
//  iClimb
//
//  Created by Roberto Belardo on 21/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "Activity.h"
#import <Parse/PFObject+Subclass.h>

@implementation Activity

+ (NSString *)parseClassName {
    return @"Activity";
}

@dynamic type, content, repetition;

@end
