//
//  PAPFindFriendsViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 22/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "PFQueryFriendsViewController.h"

typedef enum {
    PAPFindFriendsFollowingNone = 0,    // User isn't following anybody in Friends list
    PAPFindFriendsFollowingAll,         // User is following all Friends
    PAPFindFriendsFollowingSome         // User is following some of their Friends
} PAPFindFriendsFollowStatus;

@interface PFQueryFriendsViewController ()

@property (nonatomic, assign) PAPFindFriendsFollowStatus followStatus;
@property (nonatomic, strong) NSMutableDictionary *outstandingFollowQueries;

@end

@implementation PFQueryFriendsViewController

@synthesize followStatus;
@synthesize outstandingFollowQueries;

#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
        self.outstandingFollowQueries = [NSMutableDictionary dictionary];
        
        // The key of the PFObject to display in the label of the default cell style
        self.textKey = @"text";
        
        // Whether the built-in pull-to-refresh is enabled
        self.pullToRefreshEnabled = YES;
        
        // Whether the built-in pagination is enabled
        self.paginationEnabled = YES;
        
        // The number of objects to show per page
        self.objectsPerPage = 25;
        
        // Used to determine Follow/Unfollow All button status
        self.followStatus = PAPFindFriendsFollowingSome;
    }
    
    return self;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}


#pragma mark - UIViewController

- (void)viewDidLoad {
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    [super viewDidLoad];
    
    if (NSClassFromString(@"UIRefreshControl")) {
        // Use the new iOS 6 refresh control.
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl = refreshControl;
        self.refreshControl.tintColor = [UIColor colorWithRed:73.0f/255.0f green:55.0f/255.0f blue:35.0f/255.0f alpha:1.0f];
        [self.refreshControl addTarget:self action:@selector(refreshControlValueChanged:) forControlEvents:UIControlEventValueChanged];
        self.pullToRefreshEnabled = NO;
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.objects.count) {
        return [FindFriendsCell heightForCell];
    } else {
        return 44.0f;
    }
}

#pragma mark - PFQueryTableViewController

- (void)objectsWillLoad {
    [super objectsWillLoad];
    
    // This method is called before a PFQuery is fired to get more objects
}

- (void)objectsDidLoad:(NSError *)error {
    [super objectsDidLoad:error];
    
    // This method is called every time objects are loaded from Parse via the PFQuery
    
    if (NSClassFromString(@"UIRefreshControl")) {
        [self.refreshControl endRefreshing];
    }
    
    PFQuery *isFollowingQuery = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [isFollowingQuery whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    [isFollowingQuery whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [isFollowingQuery whereKey:kPAPActivityToUserKey containedIn:self.objects];
    [isFollowingQuery setCachePolicy:kPFCachePolicyNetworkOnly];
    
    [isFollowingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
        if (!error) {
            if (number == self.objects.count) {
                self.followStatus = PAPFindFriendsFollowingAll;
                for (PFUser *user in self.objects) {
                    [[Cache sharedCache] setFollowStatus:YES user:user];
                }
            } else if (number == 0) {
                self.followStatus = PAPFindFriendsFollowingNone;
                for (PFUser *user in self.objects) {
                    [[Cache sharedCache] setFollowStatus:NO user:user];
                }
            } else {
                self.followStatus = PAPFindFriendsFollowingSome;
            }
        }
        
    }];

}


 // Override to customize what kind of query to perform on the class. The default is to query for
 // all objects ordered by createdAt descending.
 - (PFQuery *)queryForTable {

     // Use cached Facebook friend ids
     NSArray *facebookFriends = [[Cache sharedCache] facebookFriends];
     
     PFQuery *friendsQuery = [PFUser query];
     
     // Construct a PFUser query that will find friends whose facebook ids
     // are contained in the current user's friend list.
     [friendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookFriends];
     [friendsQuery orderByAscending:kPAPUserDisplayNameKey];
     
     return friendsQuery;
     
 }

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object {
    
    static NSString *FriendCellIdentifier = @"friendCustomCell";
    
    FindFriendsCell *cell = (FindFriendsCell *)[tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"FindFriendsCell" bundle:nil] forCellReuseIdentifier:FriendCellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
        [cell setDelegate:self];
    }
    
    [cell setUser:(PFUser*)object];
    
    cell.followButton.selected = NO;
    cell.tag = indexPath.row;
    
    NSDictionary *attributes = [[Cache sharedCache] attributesForUser:(PFUser *)object];
    
    if (self.followStatus == PAPFindFriendsFollowingSome) {
        if (attributes) {
            [cell.followButton setSelected:[[Cache sharedCache] followStatusForUser:(PFUser *)object]];
        } else {
            @synchronized(self) {
                NSNumber *outstandingQuery = [self.outstandingFollowQueries objectForKey:indexPath];
                if (!outstandingQuery) {
                    [self.outstandingFollowQueries setObject:[NSNumber numberWithBool:YES] forKey:indexPath];
                    PFQuery *isFollowingQuery = [PFQuery queryWithClassName:kPAPActivityClassKey];
                    [isFollowingQuery whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
                    [isFollowingQuery whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
                    [isFollowingQuery whereKey:kPAPActivityToUserKey equalTo:object];
                    [isFollowingQuery setCachePolicy:kPFCachePolicyCacheThenNetwork];
                    
                    [isFollowingQuery countObjectsInBackgroundWithBlock:^(int number, NSError *error) {
                        @synchronized(self) {
                            [self.outstandingFollowQueries removeObjectForKey:indexPath];
                            [[Cache sharedCache] setFollowStatus:(!error && number > 0) user:(PFUser *)object];
                        }
                        if (cell.tag == indexPath.row) {
                            [cell.followButton setSelected:(!error && number > 0)];
                        }
                    }];
                }
            }
        }
    } else {
        [cell.followButton setSelected:(self.followStatus == PAPFindFriendsFollowingAll)];
    }
    
    return cell;
}

#pragma mark - PAPFindFriendsCellDelegate

- (void)cell:(FindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser {
    // Push account view controller
//    PAPAccountViewController *accountViewController = [[PAPAccountViewController alloc] initWithStyle:UITableViewStylePlain];
//    [accountViewController setUser:aUser];
//    [self.navigationController pushViewController:accountViewController animated:YES];
}

- (void)cell:(FindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser {
    [self shouldToggleFollowFriendForCell:cellView];
}


#pragma mark - ()

- (void)refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
}

- (void)shouldToggleFollowFriendForCell:(FindFriendsCell *)cell {
    PFUser *cellUser = cell.user;
    
    if ([cell.followButton isSelected]) {
        
        // Unfollow
        cell.followButton.selected = NO;
        
        [Utility unfollowUserEventually:cellUser];
//        [[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserFollowingChangedNotification object:nil];
    } else {
        
        // Follow
        cell.followButton.selected = YES;
        
        [Utility followUserEventually:cellUser block:^(BOOL succeeded, NSError *error) {
            if (!error) {
//                [[NSNotificationCenter defaultCenter] postNotificationName:PAPUtilityUserFollowingChangedNotification object:nil];
            } else {
                cell.followButton.selected = NO;
            }
        }];
    }
}

@end