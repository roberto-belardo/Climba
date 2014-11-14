//
//  RegionCell.m
//  iClimb
//
//  Created by Roberto Belardo on 27/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "RegionCell.h"
#import <Parse/Parse.h>

@implementation RegionCell

@synthesize nameLabel;
@synthesize numberOfFalesie;
@synthesize falesieLabel;
@synthesize region;

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

- (void)initCell{
    self.falesieLabel.text = @"Falesie";
    self.nameLabel.text = self.region.nome;
    self.numberOfFalesie.text = [NSString stringWithFormat:@"%d", self.region.falesie];
    if (self.region.falesie == 0) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
}


+ (NSString *)reuseIdentifier {
    return @"RegionCell";
}

@end
