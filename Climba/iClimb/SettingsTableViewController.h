//
//  SettingsTableTableViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Setting.h"
#import "CreditsViewController.h"
#import <Parse/Parse.h>
#import "TSMessage.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "AppWalkthroughContainerViewController.h"

@protocol SettingsViewControllerDelegate <NSObject>

- (void) didDismissSettingsVC;
- (void) loggedOutSettingClicked;
- (void) updateProfileWithFacebookInfoAfterSuccesfullLinkToFacebook;
- (void) updateProfileAfterSuccesfullUnlinkFromFacebook;

@end

@interface SettingsTableViewController : UITableViewController <AppWalkthroughContainerDelegate>

@property (weak, nonatomic) id<SettingsViewControllerDelegate> delegate;

@property (nonatomic, retain) NSMutableArray *settings;

@end
