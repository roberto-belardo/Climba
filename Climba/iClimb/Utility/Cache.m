//
//  PAPCache.m
//  Anypic
//
//  Created by Héctor Ramos on 5/31/12.
//

#import "Cache.h"

@interface Cache()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation Cache
@synthesize cache;

#pragma mark - Initialization

+ (id)sharedCache {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
    self = [super init];
    if (self) {
        self.cache = [[NSCache alloc] init];
    }
    return self;
}

#pragma mark - PAPCache

- (void)clear {
    [self.cache removeAllObjects];
}

- (void)setAttributes:(NSDictionary *)attributes forUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    [self.cache setObject:attributes forKey:key];
}

- (NSDictionary *)attributesForUser:(PFUser *)user {
    NSString *key = [self keyForUser:user];
    return [self.cache objectForKey:key];
}

- (BOOL)followStatusForUser:(PFUser *)user {
    NSDictionary *attributes = [self attributesForUser:user];
    if (attributes) {
        NSNumber *followStatus = [attributes objectForKey:kPAPUserAttributesIsFollowedByCurrentUserKey];
        if (followStatus) {
            return [followStatus boolValue];
        }
    }

    return NO;
}

- (void)setFollowStatus:(BOOL)following user:(PFUser *)user {
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self attributesForUser:user]];
    [attributes setObject:[NSNumber numberWithBool:following] forKey:kPAPUserAttributesIsFollowedByCurrentUserKey];
    [self setAttributes:attributes forUser:user];
}

- (void)setFacebookFriends:(NSArray *)friends {
    NSString *key = kPAPUserDefaultsCacheFacebookFriendsKey;
    [self.cache setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:friends forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)facebookFriends {
    NSString *key = kPAPUserDefaultsCacheFacebookFriendsKey;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *friends = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (friends) {
        [self.cache setObject:friends forKey:key];
    }

    return friends;
}

- (void)setFalesieNumberPerRegion:(NSDictionary *)falesie {
    NSString *key = kFalesieCountPerRegionCacheKey;
    
    [self.cache setObject:falesie forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:falesie forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)getFalesieNumberPerRegion {
    NSString *key = kFalesieCountPerRegionCacheKey;
    
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSDictionary *falesie = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (falesie) {
        [self.cache setObject:falesie forKey:key];
    }
    
    return falesie;
}

- (void)addFalesiaToFavourites:(NSString *)falesiaId {
    NSString *key = kFavouriteFalesie;
    
    NSMutableArray *favouriteFalesieIds = [[[NSUserDefaults standardUserDefaults] objectForKey:key] mutableCopy];
    if (!favouriteFalesieIds) {
        favouriteFalesieIds = [[NSMutableArray alloc] initWithObjects:falesiaId, nil];
    }else if (![favouriteFalesieIds containsObject:falesiaId]) {
        [favouriteFalesieIds addObject:falesiaId];
    }
    
    [self.cache setObject:favouriteFalesieIds forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:favouriteFalesieIds forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeFalesiaFromFavourites:(NSString *)falesiaId {
    NSString *key = kFavouriteFalesie;
    
    NSMutableArray *favouriteFalesieIds = [[[NSUserDefaults standardUserDefaults] objectForKey:key] mutableCopy];
    
    if (favouriteFalesieIds && [favouriteFalesieIds containsObject:falesiaId]) {
        [favouriteFalesieIds removeObject:falesiaId];
    }
    
    [self.cache setObject:favouriteFalesieIds forKey:key];
    [[NSUserDefaults standardUserDefaults] setObject:favouriteFalesieIds forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSArray *)getFavouriteFalesie {
    NSString *key = kFavouriteFalesie;
    if ([self.cache objectForKey:key]) {
        return [self.cache objectForKey:key];
    }
    
    NSArray *favouriteFalesieIds = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if (favouriteFalesieIds) {
        [self.cache setObject:favouriteFalesieIds forKey:key];
    }
    
    return favouriteFalesieIds;
}

#pragma mark - ()

- (NSString *)keyForUser:(PFUser *)user {
    return [NSString stringWithFormat:@"user_%@", [user objectId]];
}

@end
