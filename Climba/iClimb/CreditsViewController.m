//
//  CreditsViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "CreditsViewController.h"

@interface CreditsViewController ()

@end

@implementation CreditsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setTitle:@"Credits"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)goToAuthorWebSite:(id)sender {
    
    NSString *url = [PFConfig currentConfig][kpcAuthorWebPageURL];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}
@end
