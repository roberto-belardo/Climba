//
//  ActivityFeedCell.h
//  iClimb
//
//  Created by Roberto Belardo on 21/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "UserProfileViewController.h"

@interface ActivityFeedCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userLBL;
@property (weak, nonatomic) IBOutlet UILabel *routeNameLBL;
@property (weak, nonatomic) IBOutlet UILabel *falesiaNameLBL;
@property (weak, nonatomic) IBOutlet UILabel *activityCreatedAtLBL;
@property (strong, nonatomic) IBOutlet UIImageView *routeBeautyImageView;
@property (weak, nonatomic) IBOutlet UILabel *routeGradeLBL;
@property (weak, nonatomic) IBOutlet UILabel *routeMode;
@property (strong, nonatomic) IBOutlet UIImageView *userProfilePictureImageView;

@property (strong, nonatomic) PFUser *user;
@end
