//
//  RouteViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 05/12/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Via.h"
#import "AddRouteRepetitionViewController.h"
#import "RepetitionTableViewController.h"
#import "MarqueeLabel.h"

@interface RouteViewController : UIViewController <AddRouteRepetitionViewControllerDelegate>

@property (nonatomic, weak) Via *via;
@property (nonatomic, weak) NSString *falesiaName;
@property (nonatomic, weak) NSString *sectorName;

@property (weak, nonatomic) IBOutlet UILabel *routeGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeProposedGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeRepetitionNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *routeBeautyImageView;

@property (strong, nonatomic) RepetitionTableViewController  *repetitionTableViewController;

- (IBAction)addRepetitionButtonClicked:(id)sender;

@end
