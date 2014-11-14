//
//  RegionsListViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 27/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "RegionsListViewController.h"

@interface RegionsListViewController ()

@end

@implementation RegionsListViewController

@synthesize regionsArray;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"Routes"];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    UIBarButtonItem *reloadFalesieBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reloadButton.png"]
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(reloadFalesie)];
    self.navigationItem.rightBarButtonItem = reloadFalesieBarButtonItem;
    
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.regionsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"RegionCell";
    RegionCell *cell = (RegionCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"RegionCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
	Region *region = [self.regionsArray objectAtIndex:indexPath.row];
    cell.region = region;
    [cell initCell];
    
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Region *region = [self.regionsArray objectAtIndex:indexPath.row];
    
    if (region.falesie != 0) {
        return indexPath;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FalesieListViewController *falesieListVC = [[FalesieListViewController alloc] init];
    Region *region = [self.regionsArray objectAtIndex:indexPath.row];
    falesieListVC.regione = region;
    
    [self.navigationController pushViewController:falesieListVC animated:YES];

}

#pragma mark - ()
- (void)reloadFalesie {
    
    if ([ReachabilityManager isReachable]) {
        [PFCloud callFunctionInBackground:@"countFalesieForRegions"
                           withParameters:@{}
                                    block:^(NSDictionary *results, NSError *error) {
                                        if (!error) {
                                            [[Cache sharedCache] setFalesieNumberPerRegion:results];
                                            
                                            self.regionsArray = [Utility configureRegionsListWithFalesie:results];
                                            [self.tableView reloadData];
                                            
                                        }else {
                                            [TSMessage showNotificationInViewController:self
                                                                                  title:@"Something went wrong :("
                                                                               subtitle:@"Our climbers didn't reach the top. Please try again in a while."
                                                                                   type:TSMessageNotificationTypeError];
                                        }
                                    }];
    }else{
        [Utility networkUnreachableTSMessage:self];
    }
    
    
}

@end
