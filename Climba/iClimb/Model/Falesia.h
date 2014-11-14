//
//  Falesia.h
//  iClimb
//
//  Created by Roberto Belardo on 28/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <Parse/Parse.h>

@interface Falesia : PFObject<PFSubclassing>

+ (NSString *)parseClassName;

//Properties
@property (retain) NSString *nome;
@property (retain) NSString *nazione;
@property (retain) NSString *provincia;
@property (retain) NSString *provinciaShort;
@property (retain) NSString *regione;
@property (retain) NSString *descrizione;
@property (retain) NSString *accesso;
@property (retain) NSNumber *numSettori;
@property (retain) NSNumber *numVie;


@end
