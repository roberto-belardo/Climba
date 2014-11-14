//
//  Settore.h
//  iClimb
//
//  Created by Roberto Belardo on 29/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <Parse/Parse.h>
#import "Falesia.h"

@interface Settore : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

//Properties
@property (retain) NSString *nome;
@property (retain) Falesia *falesia;
@property (retain) NSMutableArray *routes;
@property (retain) NSNumber *numVie;


@end
