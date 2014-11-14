//
//  PAPUtility.h
//  Anypic
//
//  Created by Mattieu Gamache-Asselin on 5/18/12.
//

#import "Cache.h"
#import <Parse/Parse.h>
#import "Region.h"
#import "TSMessage.h"

@interface Utility : NSObject

+ (void)followUserInBackground:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)followUserEventually:(PFUser *)user block:(void (^)(BOOL succeeded, NSError *error))completionBlock;
+ (void)unfollowUserEventually:(PFUser *)user;
+ (void)saveBestRouteRepetition:(NSString *)repetitionGrade;
+ (NSMutableArray *)configureRegionsListWithFalesie:(NSDictionary *)falesie;
+ (void)networkUnreachableTSMessage:(UIViewController *)vc;
+ (void)networkUnreachableTSMessage;
+ (void)getFollowingUsersForUser:(PFUser *)user;
+ (void)getFollowingUsersForUser:(PFUser *)user block:(void (^)(NSError *error))completionBlock;
+ (NSString *)getGradeStringFromValue:(NSNumber *)value;
+ (NSString *)getGradeStringFromValueWithoutFraction:(NSNumber *)value;
+ (NSNumber *)getGradeValueFromString:(NSString *)string;
@end
