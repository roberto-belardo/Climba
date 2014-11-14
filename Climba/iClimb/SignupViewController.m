//
//  SignupViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 15/10/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>
#import "TSMessage.h"
#import "ReachabilityManager.h"
#import "Utility.h"

@interface SignupViewController ()

- (BOOL) validateEmail:(NSString *)emailStr;

@end

@implementation SignupViewController

@synthesize localUser;

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
    self.background.image = [UIImage imageNamed:@"signInBackground.png"];
    self.appLogoImageView.image = [UIImage imageNamed:@"signInLogo.png"];
    self.signupFormBackground.image = [UIImage imageNamed:@"loginButtonsBackground.png"];
    self.signupFormSeparator.image = [UIImage imageNamed:@"loginFormSeparator.png"];
    self.signupFormSeparator_2.image = [UIImage imageNamed:@"loginFormSeparator.png"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupClicked:(id)sender {
    [self blockUIElements];
    
    if([ReachabilityManager isReachable]) {
        PFUser *user = [PFUser user];
        
        user.username = self.usernameTextField.text;
        user.password = self.passwordTextField.text;
        user.email = self.emailTextField.text;
        
        self.localUser = user;
        
        if (self.usernameTextField.text &&
            self.passwordTextField.text &&
            self.emailTextField.text &&
            self.usernameTextField.text.length != 0 &&
            self.emailTextField.text.length &&
            self.passwordTextField.text.length != 0 &&
            [self validateEmail:user.email]) {
            
            [user signUpInBackgroundWithTarget:self
                                      selector:@selector(handleSignUp:error:)];
            
        }else{
            [self unblockUIElements];
            [TSMessage showNotificationInViewController:self
                                                  title:@"Missing or wrong information"
                                               subtitle:@"Make sure you fill out all of the information correctly!"
                                                   type:TSMessageNotificationTypeWarning];
            
        }
    }else{
        [self unblockUIElements];
        [Utility networkUnreachableTSMessage:self];
    }
    
}

- (void)handleSignUp:(NSNumber *)result error:(NSError *)error {
    if (!error) {
        
        //Hooray! Let them use the app now.
        NSLog(@"Hooray! Let %@ use the app now.", localUser.username);
        
        //Login automatically into the app after succesfull login
        NSLog(@"User %@ signed up succesfully!", localUser.username);
        
        NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:1];
        userProfile[@"name"] = localUser.username;
        
        [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
        [[PFUser currentUser] saveInBackground];
        
        [self.delegate didSignedUpSuccessfullyWith:localUser];
        
        
    } else {
        [self unblockUIElements];
        NSString *errorString = [error userInfo][@"error"];
        // Show the errorString somewhere and let the user try again.
        NSLog(@"ERROR in SignUp: %@", errorString);
        
        [TSMessage showNotificationInViewController:self
                                              title:@"Error"
                                           subtitle:[[errorString substringToIndex:30] stringByAppendingString:@"..."]
                                               type:TSMessageNotificationTypeError];
    }
}

- (IBAction)backgroundClicked:(id)sender {
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.emailTextField resignFirstResponder];
    
    [self unblockUIElements];
    
}

- (IBAction)resetSignupForm:(id)sender {
    [self.delegate didDismissPresentedViewController];
}

#pragma mark - Private Mehotds
- (BOOL) validateEmail:(NSString *)emailStr{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
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
    self.emailTextField.enabled = NO;
    self.signupButton.enabled = NO;
    self.cancelButton.enabled = NO;
}

- (void)unblockUIElements {
    
    [HUD hide:YES];
    
    self.usernameTextField.enabled = YES;
    self.passwordTextField.enabled = YES;
    self.emailTextField.enabled = YES;
    self.signupButton.enabled = YES;
    self.cancelButton.enabled = YES;
}

@end
