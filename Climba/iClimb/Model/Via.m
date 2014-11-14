//
//  Via.m
//  iClimb
//
//  Created by Roberto Belardo on 29/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "Via.h"
#import <Parse/PFObject+Subclass.h>

@implementation Via

+ (NSString *)parseClassName {
    return @"via";
}

@dynamic settore, nome, grado, frazioneGrado, numeroValutazioni, bellezza, votiBellezza;

- (NSString *) computeFrazioneGrado:(NSNumber *)valutazione {
    
    double oldFrazione = [[self objectForKey:@"frazioneGrado"] doubleValue];
    int numValutazioni = [[self objectForKey:@"numeroValutazioni"] intValue];
    
    double frazione = ((oldFrazione * numValutazioni) + [valutazione intValue] )/ (numValutazioni + 1);
    
    return [@(frazione) stringValue];
}

- (NSString *) computeBellezza:(int)valutazione {
    
    int oldBellezza = [[self objectForKey:@"bellezza"] intValue];
    int numVoti = [[self objectForKey:@"votiBellezza"] intValue];
    
    int bellezza = ((oldBellezza * numVoti) + valutazione )/ (numVoti + 1);
    
    return [@(bellezza) stringValue];;
}

@end
