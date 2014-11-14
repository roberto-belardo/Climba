//
//  ActivityFeedViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 23/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActivityFeedTableViewController.h"
#import "Cache.h"
#import "PFQueryFriendsViewController.h"
#import "FindFriendsViewController.h"

@interface ActivityFeedViewController : UIViewController <FindFriendsViewControllerDelegate>

@property (strong, nonatomic) ActivityFeedTableViewController  *activityFeedTableViewController;

@end
