//
//  RepetitionCell.m
//  iClimb
//
//  Created by Roberto Belardo on 20/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "RepetitionCell.h"

@implementation RepetitionCell
@synthesize repetitionModeLBL, userNameLBL;

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

@end
