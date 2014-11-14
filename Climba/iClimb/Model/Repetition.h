//
//  Repetition.h
//  iClimb
//
//  Created by Roberto Belardo on 18/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <Parse/Parse.h>
#import "Via.h"

@interface Repetition : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

//Properties
@property (retain) Via *via;
@property (retain) NSString *type;
@property (retain) NSNumber *stars;
@property (retain) NSString *comment;
@property (retain) NSString *gradoProposto;
@property (retain) NSString *settore;
@property (retain) NSString *falesia;

@end
