//
//  RegionsListViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 27/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Region.h"
#import "RegionCell.h"
#import <Parse/Parse.h>
#import "Falesia.h"
#import "FalesieListViewController.h"
#import "TSMessage.h"
#import "ReachabilityManager.h"

@interface RegionsListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *regionsArray;

@end
