//
//  RoutesListViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 28/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <Parse/Parse.h>
#import "Falesia.h"
#import "Settore.h"
#import "Via.h"
#import "RouteCell.h"
#import "RouteViewController.h"

@interface RoutesListViewController : UITableViewController

@property (nonatomic, weak) Falesia *falesia;
@property (nonatomic, retain) NSMutableArray *settori;

@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) NSMutableArray *searchResults;

@end
