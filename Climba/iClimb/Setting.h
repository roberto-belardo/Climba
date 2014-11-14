//
//  Setting.h
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SETTING_LINK_TO_FACEBOOK 1
#define SETTING_LINK_TO_FACEBOOK_DISPLAY_NAME @"Link to Facebook"
#define SETTING_UNLINK_FROM_FACEBOOK 2
#define SETTING_UNLINK_FROM_FACEBOOK_DISPLAY_NAME @"Unlink from Facebook"
#define SETTING_CREDITS 3
#define SETTING_CREDITS_DISPLAY_NAME @"Credits"
#define SETTING_LOG_OUT 4
#define SETTING_LOG_OUT_DISPLAY_NAME @"Log Out"
#define SETTING_WALKTHROUGH 5
#define SETTING_WALKTHROUGH_DISPLAY_NAME @"Walkthrough"


#define SETTING_SELECTABLE 1
#define SETTING_UNSELECTABLE 0

@interface Setting : NSObject

@property (nonatomic, retain) NSNumber *settingId;
@property (nonatomic, retain) NSString *displayName;
@property (nonatomic, retain) NSNumber *selectable;

- (id) initWithDisplayName:(NSString *)displayName settingId:(NSNumber *)settingId;
- (void) setSettingUnselectable;

@end
