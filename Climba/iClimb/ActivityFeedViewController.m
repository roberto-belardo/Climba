//
//  ActivityFeedViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 23/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "ActivityFeedViewController.h"
#import "TSMessage.h"

@interface ActivityFeedViewController ()

@end

@implementation ActivityFeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Feed"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.activityFeedTableViewController = [ActivityFeedTableViewController new];
    
    UIBarButtonItem *findFriendsButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"addButton.png"]
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(findFriends)];
    self.navigationItem.rightBarButtonItem = findFriendsButtonItem;
    
    //PFRelation
    PFRelation *relation = [[PFUser currentUser] objectForKey:@"following"];
    
    if (relation) {
        //PFQuery on every friends Activity
        PFQuery *query = [Activity query];
        [query whereKey:@"fromUser" matchesQuery:[relation query]];
        [query whereKey:@"type" notEqualTo:@"follow"];
        [query includeKey:@"repetition.via"];
        [query includeKey:@"fromUser"];
        query.cachePolicy = kPFCachePolicyNetworkOnly;
        [query orderByDescending:@"createdAt"];
        self.activityFeedTableViewController.query = query;
    }
    
    self.activityFeedTableViewController.view.frame = CGRectMake(0, 0, 320, self.view.bounds.size.height);
    [self addChildViewController:self.activityFeedTableViewController];
    [self.view addSubview:self.activityFeedTableViewController.view];
    [self.activityFeedTableViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) findFriends {
    
    if ([ReachabilityManager isReachable]) {
        
        FindFriendsViewController *findFriendsVC = [[FindFriendsViewController alloc] initWithNibName:@"FindFriendsViewController" bundle:nil];
        findFriendsVC.delegate = self;
        [self presentViewController:findFriendsVC animated:YES completion:nil];
        
    } else {
        [Utility networkUnreachableTSMessage:self];
    }
}

#pragma mark - FindFriendsViewControllerDelegate

- (void) didDismissFindFriendsVC {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
