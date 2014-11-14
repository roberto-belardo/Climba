//
//  Setting.m
//  iClimb
//
//  Created by Roberto Belardo on 26/09/14.
//  Copyright (c) 2014 IngeniusApp. All rights reserved.
//

#import "Setting.h"

@implementation Setting

- (id) initWithDisplayName:(NSString *)displayName settingId:(NSNumber *)settingId {
    if (self == [super init]) {
    
        self.displayName = displayName;
        self.settingId = settingId;
        self.selectable = [NSNumber numberWithInt:SETTING_SELECTABLE];
        
    } return self;
}

- (void) setSettingUnselectable {
    self.selectable = [NSNumber numberWithInt:SETTING_UNSELECTABLE];
}

@end
