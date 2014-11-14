//
//  FriendsListTableViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 02/03/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cache.h"
#import "FindFriendsCell.h"
#import "FacebookFriendCell.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"

@interface FriendsListTableViewController : UITableViewController <PAPFindFriendsCellDelegate, FacebookFriendCellDelegate>

@property (nonatomic, retain) NSArray *parseFriends;
@property (nonatomic, retain) NSArray *parseFriendsFacebookIDs;
@property (nonatomic, retain) NSArray *facebookFriends;
@property (nonatomic, retain) NSMutableArray *sortedFacebookFriends;
@property (nonatomic, retain) NSArray *content;
@property (nonatomic, retain) NSMutableArray *searchResults;

- (void) addSearchFriendsResultToList:(NSArray *)objects;

@end
