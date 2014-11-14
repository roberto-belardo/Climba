//
//  RepetitionCell.h
//  iClimb
//
//  Created by Roberto Belardo on 20/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface RepetitionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userNameLBL;
@property (weak, nonatomic) IBOutlet UILabel *repetitionModeLBL;
@property (strong, nonatomic) IBOutlet UIImageView *avatarUIImageView;
@property (weak, nonatomic) IBOutlet UILabel *repetitionDate;
@property (weak, nonatomic) IBOutlet UILabel *repetitionComment;
@property (strong, nonatomic) IBOutlet UIImageView *repetitionBeautyImageView;

@property (nonatomic, strong) PFUser *user;

@end
