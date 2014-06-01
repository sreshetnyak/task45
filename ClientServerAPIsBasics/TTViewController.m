//
//  TTViewController.m
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import "TTViewController.h"
#import "TTServerManager.h"
#import "TTFriends.h"
#import "TTFriendsTableViewCell.h"
#import "UIImageView+AFNetworking.h"
#import "TTDetailViewController.h"

@interface TTViewController () <UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (strong,nonatomic) NSMutableArray *friendsArray;
@property (assign,nonatomic) BOOL loadingData;

@end

@implementation TTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.friendsArray = [NSMutableArray array];
    self.loadingData = YES;
    [self getFriendFromServer];
    
}

- (void)getFriendFromServer {


    [[TTServerManager sharedManager]getFriendsWithCount:10 offset:[self.friendsArray count] onSuccess:^(NSArray *friends) {
       
        
        [self.friendsArray addObjectsFromArray:friends];
        if ([friends count] > 0) {
            
            NSMutableArray* newPaths = [NSMutableArray array];
            
            for (int i = (int)[self.friendsArray count] - (int)[friends count]; i < [self.friendsArray count]; i++) {
                [newPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            }
            
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:newPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            self.loadingData = NO;
        }
        
    } onFailure:^(NSError *error) {
        NSLog(@"%@",[error localizedDescription]);
    }];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height) {
        if (!self.loadingData)
        {
            self.loadingData = YES;
            [self getFriendFromServer];
        }
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friendsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *identifier = @"cell";
    
    TTFriendsTableViewCell *cell = (TTFriendsTableViewCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[TTFriendsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    
    TTFriends *friend = [self.friendsArray objectAtIndex:indexPath.row];
    
    cell.firstNameLabel.text = [NSString stringWithFormat:@"%@",friend.firstName];
    cell.lastNameLabel.text = [NSString stringWithFormat:@"%@",friend.lastName];
    
    cell.photoView.image = nil;
    
    NSURLRequest *request = [[NSURLRequest alloc]initWithURL:[NSURL URLWithString:friend.photoURL]];
    
    __weak TTFriendsTableViewCell *weakCell = cell;
    
    [cell.photoView setImageWithURLRequest:request
                          placeholderImage:nil
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       [UIView transitionWithView:weakCell.photoView
                                                         duration:0.3f
                                                          options:UIViewAnimationOptionTransitionCrossDissolve
                                                       animations:^{
                                                           weakCell.photoView.image = image;
                                                       } completion:NULL];
                                       
                                       
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        
                                   }];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString: @"Detail"]) {
        
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        TTFriends *friend = [self.friendsArray objectAtIndex:indexPath.row];
        TTDetailViewController *dest = [segue destinationViewController];
        [dest setUserID:friend.userID];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
