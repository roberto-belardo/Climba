//
//  AppDelegate.m
//  iClimb
//
//  Created by Roberto Belardo on 22/09/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Falesia.h"
#import "Settore.h"
#import "Via.h"
#import "Repetition.h"
#import "Activity.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "TSMessage.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //------------------------------------------------------------------------------------------------------------------------
    
    //Registering PFObject Subclasses
    [Falesia registerSubclass];
    [Settore registerSubclass];
    [Via registerSubclass];
    [Repetition registerSubclass];
    [Activity registerSubclass];
    
    //Setting up Parse backend link
    [Parse setApplicationId:@"YOUR_PARSE_APPLICATION_ID"
                  clientKey:@"YOUR_PARSE_CLIENT_KEY"];
    
    //Statistic track for Parse
    //[PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Setting up Facebook link
    [PFFacebookUtils initializeFacebook];
    
    //Setting up default view controller for TSMessage
    [TSMessage setDefaultViewController: self.window.rootViewController];
    
    // Instantiate Shared Manager
    [ReachabilityManager sharedManager];
    //------------------------------------------------------------------------------------------------------------------------
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasSeenTutorial"]) {
        AppWalkthroughContainerViewController *walkthroughVC = [[AppWalkthroughContainerViewController alloc] init];
        walkthroughVC.delegate = self;
        self.window.rootViewController = walkthroughVC;

    }else {
        
        LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
        loginVC.delegate = self;
        self.window.rootViewController = loginVC;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[PFFacebookUtils session] close];
}

#pragma mark - Application's Documents directory
// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Facebook default handlers

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {

    BOOL wasHandled = [FBAppCall handleOpenURL:url
                             sourceApplication:sourceApplication
                                   withSession:[PFFacebookUtils session]
                               fallbackHandler:^(FBAppCall *call) {
        if([[call appLinkData] targetURL] != nil) {
            NSArray *pathComponents = [[[call appLinkData] targetURL] pathComponents];
            NSString *viaObjectId = pathComponents[2];
            NSLog(@"VIA objectID: <%@>", viaObjectId);
//            if ([PFUser currentUser]) {
//                Via *via = [Via new];
//                via.objectId = viaObjectId;
//                [via fetchInBackgroundWithBlock:^(PFObject *object, NSError *error) {
//                    NSLog(@"Via: %@", via.nome);
//                    
//                }];
//            }
            
        } else {
            NSLog(@"%@", [NSString stringWithFormat:@"Unhandled deep link: %@", [[call appLinkData] targetURL]]);
        }
    }];
    
    return wasHandled;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

#pragma mark - Login Protocol Delegate Methods
- (void)didLoggedinSuccessfullyWith:(PFUser *)user{
    
    //Fetching config from Parse
    if ([ReachabilityManager isReachable]) {
        [PFConfig getConfigInBackgroundWithBlock:nil];
    }
    
    NSDictionary *falesie = [[Cache sharedCache] getFalesieNumberPerRegion];
    
    if (!falesie) {
        [PFCloud callFunctionInBackground:@"countFalesieForRegions"
                           withParameters:@{}
                                    block:^(NSDictionary *results, NSError *error) {
                                        if (!error) {
                                            //Cache the PFCLoud result:
                                            [[Cache sharedCache] setFalesieNumberPerRegion:results];
                                            
                                            self.mainVC = [[MainViewController alloc] initWithFalesie:results];
                                            self.mainVC.userProfileVC.delegate = self;
                                            self.window.rootViewController = self.mainVC;
                                        }else {
                                            self.mainVC = [[MainViewController alloc] initWithFalesie:falesie];
                                            self.mainVC.userProfileVC.delegate = self;
                                            self.window.rootViewController = self.mainVC;
                                        }
                                    }];
        
    }else{
        self.mainVC = [[MainViewController alloc] initWithFalesie:falesie];
        self.mainVC.userProfileVC.delegate = self;
        self.window.rootViewController = self.mainVC;
    }
    
    
    
}

#pragma mark - LoggedIn Protocol Delegate Methods
- (void)didLoggedOutSuccessfully{
    
    // clear cache
    [[Cache sharedCache] clear];
    
    // clear NSUserDefaults
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsCacheFacebookFriendsKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kPAPUserDefaultsActivityFeedViewControllerLastRefreshKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Clear all caches
    [PFQuery clearAllCachedResults];
    
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.delegate = self;
    self.window.rootViewController = loginVC;
}

#pragma mark - AppWalkthrough Delegate Methods
- (void)didDismissWalkthrough {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasSeenTutorial"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Presenting LoginViewController...
    LoginViewController *loginVC = [[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    loginVC.delegate = self;
    self.window.rootViewController = loginVC;
    
}

@end
