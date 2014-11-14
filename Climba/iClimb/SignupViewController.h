//
//  SignupViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 15/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"

@protocol SignupViewControllerDelegate <NSObject>

- (void) didDismissPresentedViewController;
- (void) didSignedUpSuccessfullyWith:(PFUser *)user;

@end

@interface SignupViewController : UIViewController <MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    
}

@property (weak, nonatomic) id<SignupViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIImageView *signupFormBackground;
@property (strong, nonatomic) IBOutlet UIImageView *signupFormSeparator;
@property (strong, nonatomic) IBOutlet UIImageView *signupFormSeparator_2;
@property (strong, nonatomic) IBOutlet UIImageView *appLogoImageView;

- (IBAction)signupClicked:(id)sender;
- (IBAction)backgroundClicked:(id)sender;
- (IBAction)resetSignupForm:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) PFUser *localUser;

@end
