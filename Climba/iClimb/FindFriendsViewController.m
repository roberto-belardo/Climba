//
//  FindFriendsViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 25/11/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "FindFriendsViewController.h"
#import "TSMessage.h"

@interface FindFriendsViewController ()

@end

@implementation FindFriendsViewController
@synthesize friendsListTVC;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    PFQueryFriendsViewController *PAPFriendsViewController = [PFQueryFriendsViewController new];
//    PAPFriendsViewController.view.frame = CGRectMake(0, 61, 320, 500);
//    [self.view addSubview:PAPFriendsViewController.view];
    
    self.navBarBackground.image = [UIImage imageNamed:@"navBarBackground.png"];
    self.searchFriendTextField.delegate = self;
    
    if ([PFUser currentUser][@"facebookId"]) {
        //Find Parse Users among the cached friends of currentUser
        NSArray *facebookFriends = [[Cache sharedCache] facebookFriends];
        PFQuery *friendsQuery = [PFUser query];
        [friendsQuery whereKey:kPAPUserFacebookIDKey containedIn:facebookFriends];
        [friendsQuery orderByAscending:kPAPUserDisplayNameKey];
        [friendsQuery findObjectsInBackgroundWithTarget:self
                                               selector:@selector(foundParseFriends:error:)];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButtonClicked:(id)sender {
    
    [self.delegate didDismissFindFriendsVC];
    
}

- (IBAction)inviteFriendsButtonClicked:(id)sender {
    
    if ([PFUser currentUser][@"facebookId"]) {
    
        // Check if the Facebook app is installed and we can present
        // the message dialog
        FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
        PFConfig *config = [PFConfig currentConfig];
        params.link = [NSURL URLWithString:config[kpcInviteFBFriendLink]];
        params.name = config[kpcInviteFBFriendName];
        params.caption = config[kpcInviteFBFriendCaption];
        params.picture = [NSURL URLWithString:config[kpcInviteFBFriendPicture]];
        params.linkDescription = config[kpcInviteFBFriendLinkDescription];
        
        // If the Facebook app is installed and we can present the share dialog
        if ([FBDialogs canPresentMessageDialogWithParams:params]) {
            // Enable button or other UI to initiate launch of the Message Dialog
            // Present message dialog
            [FBDialogs presentMessageDialogWithLink:[NSURL URLWithString:config[kpcInviteFBFriendLink]]
                                            handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                if(error) {
                                                    // An error occurred, we need to handle the error
                                                    // See: https://developers.facebook.com/docs/ios/errors
                                                    [TSMessage showNotificationInViewController:self
                                                                                          title:@"Error"
                                                                                       subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                                                           type:TSMessageNotificationTypeError];
                                                } else {
                                                    // Success
                                                    NSLog(@"result %@", results);
                                                }
                                            }];
        }  else {
            // Disable button or other UI for Message Dialog
        }
        
    } else {

        [TSMessage showNotificationInViewController:self
                                              title:@"No Facebook account"
                                           subtitle:@"Make sure you link your Climba account to Facebook to find Climba friends among your Facebook friends!"
                                               type:TSMessageNotificationTypeWarning];
        
    }
    
}

- (void)foundParseFriends:(NSArray *)objects error:(NSError *)error {

    if (!error) {
        NSString *graphPath = @"/me/friends";
        [FBRequestConnection startWithGraphPath:graphPath
                                     parameters:[NSDictionary dictionaryWithObject:@"picture,id,name" forKey:@"fields"]
                                     HTTPMethod:@"GET"
                              completionHandler:^(
                                                  FBRequestConnection *connection,
                                                  NSDictionary *result,
                                                  NSError *error
                                                  ) {
                                  __block NSArray *friends;
                                  
                                  friends = [result objectForKey:@"data"];
                                  
                                  friendsListTVC = [FriendsListTableViewController new];
                                  friendsListTVC.parseFriends = objects;
                                  
                                  NSMutableArray *appUserFacebookIDs = [[NSMutableArray alloc] init];
                                  for (PFUser *pfUser in objects) {
                                      if(pfUser[@"facebookId"]) {
                                          [appUserFacebookIDs addObject:pfUser[@"facebookId"]];
                                      }
                                  }
                                  friendsListTVC.parseFriendsFacebookIDs = appUserFacebookIDs;
                                  
                                  friendsListTVC.facebookFriends = friends;
                                  friendsListTVC.view.frame = CGRectMake(0, 200, 320, self.view.bounds.size.height-200);
                                  [self addChildViewController:friendsListTVC];
                                  [self.view addSubview:friendsListTVC.view];
                                  [friendsListTVC didMoveToParentViewController:self];
                                  
                              }];
    } else {
        NSLog(@"Error: %@ %@", error, [error userInfo]);
    }
    
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    if (textField.text.length > 3) {
        
        if ([ReachabilityManager isReachable]) {
            [self findFriendsByUsername:textField.text];
        }else{
            [Utility networkUnreachableTSMessage:self];
        }
    } else {
        [TSMessage showNotificationInViewController:self
                                              title:@"Too many results"
                                           subtitle:@"Try with a different or more specific username to get fewer results.\n(Hint: Usernames must be longer than 3 characters)."
                                               type:TSMessageNotificationTypeWarning];
    }
    
    
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //hides keyboard when another part of layout was touched
    [self.view endEditing:YES];
    [super touchesBegan:touches withEvent:event];
}

#pragma mark - ()
- (void)findFriendsByUsername:(NSString *)username {
    
    NSMutableArray *usersToExcludeFromSearch = [NSMutableArray arrayWithObject:[PFUser currentUser].objectId];
    for (PFUser *user in friendsListTVC.parseFriends) {
        [usersToExcludeFromSearch addObject:user.objectId];
    }
    
    PFQuery *findFriendsByUsername = [PFUser query];
    [findFriendsByUsername whereKey:@"profile.name" containsString:username];
    [findFriendsByUsername whereKey:@"objectId" notContainedIn:usersToExcludeFromSearch];
    [findFriendsByUsername orderByAscending:kPAPUserDisplayNameKey];
    
    [findFriendsByUsername findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            if ([objects count] == 0) {
                [TSMessage showNotificationInViewController:self
                                                      title:@"No results"
                                                   subtitle:@"We didn't find any users matching your query."
                                                       type:TSMessageNotificationTypeWarning];
            }else if ([objects count] > 15) {
                [TSMessage showNotificationInViewController:self
                                                      title:@"Too many results"
                                                   subtitle:@"Try with a different or more specific username to get fewer results."
                                                       type:TSMessageNotificationTypeWarning];
            }else{
                [friendsListTVC addSearchFriendsResultToList:objects];
            }
        }else{
            [TSMessage showNotificationInViewController:self
                                                  title:@"Error"
                                               subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                   type:TSMessageNotificationTypeError];
        }
    }];
    
}

@end
