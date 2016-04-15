//
//  UserTableController.m
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserTableController.h"
#import "UserMessCell.h"
#import "Session.h"
#import "LoginViewController.h"



@interface UserTableController ()<LoginDelegate,UserMessCellDelegate>

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,strong) UserMessModel * model;

@end

@implementation UserTableController

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    
   

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    [self model];
    [defaults removeObjectForKey:@"session"];
}

- (void)reloadData{
    
    [CloudLogin getUserMessageWithID:[defaults objectForKey:@"token"] success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        
        int status = [responseObject[@"status"] intValue];
        
        if (status==0) {
            
            if (ValidDict(responseObject[@"user"])) {
                _model = [UserMessModel valueWithDic:responseObject[@"user"]];
                [self.tableView reloadData];
            }
            
        }
    } failure:^(NSError *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
}
- (UserMessModel *)model{

    if (!_model) {
        
        [CloudLogin getUserMessageWithID:[defaults objectForKey:@"token"] success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
            
            int status = [responseObject[@"status"] intValue];
            
            if (status==0) {
                
                if (ValidDict(responseObject[@"user"])) {
                    _model = [UserMessModel valueWithDic:responseObject[@"user"]];
                    [self.tableView reloadData];
                }
                
            }
        } failure:^(NSError *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];

    }
    
    return _model;
}
#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.section == 0 && indexPath.row == 0) {
        return iconCellHeight;
    }
    
    return 45;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return (section == 0) ? 1 : 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserMessCell * cell = [UserMessCell cellWithTableView:tableView indexPath:indexPath];
    
    cell.model = _model;
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (indexPath.section == 1) {
        
        if ([self isLogin]) {
            [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
        }
        
    }
}
#pragma ----mark-----UserMessCellDelegate
- (void)bottomBtnIndex:(NSInteger)index{

    NSLog(@"%ld",index);
}

- (void)goLogin{

    LoginViewController * loginVC = [[LoginViewController alloc] init];
    loginVC.delegate = self;
    
    [self presentViewController:loginVC animated:YES completion:nil];
}
- (void)pushDetailViewWithModel:(UserMessModel *)model{

}
#pragma ---mark-----判断是否登录
- (BOOL)isLogin{

    if (![defaults objectForKey:@"session"]) {//未登录
        
        [self goLogin];
        return NO;
    }else{
        
        return YES;
    }
}
@end
