//
//  TTWall.m
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/30/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTWall.h"
#import "UIImageView+AFNetworking.h"

@implementation TTWall


- (instancetype)initWithDictionary:(NSDictionary *) responseObject {
    
    self = [super init];
    if (self) {
        self.text = [responseObject objectForKey:@"text"];
        
        NSDateFormatter *dateFormater = [[NSDateFormatter alloc]init];
        [dateFormater setDateFormat:@"dd MMM yyyy "];
        NSDate *dateTime = [NSDate dateWithTimeIntervalSince1970:[[responseObject objectForKey:@"date"] floatValue]];
        NSString *date = [dateFormater stringFromDate:dateTime];
        self.date = date;
        
        NSDictionary *dict = [responseObject objectForKey:@"attachment"];
        NSDictionary *dictTemp = [dict objectForKey:@"photo"];
        
        self.postImageURL = [dictTemp objectForKey:@"src_big"];
    }
    return self;
}

@end
