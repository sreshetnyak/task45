//
//  TTWall.h
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/30/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTWall : NSObject

@property (strong,nonatomic) NSString *text;
@property (strong,nonatomic) NSString *date;
@property (strong,nonatomic) NSString *postImageURL;
@property (strong,nonatomic) UIImage *userPhoto;
@property (strong,nonatomic) UIImage *postPhoto;

- (instancetype)initWithDictionary:(NSDictionary *) responseObject;

@end
