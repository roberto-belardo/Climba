//
//  LoggedInProtocol.h
//  iClimb
//
//  Created by Roberto Belardo on 23/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoggedInProtocol <NSObject>

@required
- (void) didLoggedOutSuccessfully;

@optional
- (void) linkAccountToFacebook;
- (void) unlinkAccountFromFacebook;

@end
