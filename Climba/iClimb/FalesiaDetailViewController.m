//
//  FalesiaDetailViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 24/02/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "FalesiaDetailViewController.h"
#import "WeatherManager.h"

#define METERS_PER_MILE 1609.344

@interface FalesiaDetailViewController ()
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;

@property (nonatomic, assign) BOOL weatherInfoUpdated;

//- (void)configureWeatherSection:(NSArray *)weatherInfos;
//- (void)configureWeatherSection:(NSNotification*)notification;
- (void)configureWeatherSection:(NSArray *)weatherInfos;
@end

@implementation FalesiaDetailViewController

@synthesize scrollView, map, falesia;//, numberOfRoutes, numberOfSettori;

- (id)init {
    if (self = [super init]) {
        _hourlyFormatter = [[NSDateFormatter alloc] init];
        _hourlyFormatter.dateFormat = @"h a";
        
        _dailyFormatter = [[NSDateFormatter alloc] init];
        _dailyFormatter.dateFormat = @"EEEE";
    }
    return self;
}

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
    
    // --------------- GRAPHICS
    self.headerBackgroundImageView.image = [UIImage imageNamed:@"falesiaDetailHeader.png"];
    self.weatherBackgroundImageView.image = [UIImage imageNamed:@"weatherBackground.png"];
    
    
    // --------------- NOME FALESIA LABEL
    self.nomeFalesiaLabel.text = falesia.nome;
    
    // --------------- MAP
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = [falesia[@"lat"] doubleValue];
    zoomLocation.longitude = [falesia[@"long"] doubleValue];
    
    FalesiaLocation *falesiaLocation = [[FalesiaLocation alloc] initWithName:falesia.nome coordinate:zoomLocation];
    [map addAnnotation:falesiaLocation];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    [map setRegion:viewRegion animated:YES];
    
    // --------------- WEATHER
    WeatherManager *weatherManager = [WeatherManager new];
    [[RACObserve(weatherManager, dailyForecast)
      deliverOn:RACScheduler.mainThreadScheduler] subscribeNext:^(NSArray *newDailyForecast) {

        if (newDailyForecast /*&& !self.weatherInfoUpdated*/) {
            [self configureWeatherSection:newDailyForecast];
            self.weatherInfoUpdated = YES;
            
        }
        
     }];
    
    [weatherManager findWeatherForecastsForLatitude:zoomLocation.latitude Longitude:zoomLocation.longitude];
    
    // --------------- LABELS
    CGFloat distanceFromTop = 300;
    CGFloat paddingBetweenLabels = 20;
    CGFloat paddingAfterHeader = 10;
    CGSize maximumLabelSize = CGSizeMake(300, 9999);
    
    // --- DESCRIPTION
    UIImageView *descriptionLabelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, distanceFromTop, 320, 16)];
    UIImage *descriptionLabelImageViewImage = [UIImage imageNamed:@"falesiaDescriptionLabelImage.png"];
    descriptionLabelImageView.image = descriptionLabelImageViewImage;
    descriptionLabelImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat descriptionLBLStartingY = distanceFromTop + descriptionLabelImageView.image.size.height + paddingAfterHeader;
    UILabel *descriptionLBL = [[UILabel alloc] init];  //initWithFrame:CGRectMake(10, descriptionLBLStartingY, 300, rectDescriptionLBL.size.height)];
    descriptionLBL.font = [UIFont systemFontOfSize:14];
    descriptionLBL.textColor = [UIColor blackColor];
    descriptionLBL.numberOfLines = 0;
    
    NSMutableParagraphStyle *descriptionParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    descriptionParagraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *descriptionAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSBaselineOffsetAttributeName: @0,
                                 NSParagraphStyleAttributeName: descriptionParagraphStyle};
    
    NSAttributedString *attributedDescription = [[NSAttributedString alloc] initWithString:falesia.descrizione attributes:descriptionAttributes];
    descriptionLBL.attributedText = attributedDescription;
    CGSize expectSizeDescriptionLBL = [descriptionLBL sizeThatFits:maximumLabelSize];
    descriptionLBL.frame = CGRectMake(10, descriptionLBLStartingY, 300, expectSizeDescriptionLBL.height);
    
    if (falesia.descrizione) {
        [scrollView addSubview:descriptionLabelImageView];
        [scrollView addSubview:descriptionLBL];
    }
    
    // --- ACCESS
    CGFloat accessHeaderLBLStartingY = descriptionLBLStartingY+descriptionLBL.frame.size.height+paddingBetweenLabels;
    UIImageView *accessLabelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, accessHeaderLBLStartingY, 320, 16)];
    UIImage *accessLabelImageViewImage = [UIImage imageNamed:@"falesiaAccessLabelImage.png"];
    accessLabelImageView.image = accessLabelImageViewImage;
    accessLabelImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    NSMutableParagraphStyle *accessParagraphStyle = [[NSMutableParagraphStyle alloc] init];
    accessParagraphStyle.alignment = NSTextAlignmentJustified;
    NSDictionary *accessAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                            NSBaselineOffsetAttributeName: @0,
                                            NSParagraphStyleAttributeName: accessParagraphStyle};

    NSAttributedString *attributedAccess = [[NSAttributedString alloc] initWithString:falesia.accesso attributes:accessAttributes];
    
    CGFloat accessLBLStartingY = accessHeaderLBLStartingY + accessLabelImageView.image.size.height + paddingAfterHeader;
    UILabel *accessLBL = [[UILabel alloc] init];
    accessLBL.font = [UIFont systemFontOfSize:14];
    accessLBL.textColor = [UIColor blackColor];
    accessLBL.numberOfLines = 0;
    accessLBL.attributedText = attributedAccess;
    
    CGSize expectSizeAccessLBL = [accessLBL sizeThatFits:maximumLabelSize];
    accessLBL.frame = CGRectMake(10, accessLBLStartingY, 300, expectSizeAccessLBL.height);
    
    if (falesia.accesso) {
        [scrollView addSubview:accessLabelImageView];
        [scrollView addSubview:accessLBL];
    }
    
    double scrollViewLowerBound = accessLBLStartingY+accessLBL.frame.size.height;
    scrollView.contentSize = CGSizeMake(320, scrollViewLowerBound);
    scrollView.scrollEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)dismissViewClicked:(id)sender {
    [self.delegate didDismissFalesiaDetailVC];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"falesiaLocation";
    if ([annotation isKindOfClass:[FalesiaLocation class]]) {
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [map dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            annotationView.pinColor = MKPinAnnotationColorGreen;
//            annotationView.image = [UIImage imageNamed:@"arrest.png"];//here we use a nice image instead of the default pins
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    FalesiaLocation *location = (FalesiaLocation*)view.annotation;
    
    NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    [location.mapItem openInMapsWithLaunchOptions:launchOptions];
}

#pragma mark - ()

- (void)configureWeatherSection:(NSArray *)weatherInfos {
    // For each of the next seven days (Today, +1, +2, +3, +4, +5, +6)
    // Display UILabel with the name of the day
    // Display Weather icon
    
    int tagDayLBL = 300;
    int tagImageView = 400;
    int counter = 0;
//    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    
    CGFloat distanceFromTop = 230;
    CGFloat distanceFromBorder = 12;
    CGFloat distanceBetweenDayLBL = 12;
    
    CGFloat weatherImageViewWidth = 32;
    CGFloat weatherImageViewHeight = 32;
    CGFloat dayLBLWidth = 32;
    CGFloat dayLBLHeight = 20;
    
    for (WeatherCondition *w in weatherInfos) {
        
        // Weather Icon ---------------
        NSLog(@"%@: %@", [self.dailyFormatter stringFromDate:w.date], w.conditionDescription);
        CGFloat weatherImageView_X = distanceFromBorder + (distanceBetweenDayLBL*counter) + (weatherImageViewWidth*counter);
        CGFloat weatherImageView_Y = distanceFromTop;
        UIImageView *weatherImageView = [[UIImageView alloc] initWithFrame:CGRectMake(weatherImageView_X, weatherImageView_Y, weatherImageViewWidth, weatherImageViewHeight)];
        UIImage *image = [UIImage imageNamed:w.imageName];
        weatherImageView.image = image;
        [weatherImageView setTag:tagImageView];
        tagImageView++;
        weatherImageView.contentMode = UIViewContentModeScaleAspectFit;
        [scrollView addSubview:weatherImageView];
        
        //Day Label -------------------
        CGFloat dayLBL_X = distanceFromBorder + (distanceBetweenDayLBL*counter) + (dayLBLWidth*counter);
        CGFloat dayLBL_Y = distanceFromTop+weatherImageView.frame.size.height;
        UILabel *dayLBL = [[UILabel alloc] initWithFrame:CGRectMake(dayLBL_X, dayLBL_Y, dayLBLWidth, dayLBLHeight)];
        [dayLBL setTag:tagDayLBL];
        tagDayLBL++;
        dayLBL.font = [UIFont systemFontOfSize:8];
        dayLBL.textColor= [UIColor whiteColor];

        NSDateComponents* deltaComps = [NSDateComponents new];
        [deltaComps setDay:counter];
        NSDate* date = [[NSCalendar currentCalendar] dateByAddingComponents:deltaComps toDate:[NSDate date] options:0];
        
        NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
        int weekDay = (int)[comps day];
        NSString *weekDayString = [NSString stringWithFormat:@"%d ", weekDay];
        NSString *day = [weekDayString stringByAppendingString:[[self.dailyFormatter stringFromDate:w.date] substringToIndex:3]];
        dayLBL.text = day;
        dayLBL.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:dayLBL];
        
        counter++;
    }
}

@end
