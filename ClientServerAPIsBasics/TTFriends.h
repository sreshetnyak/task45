//
//  TTFriends.h
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTFriends : NSObject

@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (strong,nonatomic) NSString *photoURL;
@property (strong,nonatomic) NSString *userID;

- (instancetype)initWithDictionary:(NSDictionary *) responseObject;

@end
