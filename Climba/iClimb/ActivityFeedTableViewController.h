//
//  ActivityFeedTableViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 21/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <Parse/Parse.h>
#import "ActivityFeedCell.h"
#import "Activity.h"
#import "Repetition.h"
#import "Via.h"
#import "UIImageView+AFNetworking.h"
#import "ReachabilityManager.h"

@interface ActivityFeedTableViewController : PFQueryTableViewController

@property (nonatomic, strong) PFQuery *query;

@end
