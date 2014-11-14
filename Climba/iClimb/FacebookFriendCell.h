//
//  FacebookFriendCell.h
//  iClimb
//
//  Created by Roberto Belardo on 02/03/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FacebookFriendCellDelegate;

@interface FacebookFriendCell : UITableViewCell {
    id _delegate;
}

@property (strong, nonatomic) id<FacebookFriendCellDelegate> delegate;

@property (strong, nonatomic) IBOutlet UILabel *usernameLBL;
@property (strong, nonatomic) IBOutlet UIButton *inviteBTN;
@property (retain, nonatomic) NSString *facebookID;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicture;

- (IBAction)inviteButtonClicked:(id)sender;

@end

@protocol FacebookFriendCellDelegate <NSObject>
@optional

- (void)cell:(FacebookFriendCell*)cellView didTapInviteButton:(NSString *)facebookID;

@end
