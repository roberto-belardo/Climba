//
//  Via.h
//  iClimb
//
//  Created by Roberto Belardo on 29/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <Parse/Parse.h>
#import "Settore.h"

@interface Via : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

//Properties
@property (retain) Settore *settore;
@property (retain) NSString *nome;
@property (retain) NSString *grado;
@property (retain) NSString *frazioneGrado;
@property (retain) NSNumber *numeroValutazioni;
@property (retain) NSString *bellezza;
@property (retain) NSNumber *votiBellezza;

- (NSString *) computeFrazioneGrado:(NSNumber *)valutazione;
- (NSString *) computeBellezza:(int)valutazione;

@end
