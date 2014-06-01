//
//  TTPostTableViewCell.h
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/30/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTPostTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *textPostLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;

@end
