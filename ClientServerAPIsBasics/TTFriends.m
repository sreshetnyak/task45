//
//  TTFriends.m
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTFriends.h"

static const NSString * first_name = @"first_name";
static const NSString * last_name = @"last_name";
static const NSString * photo_100 = @"photo_100";
static const NSString * user_id = @"user_id";

@implementation TTFriends

- (instancetype)initWithDictionary:(NSDictionary *) responseObject {

    self = [super init];
    if (self) {
        self.firstName = [responseObject objectForKey:first_name];
        self.lastName = [responseObject objectForKey:last_name];
        self.userID = [responseObject objectForKey:user_id];
        self.photoURL = [responseObject objectForKey:photo_100];
    }
    return self;
}

@end
