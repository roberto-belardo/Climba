//
//  LoginViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 15/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SignupViewController.h"
#import "LoginProtocol.h"
#import "MBProgressHUD.h"
#import "ReachabilityManager.h"
#import "Utility.h"

@interface LoginViewController : UIViewController <SignupViewControllerDelegate, UIAlertViewDelegate, MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    
}

@property (weak, nonatomic) id<LoginProtocol> delegate;

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (strong, nonatomic) NSString *emailForPasswordReset;
@property (strong, nonatomic) IBOutlet UIImageView *background;
@property (strong, nonatomic) IBOutlet UIImageView *loginFieldSeparator;
@property (strong, nonatomic) IBOutlet UIImageView *loginButtonsBackground;
@property (strong, nonatomic) IBOutlet UIImageView *facebookLoginBackground;
@property (strong, nonatomic) IBOutlet UIImageView *appLogoImageView;

- (IBAction)loginClicked:(id)sender;
- (IBAction)facebookLoginClicked:(id)sender;
- (IBAction)signupClicked:(id)sender;
- (IBAction)backgroundClicked:(id)sender;
- (IBAction)resetPasswordClicked:(id)sender;
- (IBAction)resetLoginForm:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *loginWithFacebookButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;


@end
