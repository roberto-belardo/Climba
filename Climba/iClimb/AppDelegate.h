//
//  AppDelegate.h
//  iClimb
//
//  Created by Roberto Belardo on 22/09/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
#import "LoginProtocol.h"
#import "LoggedInProtocol.h"
#import "MainViewController.h"
#import "Cache.h"
#import "AppWalkthroughContainerViewController.h"
#import "ReachabilityManager.h"
#import <Bolts/Bolts.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, LoginProtocol, LoggedInProtocol, AppWalkthroughContainerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *mainVC;

@end
