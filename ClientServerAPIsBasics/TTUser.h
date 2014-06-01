//
//  TTUser.h
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTUser : NSObject

@property (strong,nonatomic) NSString *firstName;
@property (strong,nonatomic) NSString *lastName;
@property (assign,nonatomic) BOOL onlineStatus;
@property (strong,nonatomic) NSString *photoURL;
@property (strong,nonatomic) NSString *userIds;
@property (strong,nonatomic) NSString *universityName;
@property (strong,nonatomic) NSString *cityName;
@property (strong,nonatomic) NSString *countryName;

- (instancetype)initWithDictionary:(NSDictionary *) responseObject;

@end
