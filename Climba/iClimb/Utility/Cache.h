//
//  PAPCache.h
//  Anypic
//
//  Created by Héctor Ramos on 5/31/12.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface Cache : NSObject

+ (id)sharedCache;

- (void)clear;

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user;
- (NSDictionary *)attributesForUser:(PFUser *)user;
- (BOOL)followStatusForUser:(PFUser *)user;
- (void)setFollowStatus:(BOOL)following user:(PFUser *)user;
- (void)setFalesieNumberPerRegion:(NSDictionary *)falesie;
- (NSDictionary *)getFalesieNumberPerRegion;
- (void)setFacebookFriends:(NSArray *)friends;
- (NSArray *)facebookFriends;
- (void)addFalesiaToFavourites:(NSString *)falesiaId;
- (void)removeFalesiaFromFavourites:(NSString *)falesiaId;
- (NSArray *)getFavouriteFalesie;
@end
