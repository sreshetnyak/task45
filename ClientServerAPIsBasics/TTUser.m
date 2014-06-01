//
//  TTUser.m
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTUser.h"
#import "TTServerManager.h"

static const NSString * first_name = @"first_name";
static const NSString * last_name = @"last_name";
static const NSString * photo_200 = @"photo_200";
static const NSString * user_id = @"uid";
static const NSString * university_name = @"university_name";
static const NSString * online = @"online";


@implementation TTUser

- (instancetype)initWithDictionary:(NSDictionary *) responseObject {
    
    self = [super init];
    if (self) {
        self.firstName = [responseObject objectForKey:first_name];
        self.lastName = [responseObject objectForKey:last_name];
        self.userIds = [responseObject objectForKey:user_id];
        self.photoURL = [responseObject objectForKey:photo_200];
        self.universityName = [responseObject objectForKey:university_name];
        self.onlineStatus = [[responseObject objectForKey:online] boolValue];
    }
    return self;
}


@end
