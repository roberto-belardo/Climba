//
//  Repetition.m
//  iClimb
//
//  Created by Roberto Belardo on 18/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "Repetition.h"
#import <Parse/PFObject+Subclass.h>

@implementation Repetition

+ (NSString *)parseClassName {
    return @"Repetition";
}

@dynamic via, type, stars, comment, gradoProposto, settore, falesia;

@end
