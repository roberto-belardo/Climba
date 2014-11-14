//
//  FacebookFriendCell.m
//  iClimb
//
//  Created by Roberto Belardo on 02/03/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "FacebookFriendCell.h"

@implementation FacebookFriendCell

@synthesize facebookID, delegate;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)inviteButtonClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(cell:didTapInviteButton:)]) {
        [self.delegate cell:self didTapInviteButton:self.facebookID];
    }
}
@end
