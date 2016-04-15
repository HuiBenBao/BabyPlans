//
//  UserDetailController.m
//  BabyPlans
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserDetailController.h"

@interface UserDetailController ()

@property (nonatomic,strong) UserMessModel * userModel;


@end

@implementation UserDetailController
+ (instancetype)userDetailWithModel:(UserMessModel *)model{

    UserDetailController * detailVC = [[UserDetailController alloc] init];
 
    detailVC.userModel = model;
    
    return detailVC;
}

- (void)viewDidLoad{

    [super viewDidLoad];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return (indexPath.row==0) ? 100*SCREEN_WIDTH_RATIO55 : 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    return [[UITableViewCell alloc] init];
}
@end
