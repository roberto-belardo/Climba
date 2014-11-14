//
//  RouteViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 05/12/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "RouteViewController.h"

@interface RouteViewController ()

@end

@implementation RouteViewController
@synthesize via, falesiaName, sectorName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self setTitle:@"Route"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshRouteStats];
    
    //ROUTE NAME LABEL
//    UILabel *routeName = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, 320, 36)];
    MarqueeLabel *routeName = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 70, 320, 36) rate:50.0 andFadeLength:10.0f];
    routeName.textAlignment = NSTextAlignmentCenter;
    routeName.textColor = [UIColor colorWithRed:33.0f/255.0f green:163.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    routeName.font = [UIFont fontWithName:@"CODE Light" size:33];
    routeName.text = self.via.nome;
    [self.view addSubview:routeName];
    
    //ROUTE BACKGROUND IMAGE
//    self.routeBackground.image = [UIImage imageNamed:@"routebackground.png"];
    
    [self.routeGradeLabel setText:self.via.grado];
    
    [self setRouteStatsWithVia:self.via];
    
    //ROUTE REPETITIONS
    //Adding the RepetitionTableViewController to the parent RouteViewController.
    self.repetitionTableViewController = [RepetitionTableViewController new];
    
    PFQuery *query = [Repetition query];
    [query whereKey:@"via" equalTo:self.via];
    [query includeKey:@"user"];
    query.cachePolicy = kPFCachePolicyNetworkOnly;
    [query orderByDescending:@"createdAt"];
    self.repetitionTableViewController.query = query;
    
    self.repetitionTableViewController.view.frame = CGRectMake(0, 292, 320, self.view.bounds.origin.y+280);
    [self addChildViewController:self.repetitionTableViewController];
    [self.view addSubview:self.repetitionTableViewController.view];
    [self.repetitionTableViewController didMoveToParentViewController:self];
    
}

- (void)setRouteStatsWithVia:(Via *)v {
    NSString *proposedGrade = @"";
    if (v.frazioneGrado && ![v.frazioneGrado isEqualToString:@""]) {

        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        [f setMaximumFractionDigits:2];
        [f setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"]];
        NSNumber *frazioneGradoNumber = [f numberFromString:v.frazioneGrado];
        NSString *propGradeString = [Utility getGradeStringFromValue:frazioneGradoNumber];
        proposedGrade = propGradeString;
    }else {
        proposedGrade = v.grado;
    }
    
    [self.routeProposedGradeLabel setText:proposedGrade];
    if (v.numeroValutazioni != 0) {
        [self.routeRepetitionNumberLabel setText:[v.numeroValutazioni stringValue]];
    } else {
        [self.routeRepetitionNumberLabel setText:@"0"];
    }
//    [self.falesiaNameLabel setText:self.falesiaName];
//    [self.sectorNameLabel setText:self.sectorName];
    
    //ROUTE BEAUTY STARS
    switch ([v.bellezza intValue]) {
        case 1:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty1BLUE.png"];
            break;
        case 2:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty2BLUE.png"];
            break;
        case 3:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
            break;
        case 4:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty4BLUE.png"];
            break;
        case 5:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty5BLUE.png"];
            break;
        default:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
            break;
    }
    
    //ROUTE REPETITION IMAGE
    UIImageView *routeRepetitionsLabelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 264, 320, 16)];
    UIImage *routeRepetitionsLabelImage = [UIImage imageNamed:@"routeRepetitionLabel.png"];
    routeRepetitionsLabelImageView.image = routeRepetitionsLabelImage;
    routeRepetitionsLabelImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:routeRepetitionsLabelImageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)addRepetitionButtonClicked:(id)sender {
    
    if ([ReachabilityManager isReachable]) {
        AddRouteRepetitionViewController *addRouteRepetitionVC = [AddRouteRepetitionViewController new];
        addRouteRepetitionVC.delegate = self;
        addRouteRepetitionVC.via = self.via;
        addRouteRepetitionVC.falesiaName = self.falesiaName;
        addRouteRepetitionVC.sectorName = self.sectorName;
        [self presentViewController:addRouteRepetitionVC animated:YES completion:nil];
    } else {
        [Utility networkUnreachableTSMessage:self];
    }
    
}

#pragma mark - AddRouteRepetitionViewControllerDelegate
- (void) didDismissAddRouteRepetitionVC{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) didDismissAddRouteRepetitionVCAfterAdd {
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadTableData" object:nil];
    
    //Refresh info route
    [self refreshRouteStats];
}

#pragma mark - ()
- (void)refreshRouteStats {
    
    [self.via refreshInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if(!error){
            Via *retrievedVia = (Via *)object;
            [self setRouteStatsWithVia:retrievedVia];
        }
    }];
}

@end
