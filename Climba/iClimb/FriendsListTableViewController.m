//
//  FriendsListTableViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 02/03/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "FriendsListTableViewController.h"

typedef enum {
    PAPFindFriendsFollowingNone = 0,    // User isn't following anybody in Friends list
    PAPFindFriendsFollowingAll,         // User is following all Friends
    PAPFindFriendsFollowingSome         // User is following some of their Friends
} PAPFindFriendsFollowStatus;

@interface FriendsListTableViewController ()

@property (nonatomic, assign) PAPFindFriendsFollowStatus followStatus;
@property (nonatomic, strong) NSMutableDictionary *outstandingFollowQueries;

@end

@implementation FriendsListTableViewController
@synthesize parseFriends, parseFriendsFacebookIDs, facebookFriends, sortedFacebookFriends, searchResults, content, followStatus, outstandingFollowQueries;

- (id)init {
    self = [super init];
    outstandingFollowQueries = [NSMutableDictionary dictionary];
    followStatus = PAPFindFriendsFollowingSome;
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [Utility getFollowingUsersForUser:[PFUser currentUser]];
    
    sortedFacebookFriends = [[NSMutableArray alloc] initWithCapacity: [facebookFriends count]];
    content = [self buildContentArray];
    
    searchResults = [[NSMutableArray alloc] initWithCapacity: [content count]];
    [searchResults addObjectsFromArray: content];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.searchResults count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self.searchResults objectAtIndex:section] objectForKey:@"rowValues"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        static NSString *FriendCellIdentifier = @"friendCustomCell";
        
        FindFriendsCell *cell = (FindFriendsCell *)[tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
        NSDictionary *facebookFriendData = [[[self.searchResults objectAtIndex:indexPath.section]objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        if (cell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"FindFriendsCell" bundle:nil] forCellReuseIdentifier:FriendCellIdentifier];
            cell = [tableView dequeueReusableCellWithIdentifier:FriendCellIdentifier];
            
        }
        [cell setDelegate:self];
        PFUser *user = [[[self.searchResults objectAtIndex:indexPath.section]objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
        [self configure:cell forAppUser:user atIndexPath:indexPath forFacebookFriend:facebookFriendData];
        
        return cell;
    
}

- (void)configure:(FindFriendsCell *)cell forAppUser:(PFUser *)user atIndexPath:(NSIndexPath *)indexPath forFacebookFriend:(NSDictionary *)facebookFriendData {
    [cell setUser:user];
    
    cell.friendProfilePicture.layer.cornerRadius = cell.friendProfilePicture.frame.size.width / 2;
    cell.friendProfilePicture.clipsToBounds = YES;
    cell.friendProfilePicture.contentMode = UIViewContentModeScaleAspectFit;
    
    [self setProfilePictureForCell:cell];
    
    cell.followButton.selected = NO;
    cell.tag = indexPath.row;
    
    NSDictionary *attributes = [[Cache sharedCache] attributesForUser:user];
    
    if (attributes) {
        [cell.followButton setSelected:[[Cache sharedCache] followStatusForUser:user]];
    } else {
        [Utility getFollowingUsersForUser:[PFUser currentUser] block:^(NSError *error) {
            if (!error) {
                [cell.followButton setSelected:[[Cache sharedCache] followStatusForUser:cell.user]];
            }else{
                [cell.followButton setSelected:NO];
            }
        }];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [FindFriendsCell heightForCell];
}

#pragma mark Sectioned Table View Methods

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [[self.searchResults objectAtIndex:section] objectForKey:@"headerTitle"];
    
}

#pragma mark - PAPFindFriendsCellDelegate

- (void)cell:(FindFriendsCell *)cellView didTapUserButton:(PFUser *)aUser {
    // Push account view controller
}

- (void)cell:(FindFriendsCell *)cellView didTapFollowButton:(PFUser *)aUser {
    [self shouldToggleFollowFriendForCell:cellView];
}


#pragma mark - ()
- (NSArray *)buildContentArray
{
    NSMutableArray *contentArray = [NSMutableArray new];
    
    //Parse friends sector ---------------
    if (parseFriends.count > 0) {
        NSMutableDictionary *climbaFriendsRow = [[NSMutableDictionary alloc] init];
        [climbaFriendsRow setValue:@"Facebook friends using Climba" forKey:@"headerTitle"];
        [climbaFriendsRow setValue:parseFriends forKey:@"rowValues"];
        [contentArray addObject:climbaFriendsRow];
    }
    
    return contentArray;
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
    
    [Utility getFollowingUsersForUser:[PFUser currentUser]];
}

- (void) addSearchFriendsResultToList:(NSArray *)objects {

    if (objects.count > 0) {
        
        NSMutableDictionary *searchFriendsRow = [[NSMutableDictionary alloc] init];
        [searchFriendsRow setValue:@"Search Results" forKey:@"headerTitle"];
        [searchFriendsRow setValue:objects forKey:@"rowValues"];
        
        if ([self.searchResults count] > 1 && [[self.searchResults[0] objectForKey:@"headerTitle"] isEqualToString:@"Search Results"]) {
            [self.searchResults replaceObjectAtIndex:0 withObject:searchFriendsRow];
        }else{
            [self.searchResults addObject:searchFriendsRow];
        }
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"headerTitle" ascending:NO];
        [self.searchResults sortUsingDescriptors:[NSArray arrayWithObjects:sort, nil]];
        
        [self.tableView reloadData];
    }
}

- (void)setProfilePictureForCell:(FindFriendsCell *)cell {
    
    cell.friendProfilePicture.layer.cornerRadius = cell.friendProfilePicture.frame.size.width / 2;
    cell.friendProfilePicture.clipsToBounds = YES;
    cell.friendProfilePicture.contentMode = UIViewContentModeScaleAspectFill;
    
    if(cell.user[@"profile"][@"pictureURL"]) {
        
        NSURL *profilePictureURL = [NSURL URLWithString:cell.user[@"profile"][@"pictureURL"]];
        [cell.friendProfilePicture setImageWithURL:profilePictureURL];
        
    }else{
        [self setProfilePictureFromParseForCell:cell forUser:cell.user];
    }
}

- (void)setProfilePictureFromParseForCell:(FindFriendsCell *)cell forUser:(PFUser *)user {
    
    PFQuery *queryUserPhoto = [PFQuery queryWithClassName:@"UserPhoto"];
    [queryUserPhoto whereKey:@"user" equalTo:user];
    [queryUserPhoto setLimit:1];
    [queryUserPhoto orderByAscending:@"createdAt"];
    
    [queryUserPhoto findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error && objects.count > 0) {
            
            PFObject *userPhoto = objects[0];
            
            PFFile *userImageFile = userPhoto[@"imageFile"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error && imageData) {
                    
                    UIGraphicsBeginImageContext(cell.friendProfilePicture.frame.size);
                    UIImage *image = [UIImage imageWithData:imageData];
                    [image drawInRect:cell.friendProfilePicture.bounds];
                    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    cell.friendProfilePicture.image = avatar;
                }
            }];
        }else{
            cell.friendProfilePicture.image = [UIImage imageNamed:@"fbfriendDefaultAvatar.png"];
        }
    }];
}

@end
