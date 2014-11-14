//
//  RegionCell.h
//  iClimb
//
//  Created by Roberto Belardo on 27/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"

@interface RegionCell : UITableViewCell

@property (nonatomic, weak) Region *region;

@property (nonatomic, strong) IBOutlet UILabel *nameLabel;
@property (nonatomic, strong) IBOutlet UILabel *numberOfFalesie;
@property (nonatomic, strong) IBOutlet UILabel *falesieLabel;

- (void)initCell;

@end
