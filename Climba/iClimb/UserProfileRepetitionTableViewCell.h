//
//  UserProfileRepetitionTableViewCell.h
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserProfileRepetitionTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeFalesiaAndSectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *repetitionCommentLabel;
@property (weak, nonatomic) IBOutlet UILabel *repetitionDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *repetitionModeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *repetitionBeautyImageView;


@end
