//
//  RepetitionTableViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 20/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Repetition.h"
#import "Via.h"
#import "RepetitionCell.h"
#import "UserProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "ReachabilityManager.h"
#import "Utility.h"

@interface RepetitionTableViewController : PFQueryTableViewController

@property (nonatomic, strong) PFQuery *query;

@end
