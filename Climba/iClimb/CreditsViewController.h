//
//  CreditsViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "PAPConstants.h"

@interface CreditsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
- (IBAction)goToAuthorWebSite:(id)sender;

@end
