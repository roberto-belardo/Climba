//
//  Activity.h
//  iClimb
//
//  Created by Roberto Belardo on 21/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <Parse/Parse.h>
#import "Repetition.h"

@interface Activity : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

//Properties
@property (retain) NSString *type;
@property (retain) NSString *content;
@property (retain) Repetition *repetition;

@end
