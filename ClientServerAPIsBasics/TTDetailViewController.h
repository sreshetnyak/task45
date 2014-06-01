//
//  TTDetailViewController.h
//  ClientServerAPIsBasics
//
//  Created by Sergey Reshetnyak on 5/29/14.
//  Copyright (c) 2014 sergey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TTDetailViewController : UIViewController

@property (strong,nonatomic) NSString *userID;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
