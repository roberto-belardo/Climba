//
//  SettingsTableTableViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "SettingsTableViewController.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

@synthesize settings;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setTitle:@"Settings"];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back"
                                                                   style:UIBarButtonItemStylePlain
                                                                  target:self
                                                                  action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    NSArray *content = [self buildContentArray];
    self.settings = [[NSMutableArray alloc] initWithCapacity: [content count]];
    [self.settings addObjectsFromArray: content];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ()
- (NSArray *)buildContentArray
{
    NSMutableArray *contentArray = [NSMutableArray new];
    
    NSMutableDictionary *socialRow = [[NSMutableDictionary alloc] init];
    [socialRow setValue:@"Social" forKey:@"headerTitle"];
    NSArray *socialSettings = [NSArray arrayWithObjects:
                               [[Setting alloc] initWithDisplayName:SETTING_LINK_TO_FACEBOOK_DISPLAY_NAME
                                                          settingId:[NSNumber numberWithInt:SETTING_LINK_TO_FACEBOOK]],
                               [[Setting alloc] initWithDisplayName:SETTING_UNLINK_FROM_FACEBOOK_DISPLAY_NAME
                                                          settingId:[NSNumber numberWithInt:SETTING_UNLINK_FROM_FACEBOOK]], nil];
    [socialRow setValue:socialSettings forKey:@"rowValues"];
    [contentArray addObject:socialRow];
    
    NSMutableDictionary *generalRow = [[NSMutableDictionary alloc] init];
    [generalRow setValue:@"General" forKey:@"headerTitle"];
    NSArray *generalSettings = [NSArray arrayWithObjects:
                                [[Setting alloc] initWithDisplayName:SETTING_WALKTHROUGH_DISPLAY_NAME
                                                           settingId:[NSNumber numberWithInt:SETTING_WALKTHROUGH]],
                                [[Setting alloc] initWithDisplayName:SETTING_CREDITS_DISPLAY_NAME
                                                           settingId:[NSNumber numberWithInt:SETTING_CREDITS]],
                                [[Setting alloc] initWithDisplayName:SETTING_LOG_OUT_DISPLAY_NAME
                                                           settingId:[NSNumber numberWithInt:SETTING_LOG_OUT]], nil];
    [generalRow setValue:generalSettings forKey:@"rowValues"];
    [contentArray addObject:generalRow];
    
    return contentArray;
}

#pragma mark - Navigation

- (void)backButtonPressed:(id)sender
{
    [self.delegate didDismissSettingsVC];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.settings count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [[[self.settings objectAtIndex:section] objectForKey:@"rowValues"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"settingsCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    //Configure the cell
    Setting *setting = [[[self.settings objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    cell.textLabel.text = setting.displayName;

    PFObject *userEmail = [PFUser currentUser][@"email"];
    
    switch ([setting.settingId intValue]) {
        case SETTING_LINK_TO_FACEBOOK:
            if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor = [UIColor grayColor];
                [setting setSettingUnselectable];
            }
            break;
            
        case SETTING_UNLINK_FROM_FACEBOOK:
            if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]] || userEmail == nil){
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.textLabel.textColor = [UIColor grayColor];
                [setting setSettingUnselectable];
            }
            break;
            
        case SETTING_WALKTHROUGH:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
            
        case SETTING_CREDITS:
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;

        default:
            break;
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Setting *setting = [[[self.settings objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];
    
    if ([setting.selectable intValue] == SETTING_SELECTABLE)
        return indexPath;
    else
        return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Setting *setting = [[[self.settings objectAtIndex:indexPath.section] objectForKey:@"rowValues"] objectAtIndex:indexPath.row];

    CreditsViewController *creditsVC = [[CreditsViewController alloc] initWithNibName:@"CreditsViewController" bundle:nil];
    AppWalkthroughContainerViewController *walkthroughVC = [[AppWalkthroughContainerViewController alloc] init];
    walkthroughVC.delegate = self;
    
    switch ([setting.settingId intValue]) {
        case SETTING_LINK_TO_FACEBOOK:
            [self linkAccountToFacebook];
            break;
        
        case SETTING_UNLINK_FROM_FACEBOOK:
            [self unlinkAccountFromFacebook];
            break;
            
        case SETTING_WALKTHROUGH:
            [self.navigationController pushViewController:walkthroughVC animated:YES];
            break;
            
        case SETTING_CREDITS:
            [self.navigationController pushViewController:creditsVC animated:YES];
            break;
            
        case SETTING_LOG_OUT:
            [self.delegate loggedOutSettingClicked];
            break;
            
        default:
            break;
    }
    
}

#pragma mark Sectioned Table View Methods

- (NSString *)tableView:(UITableView *)aTableView titleForHeaderInSection:(NSInteger)section {
    return [[self.settings objectAtIndex:section] objectForKey:@"headerTitle"];
    
}

#pragma mark - ()
- (void) linkAccountToFacebook {

    NSArray *permissionsArray = @[ @"public_profile", @"user_friends", @"email", @"publish_actions"];
    
    [PFFacebookUtils linkUser:[PFUser currentUser]
                  permissions:permissionsArray
                       target:self
                     selector:@selector(handleLinkUserToFacebook:error:)];
}

- (void)handleLinkUserToFacebook:(NSNumber *)result error:(NSError *)error {
    if (!error) {
        NSLog(@"Account succesfully linked to Facebook!");

        //Update profile with Facebook info
        [self.delegate updateProfileWithFacebookInfoAfterSuccesfullLinkToFacebook];
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Success"
                                           subtitle:@"Succesfully linked to your Facebook account!"
                                        	type:TSMessageNotificationTypeSuccess];
       
        [self backButtonPressed:self];

    } else {
        NSString *errorString = [error userInfo][@"error"];

        NSLog(@"ERROR while linking %@ to Facebook account: %@",[[PFUser currentUser] objectForKey:@"profile"][@"name"], errorString);

        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:@"There was an error linking your Facebook account. Please try again later."
                                               type:TSMessageNotificationTypeError];
    }
}

- (void) unlinkAccountFromFacebook {
    
    PFUser *user = [PFUser currentUser];
    
    // The user is an email user with a Facebook account linked
    if (user[@"email"]) {
        [PFFacebookUtils unlinkUserInBackground:user
                                         target:self
                                       selector:@selector(handleUnlinkUserFromFacebook:error:)];
    // The user is a Facebook user. It cannot be unlinked from Facebook otherwise it will remain as a Zombie in the system!
    } else {
        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:@"Cannot unlink from Facebook. You will not be able to log in again."
                                               type:TSMessageNotificationTypeError];
    }
}

- (void) handleUnlinkUserFromFacebook:(NSNumber *)result error:(NSError *)error {
    if (!error) {
        NSLog(@"The user is no longer associated with his Facebook account.");

        //Update user profile removing facebook informations and setting only the profile.name
        NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:1];
        userProfile[@"name"] = [PFUser currentUser].username;

        [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
        [[PFUser currentUser] saveInBackground];

        [self.delegate updateProfileAfterSuccesfullUnlinkFromFacebook];
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Success"
                                           subtitle:@"Succesfully unlinked from your Facebook account :("
                                               type:TSMessageNotificationTypeSuccess];
        
        [self backButtonPressed:self];
        

    } else {
        NSString *errorString = [error userInfo][@"error"];
        NSLog(@"ERROR while unlinking %@ to Facebook account: %@",[[PFUser currentUser] objectForKey:@"profile"][@"name"], errorString);

        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:@"There was an error unlinking your Facebook account. Please try again later."
                                               type:TSMessageNotificationTypeError];

    }
}

#pragma mark - AppWalkthrough Delegate Methods
- (void)didDismissWalkthrough {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
