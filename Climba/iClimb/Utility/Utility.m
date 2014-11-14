//
//  PAPUtility.m
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/18/12.
//

#import "Utility.h"

@implementation Utility

#pragma mark User Following

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
    [followActivity setObject:user forKey:kPAPActivityToUserKey];
    [followActivity setObject:kPAPActivityTypeFollow forKey:kPAPActivityTypeKey];
    
    [followActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (completionBlock) {
            completionBlock(succeeded, error);
        }
    }];
    [[Cache sharedCache] setFollowStatus:YES user:user];
}

+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock {
    
    //Non posso fare il following di me stesso!
    if ([[user objectId] isEqualToString:[[PFUser currentUser] objectId]]) {
        return;
    }
    
    PFObject *followActivity = [PFObject objectWithClassName:kPAPActivityClassKey];
    [followActivity setObject:[PFUser currentUser] forKey:kPAPActivityFromUserKey];
    [followActivity setObject:user forKey:kPAPActivityToUserKey];
    [followActivity setObject:kPAPActivityTypeFollow forKey:kPAPActivityTypeKey];
    
    [followActivity saveEventually:completionBlock];
    [[Cache sharedCache] setFollowStatus:YES user:user];
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"following"];
    [relation addObject:user]; // user is a PFUser that represents the friend
    [[PFUser currentUser] saveInBackground];
}

+ (void)unfollowUserEventually:(PFUser *)user {
    PFQuery *query = [PFQuery queryWithClassName:kPAPActivityClassKey];
    [query whereKey:kPAPActivityFromUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kPAPActivityToUserKey equalTo:user];
    [query whereKey:kPAPActivityTypeKey equalTo:kPAPActivityTypeFollow];
    [query findObjectsInBackgroundWithBlock:^(NSArray *followActivities, NSError *error) {
        // While normally there should only be one follow activity returned, we can't guarantee that.
        
        if (!error) {
            for (PFObject *followActivity in followActivities) {
                [followActivity deleteEventually];
            }
        }
    }];
    [[Cache sharedCache] setFollowStatus:NO user:user];
    
    PFRelation *relation = [[PFUser currentUser] relationForKey:@"following"];
    [relation removeObject:user]; // user is a PFUser that represents the friend
    [[PFUser currentUser] saveInBackground];
}

// Used when converting the users grade retrieved from Parse
// (es: 14.5 = "6a+.5", 15.3 = "6b.3")
+ (NSString *)getGradeStringFromValue:(NSNumber *)value {
    NSDictionary *scalaGradiInvertita = @{
                                          @1: @"3a", @2: @"3a+", @3: @"3b", @4: @"3b+", @5: @"3c", @6: @"3c+",
                                          @7: @"4a", @8: @"4a+", @9: @"4b", @10: @"4b+", @11: @"4c", @12: @"4c+",
                                          @13: @"5a", @14: @"5a+", @15: @"5b", @16: @"5b+", @17: @"5c", @18: @"5c+",
                                          @19: @"6a", @20: @"6a+", @21: @"6b", @22: @"6b+", @23: @"6c", @24: @"6c+",
                                          @25: @"7a", @26: @"7a+", @27: @"7b", @28: @"7b+", @29: @"7c", @30: @"7c+",
                                          @31: @"8a", @32: @"8a+", @33: @"8b", @34: @"8b+", @35: @"8c", @36: @"8c+",
                                          @37: @"9a", @38: @"9a+", @39: @"9b", @40: @"9b+", @41: @"9c", @42: @"9c+",
                                 };
    NSNumber *grade = [NSNumber numberWithInt:[value intValue]];
    NSString *valueString = [value stringValue];
    NSCharacterSet *cset = [NSCharacterSet characterSetWithCharactersInString:@"."];
    NSRange range = [valueString rangeOfCharacterFromSet:cset];

    if (range.location == NSNotFound) {
        NSString *gradeString = [NSString stringWithFormat:@"%@.0", (NSString *)[scalaGradiInvertita objectForKey:grade]  ];
        return gradeString;
    } else {
        NSString *decimal = [[[value stringValue]componentsSeparatedByString: @"."] lastObject];
        NSString *gradeString = [NSString stringWithFormat:@"%@.%@", (NSString *)[scalaGradiInvertita objectForKey:grade],  [decimal substringToIndex:1]  ];
        return gradeString;
    }
}

+ (NSString *)getGradeStringFromValueWithoutFraction:(NSNumber *)value {
    NSDictionary *scalaGradiInvertita = @{
                                          @1: @"3a", @2: @"3a+", @3: @"3b", @4: @"3b+", @5: @"3c", @6: @"3c+",
                                          @7: @"4a", @8: @"4a+", @9: @"4b", @10: @"4b+", @11: @"4c", @12: @"4c+",
                                          @13: @"5a", @14: @"5a+", @15: @"5b", @16: @"5b+", @17: @"5c", @18: @"5c+",
                                          @19: @"6a", @20: @"6a+", @21: @"6b", @22: @"6b+", @23: @"6c", @24: @"6c+",
                                          @25: @"7a", @26: @"7a+", @27: @"7b", @28: @"7b+", @29: @"7c", @30: @"7c+",
                                          @31: @"8a", @32: @"8a+", @33: @"8b", @34: @"8b+", @35: @"8c", @36: @"8c+",
                                          @37: @"9a", @38: @"9a+", @39: @"9b", @40: @"9b+", @41: @"9c", @42: @"9c+",
                                          };
    NSNumber *grade = [NSNumber numberWithInt:[value intValue]];
    NSString *gradeString = [NSString stringWithFormat:@"%@", (NSString *)[scalaGradiInvertita objectForKey:grade]  ];
    return gradeString;
}

+ (NSNumber *)getGradeValueFromString:(NSString *)string {
    NSDictionary *scalaGradi = @{
                                 @"3a": @1, @"3a+": @2, @"3b": @3, @"3b+": @4, @"3c": @5, @"3c+": @6,
                                 @"4a": @7, @"4a+": @8, @"4b": @9, @"4b+": @10, @"4c": @11, @"4c+": @12,
                                 @"5a": @13, @"5a+": @14, @"5b": @15, @"5b+": @16, @"5c": @17, @"5c+": @18,
                                 @"6a": @19, @"6a+": @20, @"6b": @21, @"6b+": @22, @"6c": @23, @"6c+": @24,
                                 @"7a": @25, @"7a+": @26, @"7b": @27, @"7b+": @28, @"7c": @29, @"7c+": @30,
                                 @"8a": @31, @"8a+": @32, @"8b": @33, @"8b+": @34, @"8c": @35, @"8c+": @36,
                                 @"9a": @37, @"9a+": @38, @"9b": @39, @"9b+": @40, @"9c": @41, @"9c+": @42,
                                 };
    
    NSNumber *gradeNumber = [scalaGradi objectForKey:string];
    return gradeNumber;

}

+ (void)saveBestRouteRepetition:(NSString *)repetitionGrade {
    
    NSDictionary *scalaGradi = @{
                                 @"3a": @1, @"3a+": @2, @"3b": @3, @"3b+": @4, @"3c": @5, @"3c+": @6,
                                 @"4a": @7, @"4a+": @8, @"4b": @9, @"4b+": @10, @"4c": @11, @"4c+": @12,
                                 @"5a": @13, @"5a+": @14, @"5b": @15, @"5b+": @16, @"5c": @17, @"5c+": @18,
                                 @"6a": @19, @"6a+": @20, @"6b": @21, @"6b+": @22, @"6c": @23, @"6c+": @24,
                                 @"7a": @25, @"7a+": @26, @"7b": @27, @"7b+": @28, @"7c": @29, @"7c+": @30,
                                 @"8a": @31, @"8a+": @32, @"8b": @33, @"8b+": @34, @"8c": @35, @"8c+": @36,
                                 @"9a": @37, @"9a+": @38, @"9b": @39, @"9b+": @40, @"9c": @41, @"9c+": @42,
                                 };
    
    NSString *previousBestGrade = [PFUser currentUser][@"bestRouteGrade"];
    
    if (isnumber([repetitionGrade characterAtIndex:0])) {
        int previous = [scalaGradi[previousBestGrade] intValue];
        int current = [scalaGradi[repetitionGrade] intValue];
        
        if (current >= previous) {
            [[PFUser currentUser] setObject:repetitionGrade forKey:@"bestRouteGrade"];
            [[PFUser currentUser] saveInBackground];
        }
    }
    
}

+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
    //UIGraphicsBeginImageContext(newSize);
    // In next line, pass 0.0 to use the current device's pixel scaling factor (and thus account for Retina resolution).
    // Pass 1.0 to force exact pixel size.
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+ (NSMutableArray *)configureRegionsListWithFalesie:(NSDictionary *)falesie {
    NSMutableDictionary *regions = [[NSMutableDictionary alloc] initWithCapacity:20];
    
    Region *region = [[Region alloc] init];
    region.nome = @"Val d'Aosta";
    region.falesie = [falesie[@"Val d'Aosta"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Piemonte";
    region.falesie = [falesie[@"Piemonte"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Lombardia";
    region.falesie = [falesie[@"Lombardia"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Trentino Alto Adige";
    region.falesie = [falesie[@"Trentino Alto Adige"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Veneto";
    region.falesie = [falesie[@"Veneto"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Friuli Venezia Giulia";
    region.falesie = [falesie[@"Friuli Venezia Giulia"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Emilia Romagna";
    region.falesie = [falesie[@"Emilia Romagna"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Liguria";
    region.falesie = [falesie[@"Liguria"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Toscana";
    region.falesie = [falesie[@"Toscana"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Umbria";
    region.falesie = [falesie[@"Umbria"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Marche";
    region.falesie = [falesie[@"Marche"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Abruzzo";
    region.falesie = [falesie[@"Abruzzo"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Molise";
    region.falesie = [falesie[@"Molise"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Lazio";
    region.falesie = [falesie[@"Lazio"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Basilicata";
    region.falesie = [falesie[@"Basilicata"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Campania";
    region.falesie = [falesie[@"Campania"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Puglia";
    region.falesie = [falesie[@"Puglia"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Calabria";
    region.falesie = [falesie[@"Calabria"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Sicilia";
    region.falesie = [falesie[@"Sicilia"] intValue];
    [regions setObject:region forKey:region.nome];
    
    region = [[Region alloc] init];
    region.nome = @"Sardegna";
    region.falesie = [falesie[@"Sardegna"] intValue];
    [regions setObject:region forKey:region.nome];
    
    return [NSMutableArray arrayWithArray:[regions allValues]];
}

+ (void)networkUnreachableTSMessage:(UIViewController *)vc {
    [TSMessage showNotificationInViewController:vc
                                          title:@"No Network available!"
                                       subtitle:@"Climba needs Internet to works. Please find a working Internet connection and try again. :("
                                           type:TSMessageNotificationTypeWarning];
}

+ (void)networkUnreachableTSMessage {
    [TSMessage showNotificationWithTitle:@"No Network available!"
                                subtitle:@"Climba needs Internet to works. Please find a working Internet connection and try again. :("
                                    type:TSMessageNotificationTypeWarning];
}

+ (void)getFollowingUsersForUser:(PFUser *)user {
    PFRelation *followingRelation = [user relationForKey:@"following"];
    [[followingRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFUser *followingFriend in objects) {
                [[Cache sharedCache] setFollowStatus:YES user:followingFriend];
            }
        } else {
            NSLog(@"Error downloading 'following' relations for user %@:\n%@", user.username, error.description);
        }
    }];
}

+ (void)getFollowingUsersForUser:(PFUser *)user block:(void (^)(NSError *error))completionBlock {
    PFRelation *followingRelation = [user relationForKey:@"following"];
    [[followingRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFUser *followingFriend in objects) {
                [[Cache sharedCache] setFollowStatus:YES user:followingFriend];
            }
            if (completionBlock) {
                completionBlock(error);
            }
        } else {
            NSLog(@"Error downloading 'following' relations for user %@:\n%@", user.username, error.description);
        }
    }];
}
@end
