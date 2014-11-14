//
//  MainViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 30/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithFalesie:(NSDictionary *)falesie {
    self = [super init];
    if (self) {
        self.falesie = falesie;
        self.regionsArray = [Utility configureRegionsListWithFalesie:self.falesie];
        
        self.userProfileVC = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil];
        self.userProfileVC.user = [PFUser currentUser];
        self.activityFeedVC = [[ActivityFeedViewController alloc] initWithNibName:@"ActivityFeedViewController" bundle:nil];
        
        self.favFalesieListVC = [FavFalesieListTableViewController new];
        self.favFalesieNavController = [[UINavigationController alloc] initWithRootViewController:self.favFalesieListVC];
        self.favFalesieNavController.navigationBar.barTintColor = [UIColor colorWithRed:33.0f/255.0f green:164.0f/255.0f blue:240.0f/255.0f alpha:1.0];
        self.favFalesieNavController.navigationBar.tintColor = [UIColor whiteColor];
        
        // Adding the Navigation Controller for the Routes Tab
        self.regionListVC = [RegionsListViewController new];
        self.regionListVC.regionsArray = [NSMutableArray arrayWithArray:self.regionsArray];
        self.routesNavController = [[UINavigationController alloc] initWithRootViewController:self.regionListVC];
        
        // Adding the Navigation Controller for the Activities Tab
        self.activitiesNavController = [[UINavigationController alloc] initWithRootViewController:self.activityFeedVC];
        
        //Configuring the style of the Navigation Bars
        self.routesNavController.navigationBar.barTintColor = [UIColor colorWithRed:33.0f/255.0f green:164.0f/255.0f blue:240.0f/255.0f alpha:1.0];
        self.activitiesNavController.navigationBar.barTintColor = [UIColor colorWithRed:33.0f/255.0f green:164.0f/255.0f blue:240.0f/255.0f alpha:1.0];
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
        self.routesNavController.navigationBar.tintColor = [UIColor whiteColor];
        self.activitiesNavController.navigationBar.tintColor = [UIColor whiteColor];
        
        //Configuring the style of the Tab Bar
        [[UITabBar appearance] setBackgroundImage:[UIImage imageNamed:@"tabBarBackground.png"]];
        
        [self setViewControllers:[NSArray arrayWithObjects:self.routesNavController, self.favFalesieNavController, self.activitiesNavController, self.userProfileVC, nil]];
        
        [[self.tabBar.items objectAtIndex:0] setImage:[[UIImage imageNamed:@"tabBarIcon0_notactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [[self.tabBar.items objectAtIndex:0] setSelectedImage:[[UIImage imageNamed:@"tabBarIcon0_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [[self.tabBar.items objectAtIndex:2] setImage:[[UIImage imageNamed:@"tabBarIcon1_notactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [[self.tabBar.items objectAtIndex:2] setSelectedImage:[[UIImage imageNamed:@"tabBarIcon1_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [[self.tabBar.items objectAtIndex:1] setImage:[[UIImage imageNamed:@"tabBarIcon3_notactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [[self.tabBar.items objectAtIndex:1] setSelectedImage:[[UIImage imageNamed:@"tabBarIcon3_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
        //[[UITabBar appearance] setTintColor:[UIColor whiteColor]];
        //[[UITabBar appearance] setSelectedImageTintColor:[UIColor redColor]];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateNormal];
        [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]} forState:UIControlStateSelected];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
