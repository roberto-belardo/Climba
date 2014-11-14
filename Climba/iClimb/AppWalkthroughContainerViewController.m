//
//  AppWalkthroughContainerViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 28/05/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "AppWalkthroughContainerViewController.h"

@interface AppWalkthroughContainerViewController ()

@end

@implementation AppWalkthroughContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.background.image = [UIImage imageNamed:@"walkthroughbg.png"];
    
    //Paging
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    AppWalkthrouhChildViewController *initialViewController = [self viewControllerAtIndex:0];  
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (AppWalkthrouhChildViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    AppWalkthrouhChildViewController *childViewController = [[AppWalkthrouhChildViewController alloc] initWithNibName:@"AppWalkthrouhChildViewController" bundle:nil];
    childViewController.index = index;
    childViewController.delegate = self;
    
    return childViewController;
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(AppWalkthrouhChildViewController *)viewController index];
    
    if (index == 0) {
        return nil;
    }
    
    // Decrease the index by 1 to return
    index--;

    return [self viewControllerAtIndex:index];
    
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(AppWalkthrouhChildViewController *)viewController index];
    
    index++;
    
    if (index == 5) {
        return nil;
    }

    return [self viewControllerAtIndex:index];
    
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    // The number of items reflected in the page indicator.
    return 5;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    // The selected item reflected in the page indicator.
    return 0;
}

#pragma mark - AppWalkthroughContent Delegate Methods
- (void) didDismissWalkthrough {
    [self.delegate didDismissWalkthrough];
}

@end
