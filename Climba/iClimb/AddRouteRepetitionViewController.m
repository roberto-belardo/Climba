//
//  AddRouteRepetitionViewController.m
//  iClimb
//
//  Created by Roberto Belardo on 05/12/13.
//  Copyright (c) 2013 IngeniusApp. All rights reserved.
//

#import "AddRouteRepetitionViewController.h"

@interface AddRouteRepetitionViewController ()

@end

@implementation AddRouteRepetitionViewController{
@private
    BOOL shareToFacebookSwitchValue;
}
@synthesize via, repetitionModes, pickerView, stepperBeauty, stepperGrado, falesiaName, sectorName;

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
    // Do any additional setup after loading the view from its nib.
    
    self.facebookShareSwitch = [[SevenSwitch alloc] initWithFrame:CGRectMake(0, 0, 80, 40)];
    self.facebookShareSwitch.center = CGPointMake(272, 414);
    [self.facebookShareSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
    self.facebookShareSwitch.offImage = [UIImage imageNamed:@"facebookSwitchOff.png"];
    self.facebookShareSwitch.onImage = [UIImage imageNamed:@"facebookSwitchOn.png"];
    self.facebookShareSwitch.onTintColor = [UIColor colorWithRed:65.0f/255.0f green:86.0f/255.0f blue:151.0f/255.0f alpha:1.0];
    self.facebookShareSwitch.isRounded = NO;
    [self.view addSubview:self.facebookShareSwitch];
    
    [self.facebookShareSwitch setOn:YES animated:YES];
    shareToFacebookSwitchValue = YES;
    
    if (![PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
        self.facebookShareSwitch.enabled = NO;
        [self.facebookShareSwitch setOn:NO animated:YES];
        shareToFacebookSwitchValue = NO;
    }
    
    self.repetitionModes  = [[NSArray alloc] initWithObjects:   @"On Sight",
                                                                @"Flash",
                                                                @"1° giro",
                                                                @"2° giro",
                                                                @"3° giro",
                                                                @"4° giro",
                                                                @"5° giro",
                                                                @"6° giro",
                                                                @"7° giro",
                                                                @"8° giro",
                                                                @"9° giro",
                                                                @"10° giro",
                                                                @"11° giro",
                                                                @"12° giro",
                                                                @"13° giro",
                                                                @"14° giro",
                                                                @"15° giro",
                                                                @"16° giro",
                                                                @"17° giro",
                                                                @"18° giro",
                                                                @"19° giro",
                                                                @"20° giro",
                                                                nil];
    //[self registerForKeyboardNotifications];
    
    //ROUTE NAME LABEL
    MarqueeLabel *routeName = [[MarqueeLabel alloc] initWithFrame:CGRectMake(0, 70, 320, 36) rate:50.0 andFadeLength:10.0f];
//    UILabel *routeName = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, 320, 36)];
    routeName.textAlignment = NSTextAlignmentCenter;
    routeName.textColor = [UIColor colorWithRed:33.0f/255.0f green:163.0f/255.0f blue:240.0f/255.0f alpha:1.0];
    routeName.font = [UIFont fontWithName:@"CODE Light" size:33];
    routeName.text = self.via.nome;
    [self.scrollView addSubview:routeName];
    
    //ROUTE BACKGROUND IMAGE
    self.routeBackground.image = [UIImage imageNamed:@"routebackground.png"];
    
    self.navBackground.image = [UIImage imageNamed:@"navBarBackground.png"];
    
    [self.routeGradeLabel setText:self.via.grado];
    
    NSString *proposedGrade = @"";
    if (self.via.frazioneGrado) {
        proposedGrade = [NSString stringWithFormat:@"%@.%@", self.via.grado, self.via.frazioneGrado];
    }else {
        proposedGrade = self.via.grado;
    }
    
    [self.routeProposedGradeLabel setText:proposedGrade];
    if (self.via.numeroValutazioni != 0) {
        [self.routeRepetitionNumberLabel setText:[self.via.numeroValutazioni stringValue]];
    } else {
        [self.routeRepetitionNumberLabel setText:@"0"];
    }
    [self.nomeFalesia setText:self.falesiaName];
    [self.nomeSettore setText:self.sectorName];
    
    //ROUTE BEAUTY STARS
    switch ([self.via.bellezza intValue]) {
        case 1:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty1.png"];
            break;
        case 2:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty2.png"];
            break;
        case 3:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty3.png"];
            break;
        case 4:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty4.png"];
            break;
        case 5:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty5.png"];
            break;
        default:
            self.routeBeautyImageView.image = [UIImage imageNamed:@"routebeauty3.png"];
            break;
    }
    
    self.modeLabelImageView.image = [UIImage imageNamed:@"addRepetitionModeLabel.png"];
    self.beautyLabelImageView.image = [UIImage imageNamed:@"addRepetitionBeautyLabel.png"];
    self.gradeLabelImageView.image = [UIImage imageNamed:@"addRepetitionGradeLabel.png"];
    self.commentLabelImageView.image = [UIImage imageNamed:@"addRepetitionCommentLabel.png"];
    self.shareLabelImageView.image = [UIImage imageNamed:@"addRepetitionShareLabel.png"];
    
    self.routeProposedBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
    
    //---------------------
    
    // Init the picker view.
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    
    self.repetitionMode.inputView = self.pickerView;
    
    //Init the stepperBeauty
    self.stepperBeauty.minimumValue = 1;
    self.stepperBeauty.maximumValue = 5;
    self.stepperBeauty.stepValue = 1;
    self.stepperBeauty.autorepeat = YES;
    self.stepperBeauty.continuous = YES;
    self.stepperBeauty.value = 3;
    //self.bellezzaVia.text = [NSString stringWithFormat:@"%d/5", (int)stepperBeauty.value];
    
    //Init the stepperGrado
    self.stepperGrado.minimumValue = 1;
    self.stepperGrado.maximumValue = 42; //numero di gradi esistenti dal 3a al 9c+
    self.stepperGrado.stepValue = 1;
    self.stepperGrado.autorepeat = YES;
    self.stepperGrado.continuous = YES;
    int value = [[Utility getGradeValueFromString:self.via.grado] intValue];
    self.stepperGrado.value = value;
    self.frazioneGrado.text = [Utility getGradeStringFromValueWithoutFraction:[NSNumber numberWithDouble:self.stepperGrado.value]];
    
    //Comment Placeholder workaround
    self.commentTextView.text = @"Insert a comment";
    self.commentTextView.textColor = [UIColor grayColor];
    self.commentTextView.delegate = self;
}

- (BOOL) textViewShouldBeginEditing:(UITextView *)textView {
    self.commentTextView.text = @"";
    self.commentTextView.textColor = [UIColor colorWithRed:22.0f/255.0f green:44.0f/255.0f blue:84.0f/255.0f alpha:1.0];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.commentTextView.text.length == 0){
        self.commentTextView.textColor = [UIColor grayColor];
        self.commentTextView.text = @"";
        [self.commentTextView resignFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)stepperBeautyValueChanged:(id)sender {

    //self.bellezzaVia.text = [NSString stringWithFormat:@"%d/5", (int)self.stepperBeauty.value];
    switch ((int)self.stepperBeauty.value) {
        case 1:
            self.routeProposedBeautyImageView.image = [UIImage imageNamed:@"routebeauty1BLUE.png"];
            break;
        case 2:
            self.routeProposedBeautyImageView.image = [UIImage imageNamed:@"routebeauty2BLUE.png"];
            break;
        case 3:
            self.routeProposedBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
            break;
        case 4:
            self.routeProposedBeautyImageView.image = [UIImage imageNamed:@"routebeauty4BLUE.png"];
            break;
        case 5:
            self.routeProposedBeautyImageView.image = [UIImage imageNamed:@"routebeauty5BLUE.png"];
            break;
        default:
            self.routeProposedBeautyImageView.image = [UIImage imageNamed:@"routebeauty3BLUE.png"];
            break;
    }
}

- (IBAction)stepperGradoValueChanged:(id)sender {

    self.frazioneGrado.text = [Utility getGradeStringFromValueWithoutFraction:[NSNumber numberWithDouble:self.stepperGrado.value]];
    
}

- (IBAction)dismissViewClicked:(id)sender {
    
    [self.delegate didDismissAddRouteRepetitionVC];
}

- (IBAction)saveRouteRepetitionClicked:(id)sender {
    
    [self blockUIElements];
    
    //Save Repetition infos on Parse backend
    
    NSLog(@"Via in questione da salvare: %@ - (#val: %d)\n", self.via.nome, [self.via.numeroValutazioni intValue]);
    
    //--INSERT INTO "REPETITION" TABLE
    Repetition *repetition = [Repetition object];
    repetition[@"user"] = [PFUser currentUser];
    repetition.via = self.via;
    repetition.type = self.repetitionMode.text;
    repetition.stars = [NSNumber numberWithInt:(int)self.stepperBeauty.value];
    repetition.gradoProposto = self.frazioneGrado.text;
    if ([self.commentTextView.text isEqualToString:@"Insert a comment"]) {
        repetition.comment = @"";
    } else {
        repetition.comment = self.commentTextView.text;
    }
    repetition.settore = self.sectorName;
    repetition.falesia = self.falesiaName;
    
    [repetition saveEventually:^(BOOL succeeded, NSError *error) {
        [self saveActivityWithRepetition:repetition ifSucceeded:succeeded withoutError:error];
    }];
    
}

- (void)saveActivityWithRepetition:(Repetition *)rep ifSucceeded:(BOOL)succeeded withoutError:(NSError *)error{
    
    if(succeeded) {
        //--INSERT INTO "ACTIVITY" TABLE
        PFObject *activity = [PFObject objectWithClassName:@"Activity"];
        activity[@"fromUser"] = [PFUser currentUser];
        activity[@"type"] = @"repetition";
        activity[@"repetition"] = rep;
        
        //    [activity saveEventually];
        [activity  saveEventually:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                [self shareRepetitionOnFacebook];
                
                //--INSERT INTO "User" TABLE the best repetition
                [Utility saveBestRouteRepetition:via.grado];
                
                //--UPDATE "VIA" TABLE
                via.frazioneGrado = [via computeFrazioneGrado:[NSNumber numberWithDouble:self.stepperGrado.value]];
                [via incrementKey:@"numeroValutazioni"];
                via.bellezza = [via computeBellezza:(int)self.stepperBeauty.value];
                [via incrementKey:@"votiBellezza"];
                [via saveEventually];
                
            }else{
                [self unblockUIElements];
                [TSMessage showNotificationInViewController:self
                                                      title:@"Error"
                                                   subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                       type:TSMessageNotificationTypeError];
            }
        }];

    }else{
        NSLog(@"ERROR saving activity with repetition:\n%@", error.description);
    }
    
    //Dismiss the modal View
    [self unblockUIElements];
    [self.delegate didDismissAddRouteRepetitionVCAfterAdd];
}

- (void)shareRepetitionOnFacebook {
        
    if (shareToFacebookSwitchValue) {
        if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            // instantiate a Facebook Open Graph object
            NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
            
            // specify that this Open Graph object will be posted to Facebook
            object.provisionedForPost = YES;
            
            // for og:title
            object[@"title"] = [NSString stringWithFormat:@"%@ - %@", self.via.nome ,self.via.grado];
            
            // for og:type, this corresponds to the Namespace you've set for your app and the object type name
            object[@"type"] = @"ingeniousapps-iclimb:route";
            
            // for og:description
            object[@"description"] = self.commentTextView.text;
            
            // for og:url, we cover how this is used in the "Deep Linking" section below
            NSString *appWebSiteDomain = [PFConfig currentConfig][kpcAppWebSiteDomain];
            object[@"url"] = [NSString stringWithFormat:@"%@/route/%@", appWebSiteDomain, self.via.objectId];
            
            //Custom properties:
            NSDictionary *customProperties = @{@"fal_name":self.falesiaName,
                                               @"sec_name":self.sectorName,
                                               @"rep_mode":self.repetitionMode.text,
                                               @"rep_beauty":[NSString stringWithFormat:@"%@/5", [[NSNumber numberWithInt:(int)self.stepperBeauty.value] stringValue]],
                                               @"rep_comment":self.commentTextView.text};
            object[@"data"] = customProperties;
            
            // Post custom object
            [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                if(!error) {
                    // get the object ID for the Open Graph object that is now stored in the Object API
                    NSString *objectId = [result objectForKey:@"id"];
                    
                    // Further code to post the OG story goes here
                    // create an Open Graph action
                    id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
                    [action setObject:objectId forKey:@"route"];
                    
                    // create action referencing user owned object
                    [FBRequestConnection startForPostWithGraphPath:@"/me/ingeniousapps-iclimb:complete" graphObject:action completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                        if(!error) {
                            NSLog(@"%@", [NSString stringWithFormat:@"OG story posted, story id: %@", [result objectForKey:@"id"]]);
                        } else {
                            // An error occurred
                            [self unblockUIElements];
                            NSLog(@"Encountered an error posting to Open Graph: %@", error);
                            [TSMessage showNotificationInViewController:self
                                                                  title:@"Error"
                                                               subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                                   type:TSMessageNotificationTypeError];
                        }
                    }];
                    
                } else {
                    // An error occurred
                    [self unblockUIElements];
                    NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                    [TSMessage showNotificationInViewController:self
                                                          title:@"Error"
                                                       subtitle:[[error.description substringToIndex:30] stringByAppendingString:@"..."]
                                                           type:TSMessageNotificationTypeError];
                }
            }];
            
        }else{
            [self unblockUIElements];
            [TSMessage showNotificationInViewController:self
                                                  title:@"You are not linked to Facebook."
                                               subtitle:@"We cannot share your repetition to Facebook if you did not linked your account to Facebook."
                                                   type:TSMessageNotificationTypeError];
        }
    }
}


#pragma mark - UITextViewDelegate
- (BOOL) textView: (UITextView*) textView shouldChangeTextInRange: (NSRange) range replacementText: (NSString*) text {
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }else{
        return textView.text.length + (text.length - range.length) <= 120;
    }
}

#pragma mark - UIPickerViewDelegate
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [self.repetitionModes objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    //NSLog(@"Repeition mode selected: %@\n", [repetitionModes objectAtIndex:row]);
    self.repetitionMode.text = [repetitionModes objectAtIndex:row];
    [self.repetitionMode resignFirstResponder];
}


#pragma mark - UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.repetitionModes count];
}

#pragma mark - MBProgressHUDDelegate
- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [HUD removeFromSuperview];
    HUD = nil;
}

#pragma mark - ()

//- (void)registerForKeyboardNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWasShown:)
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillBeHidden:)
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    
//}

// Called when the UIKeyboardDidShowNotification is sent.

- (void)textViewDidBeginEditing:(UITextView *)textView {
        CGRect bkgndRect = self.commentTextView.superview.frame;
        bkgndRect.size.height += 216;
        [self.commentTextView.superview setFrame:bkgndRect];
        [self.scrollView setContentOffset:CGPointMake(0.0, self.commentTextView.frame.origin.y-216) animated:YES];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    
    //-----
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
//    
//    // If active text field is hidden by keyboard, scroll it so it's visible
//    // Your app might not need or want this behavior.
//    CGRect aRect = self.view.frame;
//    aRect.size.height -= kbSize.height;
//    if (!CGRectContainsPoint(aRect, self.commentTextView.frame.origin) ) {
//        [self.scrollView scrollRectToVisible:self.commentTextView.frame animated:YES];
//    }
    
    //-----
    
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    CGRect bkgndRect = self.commentTextView.superview.frame;
//    bkgndRect.size.height += kbSize.height;
//    [self.commentTextView.superview setFrame:bkgndRect];
//    [self.scrollView setContentOffset:CGPointMake(0.0, self.commentTextView.frame.origin.y-kbSize.height) animated:YES];
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    
//    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
//    self.scrollView.contentInset = contentInsets;
//    self.scrollView.scrollIndicatorInsets = contentInsets;
    
//    NSDictionary* info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    CGRect bkgndRect = self.commentTextView.superview.frame;
//    bkgndRect.size.height += kbSize.height;
//    [self.commentTextView.superview setFrame:bkgndRect];
//    [self.scrollView setContentOffset:CGPointMake(0.0, self.commentTextView.frame.origin.y-kbSize.height) animated:YES];
    
    //[self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

- (void)switchChanged:(SevenSwitch *)sender {
    if (sender.on) {
        shareToFacebookSwitchValue = YES;
    }else{
        shareToFacebookSwitchValue = NO;
    }
}

- (void)blockUIElements {
    
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    // Set determinate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    [HUD show:YES];
    
    self.saveButton.enabled = NO;
    self.cancelButton.enabled = NO;
    
}

- (void)unblockUIElements {
    
    [HUD hide:YES];
    
    self.saveButton.enabled = YES;
    self.cancelButton.enabled = YES;
}

@end
