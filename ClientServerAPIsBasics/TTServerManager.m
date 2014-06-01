//
//  TTServerManager.m
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTServerManager.h"
#import "AFNetworking.h"
#import "TTFriends.h"
#import "TTWall.h"

@interface TTServerManager ()

@property (strong,nonatomic) AFHTTPRequestOperationManager *requestOperationManager;

@end

@implementation TTServerManager

+ (TTServerManager *)sharedManager {
    
    static TTServerManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[TTServerManager alloc]init];
        
    });
    
    return manager;
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://api.vk.com/method/"]];
        
    }
    return self;
}

- (void)getFriendsWithCount:(NSInteger)count offset:(NSInteger)offset onSuccess:(void (^) (NSArray *friends)) success onFailure:(void (^) (NSError *error)) failure {

    
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"12847675",@"user_id",@"name",@"order",@(count),@"count",@(offset),@"offset",@"photo_100,counters",@"fields",@"nom",@"name_case", nil];
    
    [self.requestOperationManager GET:@"friends.get" parameters:paramDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSArray *objects = [responseObject objectForKey:@"response"];
        
        NSMutableArray *arrayWithFriends = [[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in objects) {
            TTFriends *friend = [[TTFriends alloc]initWithDictionary:dict];
            [arrayWithFriends addObject:friend];
        }
        
        success(arrayWithFriends);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
        failure(error);
    }];
    
}

- (void)getUserWithIds:(NSString *)ids onSuccess:(void (^)(TTUser *))success onFailure:(void (^)(NSError *))failure {
    
    __block TTUser *user = nil;
    
    dispatch_group_t group = dispatch_group_create();
    
   
    dispatch_group_enter(group);
    
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"user_ids",@"photo_200,city,sex,bdate,city,country,online,education,counters",@"fields", nil];
    
    [self.requestOperationManager GET:@"users.get" parameters:paramDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        NSArray *objects = [responseObject objectForKey:@"response"];
        user = [[TTUser alloc]initWithDictionary:[objects firstObject]];
        
        [[TTServerManager sharedManager]getCityWithIds:[[objects firstObject] objectForKey:@"city"] onSuccess:^(NSString *city) {
            
            user.cityName = city;
            
            [[TTServerManager sharedManager]getCountryWithIds:[[objects firstObject] objectForKey:@"country"] onSuccess:^(NSString *country) {
                
                user.countryName = country;
                dispatch_group_leave(group);
                
            } onFailure:^(NSError *error) {
                
            }];
            
            
        } onFailure:^(NSError *error) {
            
        }];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        success(user);
    });
    
    
    
}

- (void)getCityWithIds:(NSString *)ids onSuccess:(void (^) (NSString *city)) success onFailure:(void (^) (NSError *error)) failure {
    
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"city_ids", nil];
    
    [self.requestOperationManager GET:@"database.getCitiesById" parameters:paramDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSArray *objects = [responseObject objectForKey:@"response"];
        NSString* city = [[objects firstObject] objectForKey:@"name"];
        success(city);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //NSLog(@"Error: %@", error);
        failure(error);
    }];
    
}


- (void)getCountryWithIds:(NSString *)ids onSuccess:(void (^) (NSString *country)) success onFailure:(void (^) (NSError *error)) failure {

    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"country_ids", nil];
    
    [self.requestOperationManager GET:@"database.getCountriesById" parameters:paramDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSArray *objects = [responseObject objectForKey:@"response"];
        NSString* country = [[objects firstObject] objectForKey:@"name"];
        success(country);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
    
}

- (void)getWallPostWithUserIds:(NSString *)ids count:(NSInteger)count offset:(NSInteger)offset onSuccess:(void (^) (NSArray *wallPost)) success onFailure:(void (^) (NSError *error)) failure {
    
    
    NSDictionary *paramDictionary = [NSDictionary dictionaryWithObjectsAndKeys:ids,@"owner_id",@(count),@"count",@(offset),@"offset",@"owner",@"filter", nil];
    
    [self.requestOperationManager GET:@"wall.get" parameters:paramDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        
        NSArray *objects = [responseObject objectForKey:@"response"];
        
        NSMutableArray *arrayWithWallPost = [[NSMutableArray alloc]init];
        
        for (int i = 1; i < [objects count]; i++) {
            
            TTWall *wall = [[TTWall alloc]initWithDictionary:[objects objectAtIndex:i]];
            [arrayWithWallPost addObject:wall];
            
        }
        
        success(arrayWithWallPost);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
    
}

@end
