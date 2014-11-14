//
//  MainViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 30/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserProfileViewController.h"
#import "ActivityFeedViewController.h"
#import "FavFalesieListTableViewController.h"
#import "RegionsListViewController.h"

@interface MainViewController : UITabBarController

@property (strong, nonatomic) UserProfileViewController *userProfileVC;
@property (strong, nonatomic) ActivityFeedViewController *activityFeedVC;
@property (strong, nonatomic) RegionsListViewController *regionListVC;
@property (strong, nonatomic) FavFalesieListTableViewController *favFalesieListVC;

@property (nonatomic, strong) NSMutableArray *regionsArray;
@property (nonatomic, copy) NSDictionary *falesie;

@property (nonatomic, retain) UINavigationController *routesNavController;
@property (nonatomic, retain) UINavigationController *favFalesieNavController;
@property (nonatomic, retain) UINavigationController *activitiesNavController;

- (id)initWithFalesie:(NSDictionary *)falesie;

@end
