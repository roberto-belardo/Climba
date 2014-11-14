//
//  PAPFindFriendsCell.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/31/12.
//

#import <Parse/Parse.h>

@class PAPProfileImageView;
@protocol PAPFindFriendsCellDelegate;

@interface FindFriendsCell : UITableViewCell {
    id _delegate;
}

@property (nonatomic, strong) id<PAPFindFriendsCellDelegate> delegate;

/*! The user represented in the cell */
@property (nonatomic, strong) PFUser *user;
@property (weak, nonatomic) IBOutlet UILabel *usernameLBL;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (strong, nonatomic) IBOutlet UIImageView *friendProfilePicture;


/*! Actions */
- (IBAction)followUnfollowButtonClicked:(id)sender;

/*! Setters for the cell's content */
- (void)setUser:(PFUser *)user;

- (void)didTapUserButtonAction:(id)sender;
//- (void)didTapFollowButtonAction:(id)sender;

/*! Static Helper methods */
+ (CGFloat)heightForCell;

@end

/*!
 The protocol defines methods a delegate of a PAPBaseTextCell should implement.
 */
@protocol PAPFindFriendsCellDelegate <NSObject>
@optional

/*!
 Sent to the delegate when a user button is tapped
 @param aUser the PFUser of the user that was tapped
 */
- (void)cell:(FindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser;
- (void)cell:(FindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser;

@end
