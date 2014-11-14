//
//  UserProfileViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 23/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "UserProfileViewController.h"
#import "TSMessage.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface UserProfileViewController ()

- (void)updateProfileFromFacebook;

@end

@implementation UserProfileViewController

@synthesize user;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

        UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Me"
                                                                 image:[[UIImage imageNamed:@"tabBarIcon2_notactive.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                   tag:1];
        [tabBarItem setSelectedImage:[[UIImage imageNamed:@"tabBarIcon2_active.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        self.tabBarItem = tabBarItem;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.followButton.hidden = YES;
    self.followButton.enabled = NO;
    if (self.user != [PFUser currentUser]) {
        self.followButton.hidden = NO;
        self.followButton.enabled = YES;
        
        NSDictionary *attributes = [[Cache sharedCache] attributesForUser:self.user];
        
        if (attributes) {
            [self.followButton setSelected:[[Cache sharedCache] followStatusForUser:self.user]];
        } else {
            [Utility getFollowingUsersForUser:[PFUser currentUser] block:^(NSError *error) {
                if (!error) {
                    [self.followButton setSelected:[[Cache sharedCache] followStatusForUser:self.user]];
                }else{
                    [self.followButton setSelected:NO];
                }
            }];
            
        }
        
        self.settingsButton.hidden = YES;
        self.userProfilePictureButton.hidden = YES;
        self.userProfilePictureButton.enabled = NO;
    }else if (self.user[@"facebookId"]) {
        self.userProfilePictureButton.hidden = YES;
        self.userProfilePictureButton.enabled = NO;
    }else {
        self.userProfilePictureButton.hidden = NO;
        self.userProfilePictureButton.enabled = YES;
    }
    
    if (self.user == [PFUser currentUser]) {
        [Utility getFollowingUsersForUser:[PFUser currentUser]];
    }
    
    self.navBarBackground.image = [UIImage imageNamed:@"navBarBackground.png"];
    self.lastRepetitionsHeaderImageView.image = [UIImage imageNamed:@"routeRepetitionLabel.png"];
    self.profileHeaderDividerImageView.image = [UIImage imageNamed:@"profileHeaderDivider.png"];

    //Adding the RepetitionTableViewController to the parent RouteViewController.
    self.repetitionTableViewController = [UserProfileRepetitionTableViewController new];
    
    PFQuery *query = [Repetition query];
    [query whereKey:@"user" equalTo:self.user];
    [query includeKey:@"via.settore"];
    [query includeKey:@"via.settore.falesia"];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    [query orderByDescending:@"createdAt"];
    
    self.repetitionTableViewController.query = query;
    
    self.repetitionTableViewController.view.frame = CGRectMake(0, 220, 320, 348);
    [self addChildViewController:self.repetitionTableViewController];
    [self.view addSubview:self.repetitionTableViewController.view];
    [self.repetitionTableViewController didMoveToParentViewController:self];
    
    [self updateProfile];
    
    if ([PFFacebookUtils isLinkedWithUser:self.user]) {
        if ([ReachabilityManager isReachable]) {
            [self updateProfileFromFacebook];
        } else {
            [Utility networkUnreachableTSMessage:self];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateUserStats];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)settingsClicked:(id)sender {
    
    SettingsTableViewController *settingsTVC = [SettingsTableViewController new];
    settingsTVC.delegate = self;
    self.settingsNavController = [[UINavigationController alloc] initWithRootViewController:settingsTVC];
    self.settingsNavController.navigationBar.barTintColor = [UIColor colorWithRed:33.0f/255.0f green:164.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.settingsNavController.navigationBar.tintColor = [UIColor whiteColor];
    [self presentViewController:self.settingsNavController animated:YES completion:nil];
}

- (IBAction)userProfilePictureButtonClicked:(id)sender {
    
    if (self.user != [PFUser currentUser]) {
        return;
    }else{
    
        NSString *actionSheetTitle = @"Change profile picture";
//        NSString *destructiveTitle = @"Remove profile picture";
        NSString *takePhoto = @"Take Photo";
        NSString *chooseFromLibrary = @"Choose from Library";
        NSString *cancelTitle = @"Cancel";
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:actionSheetTitle
                                      delegate:self
                                      cancelButtonTitle:cancelTitle
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:takePhoto, chooseFromLibrary, nil];
        
        [actionSheet showInView:self.view];
    }
}

- (IBAction)followUnfollowButtonClicked:(id)sender {
    [self shouldToggleFollowUser];
}

- (void)updateUserStats {
    if ([ReachabilityManager isReachable]) {
        [PFCloud callFunctionInBackground:@"userStats"
                           withParameters:@{@"userId": self.user.objectId}
                                    block:^(NSDictionary *stats, NSError *error) {
                                        if (!error) {
                                            
                                            NSNumber *monthlyReps = [NSNumber numberWithInt:[stats[@"monthlyReps"] intValue]];
                                            NSString *lastRep = (NSString *)stats[@"lastRep"];
                                            self.monthlyRoutes.text = [monthlyReps stringValue];
                                            if (![lastRep isEqualToString:@""]) {
                                                self.lastRepetitionLabel.text = lastRep;
                                            }
                                            
                                        }
                                    }];
        
        [self.user fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            if (!error && self.user[@"bestRouteGrade"]) {
                self.bestRepetitionLabel.text = self.user[@"bestRouteGrade"];
            }
        }];
    }

}

- (void)updateProfile {
    // TODO: Non funziona al signup ma solo al riavvio della App... (Logout e Login), poi funziona sempre.
    //ERRATACORRIGE: Forse dipende dal timing del salvataggio delle info nel backend... Delle volte funziona senza problemi.
    //WORKAROUND:
    
    self.userProfilePictureImageView.layer.cornerRadius = self.userProfilePictureImageView.frame.size.width / 2;
    self.userProfilePictureImageView.clipsToBounds = YES;
    self.userProfilePictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if ([self.user objectForKey:@"profile"][@"name"]) {
        if (self.user == [PFUser currentUser]) {
            self.usernameLabel.text = [self.user objectForKey:@"profile"][@"name"];
        }else{
            self.title = [self.user objectForKey:@"profile"][@"name"];
        }
        
    }else{
        //There should be a profile->name value so just make an explicit query to Parse
        PFQuery *query = [PFUser query];
        [query getObjectInBackgroundWithId:self.user.objectId block:^(PFObject *user, NSError *error) {
            // Do something with the returned PFObject in the user variable.
            self.usernameLabel.text = [self.user objectForKey:@"profile"][@"name"];
        }];
    }
    
    if(self.user[@"profile"][@"pictureURL"]) {
        
        NSURL *profilePictureURL = [NSURL URLWithString:self.user[@"profile"][@"pictureURL"]];
        [self.userProfilePictureImageView setImageWithURL:profilePictureURL];
        
    }else{
        [self setProfilePictureFromParse];
    }
}

- (void)updateProfileFromFacebook
{
    // Send request to Facebook
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // handle response
        if (!error) {
            // Parse the data received
            NSDictionary *userData = (NSDictionary *)result;
            
            NSString *facebookID = userData[@"id"];
            
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            
            NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
            
            if (userData[@"name"]) {
                userProfile[@"name"] = userData[@"name"];
            }
            
            if (userData[@"gender"]) {
                userProfile[@"gender"] = userData[@"gender"];
            }
            
            if (userData[@"birthday"]) {
                userProfile[@"birthday"] = userData[@"birthday"];
            }
            
            if ([pictureURL absoluteString]) {
                userProfile[@"pictureURL"] = [pictureURL absoluteString];
            }
            
            [self.user setObject:userProfile forKey:@"profile"];
            [self.user setObject:facebookID forKey:kPAPUserFacebookIDKey];
            [self.user saveInBackground];
            
            [self updateProfile];
            
            [self updateProfileWithFacebookFriends];
            
        } else if ([[[[error userInfo] objectForKey:@"error"] objectForKey:@"type"]
                    isEqualToString: @"OAuthException"]) { // Since the request failed, we can check if it was due to an invalid session
            NSLog(@"The facebook session was invalidated");
            
            [TSMessage showNotificationWithTitle:@"Error"
                                        subtitle:@"The Facebook token was invalidated. Logging out."
                                            type:TSMessageNotificationTypeError];

            [self loggedOutSettingClicked];
        } else {
            NSLog(@"Some other error: %@", error);
            //FIXIT: "An active access token must be used to query information about the current user." al tap sul profilo utente.
            [TSMessage showNotificationWithTitle:@"Error"
                                        subtitle:@"Something went wrooooong..."
                                            type:TSMessageNotificationTypeError];
        }
    }];
}

- (void) updateProfileWithFacebookFriends{
    
    // refresh Facebook friends on each launch
    [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            [self facebookRequestDidLoad:result];
//            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(facebookRequestDidLoad:)]) {
//                [[UIApplication sharedApplication].delegate performSelector:@selector(facebookRequestDidLoad:) withObject:result];
//            }
        } else {
//            if ([[UIApplication sharedApplication].delegate respondsToSelector:@selector(facebookRequestDidFailWithError:)]) {
//                [[UIApplication sharedApplication].delegate performSelector:@selector(facebookRequestDidFailWithError:) withObject:error];
//            }
            [self facebookRequestDidFailWithError:error];
        }
    }];
    
}

- (void)facebookRequestDidFailWithError:(NSError *)error {
    NSLog(@"Facebook error: %@", error);
    
    if (self.user) {
        if ([[error userInfo][@"error"][@"type"] isEqualToString:@"OAuthException"]) {
            NSLog(@"The Facebook token was invalidated. Logging out.");
            
            [TSMessage showNotificationWithTitle:@"Error"
                                        subtitle:@"The Facebook token was invalidated. Logging out."
                                            type:TSMessageNotificationTypeError];
            
            [self loggedOutSettingClicked];
        }
    }
}

- (void)facebookRequestDidLoad:(id)result {
    
    NSArray *data = [result objectForKey:@"data"];
    
    if (data) {
        // we have friends data
        
        NSMutableArray *facebookIds = [[NSMutableArray alloc] initWithCapacity:[data count]];
        for (NSDictionary *friendData in data) {
            if (friendData[@"id"]) {
                [facebookIds addObject:friendData[@"id"]];
            }
        }
        
        // cache friend data
        [[Cache sharedCache] setFacebookFriends:facebookIds];
        
    } else {

    }

    
}

#pragma mark - NSURLConnectionDataDelegate

/* Callback delegate methods used for downloading the user's profile picture */

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // As chuncks of the image are received, we build our data file
    //[self.imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // All data has been downloaded, now we can set the image in the header image view
    //self.headerImageView.image = [UIImage imageWithData:self.imageData];
    
    // Add a nice corner radius to the image
    //self.headerImageView.layer.cornerRadius = 8.0f;
    //self.headerImageView.layer.masksToBounds = YES;
}

#pragma mark - SettingsViewControllerDelegate

- (void) didDismissSettingsVC {
    [self dismissViewControllerAnimated:YES completion:nil];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableData" object:nil];
}

- (void) loggedOutSettingClicked {
    [PFUser logOut];
    NSLog(@"Logged out: ");
    
    [self.delegate didLoggedOutSuccessfully];
}

- (void) updateProfileWithFacebookInfoAfterSuccesfullLinkToFacebook {
    [self updateProfileFromFacebook];
}

- (void) updateProfileAfterSuccesfullUnlinkFromFacebook {
    [self updateProfile];
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //Get the name of the current pressed button
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if  ([buttonTitle isEqualToString:@"Remove profile picture"]) {
        [self actionSheetButtonRemoveProfilePicture];
    }
    if ([buttonTitle isEqualToString:@"Take Photo"]) {
        [self actionSheetButtonTakePhoto];
    }
    if ([buttonTitle isEqualToString:@"Choose from Library"]) {
        [self actionSheetButtonChooseFromLibrary];
    }
    if ([buttonTitle isEqualToString:@"Cancel"]) {
        [self actionSheetButtonCancel];
    }
}

- (void) actionSheetButtonRemoveProfilePicture {
    
}

- (void) actionSheetButtonTakePhoto {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera] == YES){
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        [TSMessage showNotificationInViewController:self
                                              title:@"No camera available"
                                           subtitle:@"Without a camera you can try to upload a profile picture from your Library."
                                               type:TSMessageNotificationTypeError];
    }
}

- (void) actionSheetButtonChooseFromLibrary {
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypePhotoLibrary] == YES){
        // Create image picker controller
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        // Set source to the camera
        imagePicker.sourceType =  UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        
        // Delegate is self
        imagePicker.delegate = self;
        
        // Show image picker
        [self presentViewController:imagePicker animated:YES completion:nil];
    }else{
        [TSMessage showNotificationInViewController:self
                                              title:@"Something wrong happened :("
                                           subtitle:@"It seems your photo library cannot be opened."
                                               type:TSMessageNotificationTypeError];
    }
}

- (void) actionSheetButtonCancel {
    
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // Dismiss controller
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    // Resize image
    UIImage *smallImage = [image resizedImage:CGSizeMake(640, 640) interpolationQuality:kCGInterpolationMedium];
    
    // Upload image
    NSData *imageData  = UIImagePNGRepresentation(smallImage);
//    NSData *imageData  = UIImageJPEGRepresentation(smallImage, 0.8);
    [self uploadImage:imageData];
}

#pragma mark - ()
- (void)uploadImage:(NSData *)imageData {
    PFFile *imageFile = [PFFile fileWithName:@"profilePicture.jpg" data:imageData];
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.delegate = self;
    HUD.labelText = @"Uploading";
    [HUD show:YES];
    
    // Save PFFile
    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (!error) {
            //Hide determinate HUD
            [HUD hide:YES];
            
            // Show checkmark
            HUD = [[MBProgressHUD alloc] initWithView:self.view];
            [self.view addSubview:HUD];
            
            HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
            
            // Set custom view mode
            HUD.mode = MBProgressHUDModeCustomView;
            
            HUD.delegate = self;
            
            // Query for an existing user photo
            PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
            PFUser *userCurrent = [PFUser currentUser];
            [query whereKey:@"user" equalTo:userCurrent];
            [query orderByAscending:@"createdAt"];
            
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if(!error) {
                    
                    if (objects.count > 0) {
                        //There is already a userPhoto. Remove it and add the new one.
                        PFObject *userPhoto = objects[0];
                        [userPhoto setObject:imageFile forKey:@"imageFile"];
                        
                        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                [self refreshUserProfilePicture];
                            }
                            else{
                                // Log details of the failure
                                NSLog(@"Error: %@ %@", error, [error userInfo]);
                                
                                [TSMessage showNotificationInViewController:self
                                                                      title:@"Error"
                                                                   subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                                       type:TSMessageNotificationTypeError];
                            }
                        }];
                    }else{
                        //There is no userPhoto.
                        // Create a PFObject around a PFFile and associate it with the current user
                        PFObject *userPhoto = [PFObject objectWithClassName:@"UserPhoto"];
                        [userPhoto setObject:imageFile forKey:@"imageFile"];
                        [userPhoto setObject:userCurrent forKey:@"user"];
                        
                        [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                            if (!error) {
                                [self refreshUserProfilePicture];
                            }
                            else{
                                // Log details of the failure
                                NSLog(@"Error: %@ %@", error, [error userInfo]);
                                
                                [TSMessage showNotificationInViewController:self
                                                                      title:@"Error"
                                                                   subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                                       type:TSMessageNotificationTypeError];
                            }
                        }];
                    }
                    
                }else{
                    //ERROR
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                           type:TSMessageNotificationTypeError];
                }
            }];
            
            
        }else{
            [HUD hide:YES];
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [TSMessage showNotificationInViewController:self
                                                  title:@"Error"
                                               subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                   type:TSMessageNotificationTypeError];
        }
        
    } progressBlock:^(int percentDone) {
        // Update your progress spinner here. percentDone will be between 0 and 100.
        HUD.progress = (float)percentDone/100;
    }];
    
}

- (void) refreshUserProfilePicture {
    
    NSLog(@"Showing Refresh HUD");
    refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:refreshHUD];
    
    // Register for HUD callbacks so we can remove it from the window at the right time
    refreshHUD.delegate = self;
    
    // Show the HUD while the provided method executes in a new thread
    [refreshHUD show:YES];
    
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *userCurrent = [PFUser currentUser];
    [query whereKey:@"user" equalTo:userCurrent];
    [query setLimit:1];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            // The find succeeded.
            if (refreshHUD) {
                [refreshHUD hide:YES];
                
                refreshHUD = [[MBProgressHUD alloc] initWithView:self.view];
                [self.view addSubview:refreshHUD];
                
                refreshHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
                
                // Set custom view mode
                refreshHUD.mode = MBProgressHUDModeCustomView;
                
                refreshHUD.delegate = self;
            }
            
            PFObject *userPhoto = objects[0];
            
            PFFile *userImageFile = userPhoto[@"imageFile"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error && imageData) {
                    
                    UIGraphicsBeginImageContext(self.userProfilePictureImageView.frame.size);
                    UIImage *image = [UIImage imageWithData:imageData];
                    [image drawInRect:self.userProfilePictureImageView.bounds];
                    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    self.userProfilePictureImageView.image = avatar;
                }else{
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:@"Something bad happened. :("
                                                           type:TSMessageNotificationTypeError];
                }
            }];
            
        }else{
            [refreshHUD hide:YES];
            
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            [TSMessage showNotificationInViewController:self
                                                  title:@"Error"
                                               subtitle:@"Something bad happened. :("
                                                   type:TSMessageNotificationTypeError];
        }
    }];
    
}

- (void)setProfilePictureFromParse {
    PFQuery *query = [PFQuery queryWithClassName:@"UserPhoto"];
    PFUser *userCurrent = [PFUser currentUser];
    [query whereKey:@"user" equalTo:userCurrent];
    [query setLimit:1];
    [query orderByAscending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if(!error) {
            
            PFObject *userPhoto = objects[0];
            
            PFFile *userImageFile = userPhoto[@"imageFile"];
            [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                if (!error && imageData) {
                    
                    UIGraphicsBeginImageContext(self.userProfilePictureImageView.frame.size);
                    UIImage *image = [UIImage imageWithData:imageData];
                    [image drawInRect:self.userProfilePictureImageView.bounds];
                    UIImage *avatar = UIGraphicsGetImageFromCurrentImageContext();
                    UIGraphicsEndImageContext();
                    
                    self.userProfilePictureImageView.image = avatar;
                }
            }];
        }
    }];
}

- (void)shouldToggleFollowUser {
    
    if ([self.followButton isSelected]) {
        
        // Unfollow
        self.followButton.selected = NO;
        
        [Utility unfollowUserEventually:self.user];
    } else {
        
        // Follow
        self.followButton.selected = YES;
        
        [Utility followUserEventually:self.user block:^(BOOL succeeded, NSError *error) {
            if (error) {
                self.followButton.selected = NO;
            }
        }];
    }
}

@end
