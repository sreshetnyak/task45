//
//  TTDetailViewController.m
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTDetailViewController.h"
#import "TTInfoTableViewCell.h"
#import "TTUser.h"
#import "TTServerManager.h"
#import "UIImageView+AFNetworking.h"
#import "TTWall.h"
#import "TTPostTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "TTDetailTableViewCell.h"

#define DELTA_LABEL 35
#define DELTA_SCALE 0.4f

@interface TTDetailViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) TTUser *user;
@property (assign,nonatomic) BOOL loadingData;
@property (strong,nonatomic) NSMutableArray *wallPostArray;

@end

@implementation TTDetailViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wallPostArray = [NSMutableArray array];
    self.loadingData = YES;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.myapp.queue", NULL);
    
    dispatch_async(serialQueue, ^{

        dispatch_async(dispatch_get_main_queue(), ^{
            [self getUserFromIds:self.userID];
        });
    });

}

- (void)getUserFromIds:(NSString *)ids {
    
    [[TTServerManager sharedManager] getUserWithIds:ids onSuccess:^(TTUser *user) {
        self.user = user;
        [self.tableView reloadData];
        [self getWallPostFromServer];
        
    } onFailure:^(NSError *error) {
        
    }];
    
}

- (void)getWallPostFromServer {

    [[TTServerManager sharedManager]getWallPostWithUserIds:self.userID count:5  offset:[self.wallPostArray count] onSuccess:^(NSArray *wallPost) {
        
         if ([wallPost count] > 0) {
             
             dispatch_queue_t serialQueue = dispatch_queue_create("com.myapp.queue.wall", NULL);
             
             int newCount = (int)[self.wallPostArray count] + (int)[wallPost count];
             
             __block int iObj = 0;
             
             for (int i = newCount - (int)[wallPost count]; i < newCount; i++) {
             
                 dispatch_async(serialQueue, ^{
                     
                     TTWall *wall = [wallPost objectAtIndex:iObj];
                     iObj++;
                     
                     if (self.user.photoURL != nil) {
                         NSData * dataUserPhoto = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.user.photoURL]];
                         wall.userPhoto = [UIImage imageWithData:dataUserPhoto];
                     }
                     
                     if (wall.postImageURL != nil) {
                         NSData * dataPostPhoto = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:wall.postImageURL]];
                         wall.postPhoto = [UIImage imageWithData:dataPostPhoto];
                     }

                    [self.wallPostArray insertObject:wall atIndex:i];
                     
                     dispatch_async(dispatch_get_main_queue(), ^{
                         
                         [self.tableView beginUpdates];
                         
                         [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:1]] withRowAnimation:UITableViewRowAnimationFade];
                         
                         [self.tableView endUpdates];
                         
                         if (iObj == [wallPost count]) {
                             self.loadingData = NO;
                         }

                     });
                     

                 });
             }
         }

        
    } onFailure:^(NSError *error) {
        
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getWallPostFromServer];
        }
    }
}

- (NSString *) stringByStrippingHTML:(NSString *)string {
    
    NSRange r;
    while ((r = [string rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound) {
    
        string = [string stringByReplacingCharactersInRange:r withString:@""];
    }

    return string;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 1;
    } else {
        return [self.wallPostArray count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *infoIdentifier = @"infocell";
    static NSString *postIdentifier = @"postcell";
    
    
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        
        TTInfoTableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:infoIdentifier];
        
        if (!infoCell) {
            infoCell = [[TTInfoTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:infoIdentifier];
        }
        
        infoCell.firstLastName.text = [NSString stringWithFormat:@"%@ %@",self.user.firstName,self.user.lastName];
        infoCell.status.text = self.user.onlineStatus ? @"Online" : @"Offline";
        infoCell.location.text = [NSString stringWithFormat:@"%@ %@",self.user.countryName ? self.user.countryName : @"" ,self.user.cityName ? self.user.cityName : @""];
        infoCell.universityLabel.text = self.user.universityName;
        infoCell.universityLabel.lineBreakMode = NSLineBreakByWordWrapping;
        infoCell.universityLabel.numberOfLines = 0;
        
        infoCell.photoView.image = nil;
        
        NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:self.user.photoURL]];
        
        __weak TTInfoTableViewCell *weakInfoCell = infoCell;
        
        [infoCell.photoView setImageWithURLRequest:request
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               weakInfoCell.photoView.image = image;
                                               
                                               CALayer *imageLayer = weakInfoCell.photoView.layer;
                                               [imageLayer setCornerRadius:43];
                                               [imageLayer setBorderWidth:2];
                                               [imageLayer setBorderColor:[[UIColor grayColor] CGColor]];
                                               [imageLayer setMasksToBounds:YES];
                                               
                                               
            
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
            
                                           }];
        
        return infoCell;
        
    } else if (indexPath.section == 1){
    
        TTPostTableViewCell *postCell = [tableView dequeueReusableCellWithIdentifier:postIdentifier];
        
        if (!postCell) {
            postCell = [[TTPostTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:postIdentifier];
        }

        TTWall *wall = [self.wallPostArray objectAtIndex:indexPath.row];
        
        postCell.userImageView.image = wall.userPhoto;
        CALayer *imageLayer = postCell.userImageView.layer;
        [imageLayer setCornerRadius:20];
        [imageLayer setBorderWidth:1];
        [imageLayer setBorderColor:[[UIColor grayColor] CGColor]];
        [imageLayer setMasksToBounds:YES];

        postCell.dateLabel.text = wall.date;
        postCell.textPostLabel.text = [self stringByStrippingHTML:wall.text];
        
        CGSize constrainedSize = CGSizeMake(postCell.textPostLabel.frame.size.width, 100);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10.0], NSFontAttributeName,nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self stringByStrippingHTML:wall.text] attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (requiredHeight.size.width > postCell.textPostLabel.frame.size.width) {
            requiredHeight = CGRectMake(0,0, postCell.textPostLabel.frame.size.width, requiredHeight.size.height);
        }
        CGRect newFrame = postCell.textPostLabel.frame;
        newFrame.size.height = requiredHeight.size.height;
        postCell.textPostLabel.frame = newFrame;
        
        postCell.postImageView.image = nil;
        
        if (wall.postImageURL != nil) {
            
            postCell.postImageView.image = wall.postPhoto;
            postCell.postImageView.frame = CGRectMake(newFrame.origin.x, newFrame.size.height + DELTA_LABEL ,wall.postPhoto.size.width * DELTA_SCALE, wall.postPhoto.size.height * DELTA_SCALE);
            
        }
        
        return postCell;
        
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 && indexPath.section == 0) {
        return 100;
    } else if (indexPath.section == 1) {
        
        TTWall *wall = [self.wallPostArray objectAtIndex:indexPath.row];
        
        TTPostTableViewCell *postCell = (TTPostTableViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
        
        CGSize constrainedSize = CGSizeMake(postCell.textPostLabel.frame.size.width, 100);
        
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"HelveticaNeue" size:10.0], NSFontAttributeName,nil];
        
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[self stringByStrippingHTML:wall.text] attributes:attributesDictionary];
        
        CGRect requiredHeight = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        
        if (requiredHeight.size.width > postCell.textPostLabel.frame.size.width) {
            requiredHeight = CGRectMake(0,0, postCell.textPostLabel.frame.size.width, requiredHeight.size.height);
        }
        CGRect newFrame = postCell.frame;
        newFrame.size.height = requiredHeight.size.height + DELTA_LABEL;
        
        if (wall.postImageURL != nil) {
            
            float height = newFrame.size.height + postCell.postImageView.frame.size.height + 10;
            
            return height;
            
        } else {
            
            return newFrame.size.height;
        }
        
    } else {
        return 36;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    NSLog(@"release");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
