//
//  UserProfileRepetitionTableViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Repetition.h"
#import "Via.h"
#import "Settore.h"
#import "Falesia.h"
#import "UserProfileRepetitionTableViewCell.h"
#import "ReachabilityManager.h"
#import "Utility.h"

@interface UserProfileRepetitionTableViewController : PFQueryTableViewController

@property (nonatomic, strong) PFQuery *query;

@end