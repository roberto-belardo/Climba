//
//  AppWalkthrouhChildViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 27/05/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppWalkthroughContentDelegate <NSObject>

- (void) didDismissWalkthrough;

@end

@interface AppWalkthrouhChildViewController : UIViewController

@property (weak, nonatomic) id<AppWalkthroughContentDelegate> delegate;

@property (assign, nonatomic) NSInteger index;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@end
