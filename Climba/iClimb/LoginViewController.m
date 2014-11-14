//
//  LoginViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 15/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "TSMessage.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>

@interface LoginViewController ()

//- (void) presentTestLoggedInViewController;
- (BOOL) validateEmail:(NSString *)emailStr;

@end

@implementation LoginViewController

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
    
    if ([PFUser currentUser] /*&& // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]*/) // Check if user is linked to Facebook
    {
        [self.delegate didLoggedinSuccessfullyWith:[PFUser currentUser]];
    }else{
        
        self.background.image = [UIImage imageNamed:@"signInBackground.png"];
        self.appLogoImageView.image = [UIImage imageNamed:@"signInLogo.png"];
        self.loginFieldSeparator.image = [UIImage imageNamed:@"loginFormSeparator.png"];
        self.loginButtonsBackground.image = [UIImage imageNamed:@"loginButtonsBackground.png"];
        self.facebookLoginBackground.image = [UIImage imageNamed:@"facebookLoginBackground.png"];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginClicked:(id)sender {
    
    [self blockUIElements];
    
    if([ReachabilityManager isReachable]) {
        
        // Check if both fields are completed
        if (self.usernameTextField.text &&
            self.passwordTextField.text &&
            self.usernameTextField.text.length != 0 &&
            self.passwordTextField.text.length != 0) {
            
            [self loginWithUsername:self.usernameTextField.text andPassword:self.passwordTextField.text];
        }else{
            [self unblockUIElements];
            [TSMessage showNotificationInViewController:self
                                                  title:@"Missing Information"
                                               subtitle:@"Make sure you fill out all of the information!"
                                                   type:TSMessageNotificationTypeWarning];
        }
        
    }else{
        [self unblockUIElements];
        [Utility networkUnreachableTSMessage:self];
    }

}

- (void)loginWithUsername:(NSString *)username andPassword:(NSString *)password{
    
    [PFUser logInWithUsernameInBackground:username
                                 password:password
                                   target:self
                                 selector:@selector(handleUserLogin:error:)];

}

- (void)handleUserLogin:(PFUser *)user error:(NSError *)error {
    if (user) {
        // Do stuff after successful login.
        [self unblockUIElements];
        
        [self.delegate didLoggedinSuccessfullyWith:user];
        
    } else {
        // The login failed. Check error to see why.
        [self unblockUIElements];
        NSLog(@"There was an error during the login process. Try again");
        
        //Invalid Login Credentials
        [TSMessage showNotificationInViewController:self
                                              title:@"Login Error"
                                           subtitle:@"Invalid Username or Password. Please try again."
                                               type:TSMessageNotificationTypeError];
    }
}

- (IBAction)facebookLoginClicked:(id)sender {

    [self blockUIElements];
    
    if([ReachabilityManager isReachable]) {
    
    NSArray *permissionsArray = @[ @"public_profile", @"user_friends", @"email", @"publish_actions"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                [self unblockUIElements];
                
                [TSMessage showNotificationInViewController:self
                                                      title:@"Login Error"
                                                   subtitle:@"There was an error logging in. Try again in a while or report a bug if it persists."
                                                       type:TSMessageNotificationTypeError];
                
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                [self unblockUIElements];
                
                [TSMessage showNotificationInViewController:self
                                                      title:@"Login Error"
                                                   subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                       type:TSMessageNotificationTypeError];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            [self unblockUIElements];
            
            [self.delegate didLoggedinSuccessfullyWith:user];
        } else {
            NSLog(@"User with facebook logged in!");
            [self unblockUIElements];
            
            [self.delegate didLoggedinSuccessfullyWith:user];
        }
    }];
        
    }else{
        [self unblockUIElements];
        [Utility networkUnreachableTSMessage:self];
    }
    
}

- (IBAction)signupClicked:(id)sender {
    
    SignupViewController *signupVC = [[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil];
    signupVC.delegate = self;
    [self presentViewController:signupVC animated:YES completion:nil];
    
}

- (IBAction)backgroundClicked:(id)sender {
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

- (IBAction)resetPasswordClicked:(id)sender {
    //Dsiplay alert view with email form

    if([ReachabilityManager isReachable]) {
        
        UIAlertView *passwordResetAlertView = [[UIAlertView alloc] initWithTitle:@"Password Reset"
                                                                       message:@"Provide a valid email address to reset you iClimb password."
                                                                      delegate:self
                                                             cancelButtonTitle:@"Cancel"
                                                             otherButtonTitles:@"Reset", nil];
        passwordResetAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        [[passwordResetAlertView textFieldAtIndex:0] setKeyboardType:UIKeyboardTypeEmailAddress];
        [[passwordResetAlertView textFieldAtIndex:0] becomeFirstResponder];
        
        [passwordResetAlertView show];
        
    }else{
        [Utility networkUnreachableTSMessage:self];
    }
    
}

- (IBAction)resetLoginForm:(id)sender {
}

#pragma mark - Private Mehotds

- (BOOL) validateEmail:(NSString *)emailStr{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}

#pragma mark - SignUp View Controller Delegate Methods
- (void) didDismissPresentedViewController{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) didSignedUpSuccessfullyWith:(PFUser *)user{
    [self dismissViewControllerAnimated:YES completion:nil];
    [self loginWithUsername:user.username andPassword:user.password];
}

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)theAlert clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"The %@ button (%i) was tapped.", [theAlert buttonTitleAtIndex:buttonIndex], (int)buttonIndex);
    
    if (theAlert.alertViewStyle == UIAlertViewStylePlainTextInput && buttonIndex == 1) {
        NSLog(@"The email field says %@.",[theAlert textFieldAtIndex:0].text);
        
        self.emailForPasswordReset = [theAlert textFieldAtIndex:0].text;
        
        NSLog(@"Password reset requested for %@",self.emailForPasswordReset);
        
        if ([theAlert textFieldAtIndex:0].text.length != 0 && [self validateEmail:self.emailForPasswordReset]) {
            //Request Password Reset to Parse
            [PFUser requestPasswordResetForEmailInBackground:self.emailForPasswordReset target:self selector:@selector(handlePasswordReset:error:)];
        }else{
            
            NSLog(@"Cannot reset an empty password. Please provide a valid email address.");
            
            [TSMessage showNotificationInViewController:self
                                                  title:@"Empty email address"
                                               subtitle:@"Cannot reset an empty password. Please provide a valid email address."
                                                   type:TSMessageNotificationTypeError];
        }
        
    }
}

- (void)handlePasswordReset:(NSNumber *)result error:(NSError *)error {
    if (!error) {
        //Hooray! An email will be sent with a link to reset the password
        NSLog(@"Hooray! An email will be sent to %@ with a link to reset the password",
              self.emailForPasswordReset);
        NSMutableString *message = [NSMutableString stringWithFormat:@"An email has just been sent to %@. Check it out to reset your iClimb password.", self.emailForPasswordReset];
        [TSMessage showNotificationInViewController:self
                                              title:@"Password Reset"
                                           subtitle:message
                                               type:TSMessageNotificationTypeSuccess];
        
    } else {
        NSString *errorString = [error userInfo][@"error"];
        // Show the errorString somewhere and let the user try again.
        NSLog(@"ERROR in Password Reset for email %@: %@",self.emailForPasswordReset, errorString);
        NSString *errorMessage = [[[NSString stringWithFormat:@"ERROR in Password Reset for email %@: %@",self.emailForPasswordReset, errorString] substringToIndex:30] stringByAppendingString:@"..."];
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Password Reset"
                                           subtitle:errorMessage
                                               type:TSMessageNotificationTypeError];
    }
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - ()
- (void)blockUIElements {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    [HUD show:YES];
    
    self.usernameTextField.enabled = NO;
    self.passwordTextField.enabled = NO;
    self.cancelButton.enabled = NO;
    self.loginButton.enabled = NO;
    self.forgotPasswordButton.enabled = NO;
    self.signupButton.enabled = NO;
}

- (void)unblockUIElements {
    
    [HUD hide:YES];
    
    self.usernameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    self.cancelButton.enabled = YES;
    self.loginButton.enabled = YES;
    self.forgotPasswordButton.enabled = YES;
    self.signupButton.enabled = YES;
}

@end
