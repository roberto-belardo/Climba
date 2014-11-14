//
//  Settore.m
//  iClimb
//
//  Created by Roberto Belardo on 29/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "Settore.h"
#import <Parse/PFObject+Subclass.h>

@implementation Settore

+ (NSString *)parseClassName {
    return @"settore";
}

@dynamic nome, falesia, numVie;

- (NSMutableArray *)routes {
    
    if(self.routes == nil){
        self.routes = [[NSMutableArray alloc] init];
    }
    
    return self.routes;
    
}

-(void)setRoutes:(NSMutableArray *)routes {
    if(self.routes == nil){
        self.routes = [[NSMutableArray alloc] init];
    }
    
    [self.routes addObjectsFromArray:routes];
}

@end
