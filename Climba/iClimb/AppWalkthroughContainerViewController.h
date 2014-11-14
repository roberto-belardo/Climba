//
//  AppWalkthroughContainerViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 28/05/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppWalkthrouhChildViewController.h"

@protocol AppWalkthroughContainerDelegate <NSObject>

- (void) didDismissWalkthrough;

@end

@interface AppWalkthroughContainerViewController : UIViewController <UIPageViewControllerDataSource, AppWalkthroughContentDelegate>

@property (weak, nonatomic) id<AppWalkthroughContainerDelegate> delegate;

@property (strong, nonatomic) UIPageViewController *pageController;
@property (strong, nonatomic) IBOutlet UIImageView *background;

@end
