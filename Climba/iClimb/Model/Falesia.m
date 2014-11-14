//
//  Falesia.m
//  iClimb
//
//  Created by Roberto Belardo on 28/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "Falesia.h"
#import <Parse/PFObject+Subclass.h>

@implementation Falesia

+ (NSString *)parseClassName {
    return @"falesia";
}

@dynamic nome, nazione, provincia, provinciaShort, regione, descrizione, accesso, numSettori, numVie;

@end
