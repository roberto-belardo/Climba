//
//  AddRouteRepetitionViewController.h
//  iClimb
//
//  Created by Roberto Belardo on 05/12/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Repetition.h"
#import "Via.h"
#import "Utility.h"
#import "TSMessage.h"
#import <FacebookSDK/FacebookSDK.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Climba-Swift.h"
#import "MBProgressHUD.h"
#import "MarqueeLabel.h"

@protocol AddRouteRepetitionViewControllerDelegate <NSObject>

- (void) didDismissAddRouteRepetitionVC;
- (void) didDismissAddRouteRepetitionVCAfterAdd;

@end

@interface AddRouteRepetitionViewController : UIViewController <UITextViewDelegate, UIScrollViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, MBProgressHUDDelegate>{
    
    MBProgressHUD *HUD;
    
}

@property (weak, nonatomic) id<AddRouteRepetitionViewControllerDelegate> delegate;
@property (nonatomic, weak) Via *via;
@property (nonatomic, weak) NSString *falesiaName;
@property (nonatomic, weak) NSString *sectorName;

@property (strong, nonatomic) NSArray *repetitionModes;

@property (weak, nonatomic) IBOutlet UITextView *commentTextView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *gradoVia;
@property (weak, nonatomic) IBOutlet UILabel *nomeFalesia;
@property (weak, nonatomic) IBOutlet UILabel *nomeSettore;

@property (weak, nonatomic) IBOutlet UILabel *frazioneGrado;
@property (weak, nonatomic) IBOutlet UIStepper *stepperBeauty;
@property (weak, nonatomic) IBOutlet UITextField *repetitionMode;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIStepper *stepperGrado;

@property (weak, nonatomic) IBOutlet UILabel *routeGradeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *routeBackground;
@property (weak, nonatomic) IBOutlet UILabel *routeProposedGradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *routeRepetitionNumberLabel;
@property (strong, nonatomic) IBOutlet UIImageView *routeBeautyImageView;

@property (strong, nonatomic) IBOutlet UIImageView *modeLabelImageView;
@property (strong, nonatomic) IBOutlet UIImageView *beautyLabelImageView;
@property (strong, nonatomic) IBOutlet UIImageView *gradeLabelImageView;
@property (strong, nonatomic) IBOutlet UIImageView *commentLabelImageView;
@property (strong, nonatomic) IBOutlet UIImageView *shareLabelImageView;

@property (strong, nonatomic) IBOutlet UIImageView *routeProposedBeautyImageView;
@property (strong, nonatomic) IBOutlet UIImageView *navBackground;
@property (strong, nonatomic) SevenSwitch *facebookShareSwitch;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)stepperBeautyValueChanged:(id)sender;
- (IBAction)dismissViewClicked:(id)sender;
- (IBAction)saveRouteRepetitionClicked:(id)sender;
- (IBAction)stepperGradoValueChanged:(id)sender;
@end
