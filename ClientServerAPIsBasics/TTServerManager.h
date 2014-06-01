//
//  TTServerManager.h
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TTUser.h"

@interface TTServerManager : NSObject

+ (TTServerManager *)sharedManager;

- (void)getFriendsWithCount:(NSInteger)count offset:(NSInteger)offset onSuccess:(void (^) (NSArray *friends)) success onFailure:(void (^) (NSError *error)) failure;
- (void)getUserWithIds:(NSString *)ids onSuccess:(void (^) (TTUser *user)) success onFailure:(void (^) (NSError *error)) failure;
- (void)getCityWithIds:(NSString *)ids onSuccess:(void (^) (NSString *city)) success onFailure:(void (^) (NSError *error)) failure;
- (void)getCountryWithIds:(NSString *)ids onSuccess:(void (^) (NSString *country)) success onFailure:(void (^) (NSError *error)) failure;
- (void)getWallPostWithUserIds:(NSString *)ids count:(NSInteger)count offset:(NSInteger)offset onSuccess:(void (^) (NSArray *wallPost)) success onFailure:(void (^) (NSError *error)) failure;
@end
