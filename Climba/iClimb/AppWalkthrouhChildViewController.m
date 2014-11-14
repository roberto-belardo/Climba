//
//  AppWalkthrouhChildViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 27/05/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "AppWalkthrouhChildViewController.h"

@interface AppWalkthrouhChildViewController ()

@end

@implementation AppWalkthrouhChildViewController

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
    self.startButton.hidden = true;
    
    switch (self.index) {
        case 0:
            self.imageView.image = [UIImage imageNamed:@"walk1.png"];
            break;
        case 1:
            self.imageView.image = [UIImage imageNamed:@"walk2.png"];
            break;
        case 2:
            self.imageView.image = [UIImage imageNamed:@"walk3.png"];
            break;
        case 3:
            self.imageView.image = [UIImage imageNamed:@"walk4.png"];
            break;
        case 4:
            self.imageView.image = [UIImage imageNamed:@"walk5.png"];
            
            //Add button to start
            self.startButton.hidden = false;
            
            break;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitFromWalkthrough:(id)sender {
    
    //Calling parent View Controller Delegate methods
    [self.delegate didDismissWalkthrough];
    
}

@end
