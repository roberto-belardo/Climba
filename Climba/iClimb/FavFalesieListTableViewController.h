//
//  FavFalesieListTableViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 03/10/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Region.h"
#import "Falesia.h"
#import "FalesiaCell.h"
#import "RoutesListViewController.h"
#import "FalesiaDetailViewController.h"

@interface FavFalesieListTableViewController : PFQueryTableViewController <FalesiaDetailViewControllerDelegate>

@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) NSMutableArray *searchResults;

@end
