//
//  LoginProtocol.h
//  iClimb
//
//  Created by Roberto Belardo on 30/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginProtocol <NSObject>

- (void)didLoggedinSuccessfullyWith:(PFUser *)user;

@end
