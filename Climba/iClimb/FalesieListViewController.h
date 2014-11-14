//
//  FalesieListViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 28/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <Parse/Parse.h>
#import "Region.h"
#import "Falesia.h"
#import "FalesiaCell.h"
#import "RoutesListViewController.h"
#import "FalesiaDetailViewController.h"

@interface FalesieListViewController : PFQueryTableViewController <FalesiaDetailViewControllerDelegate>

@property (nonatomic, weak) Region *regione;

@end
