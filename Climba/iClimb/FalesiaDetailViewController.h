//
//  FalesiaDetailViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 24/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Falesia.h"
#import <MapKit/MapKit.h>
#import "FalesiaLocation.h"
#import <Parse/Parse.h>
#import "Settore.h"
#import "Via.h"

@protocol FalesiaDetailViewControllerDelegate <NSObject>

- (void) didDismissFalesiaDetailVC;

@end

@interface FalesiaDetailViewController : UIViewController <UIScrollViewDelegate, MKMapViewDelegate>

//Delegates
@property (weak, nonatomic) id<FalesiaDetailViewControllerDelegate> delegate;

//Properties
@property (weak, nonatomic) Falesia *falesia;

//Outlets
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *nomeFalesiaLabel;
@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (strong, nonatomic) IBOutlet UIImageView *headerBackgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *weatherBackgroundImageView;

//Actions
- (IBAction)dismissViewClicked:(id)sender;

@end
