//
//  UserProfileViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 23/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoggedInProtocol.h"
#import "Cache.h"
#import "UserProfileRepetitionTableViewController.h"
#import "SettingsTableViewController.h"
#import "UIImageView+AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIImage+Resize.h"
#import "Utility.h"

@interface UserProfileViewController : UIViewController <SettingsViewControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, MBProgressHUDDelegate, UINavigationControllerDelegate> {
    
    MBProgressHUD *HUD;
    MBProgressHUD *refreshHUD;
}

@property (weak, nonatomic) PFUser *user;
@property (weak, nonatomic) id<LoggedInProtocol> delegate;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *navBarBackground;
@property (strong, nonatomic) IBOutlet UIImageView *userProfilePictureImageView;
@property (strong, nonatomic) IBOutlet UIButton *userProfilePictureButton;
@property (strong, nonatomic) IBOutlet UIImageView *profileHeaderDividerImageView;
@property (strong, nonatomic) IBOutlet UIImageView *lastRepetitionsHeaderImageView;
@property (strong, nonatomic) IBOutlet UILabel *bestRepetitionLabel;
@property (strong, nonatomic) IBOutlet UILabel *lastRepetitionLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthlyRoutes;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@property (strong, nonatomic) IBOutlet UIButton *followButton;


@property (nonatomic, retain) UINavigationController *settingsNavController;
@property (strong, nonatomic) UserProfileRepetitionTableViewController *repetitionTableViewController;

- (IBAction)settingsClicked:(id)sender;
- (IBAction)userProfilePictureButtonClicked:(id)sender;
- (IBAction)followUnfollowButtonClicked:(id)sender;

@end
