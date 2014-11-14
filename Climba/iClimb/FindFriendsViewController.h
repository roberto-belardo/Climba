//
//  FindFriendsViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 25/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFQueryFriendsViewController.h"
#import "Cache.h"
#import <Parse/Parse.h>
#import "FriendsListTableViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "ReachabilityManager.h"

@protocol FindFriendsViewControllerDelegate <NSObject>

- (void) didDismissFindFriendsVC;

@end


@interface FindFriendsViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) FriendsListTableViewController *friendsListTVC;

@property (weak, nonatomic) id<FindFriendsViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UIImageView *navBarBackground;
@property (strong, nonatomic) IBOutlet UITextField *searchFriendTextField;

- (IBAction)backButtonClicked:(id)sender;
- (IBAction)inviteFriendsButtonClicked:(id)sender;

@end
