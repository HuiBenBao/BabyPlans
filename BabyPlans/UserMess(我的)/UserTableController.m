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
#import "UserSettingController.h"


@interface UserTableController ()<LoginDelegate,UserMessCellDelegate,UserSettingDelegate>

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,strong) UserMessModel * model;

@end

@implementation UserTableController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if ([defaults objectForKey:@"session"]) {//已登录
        
        [self model];
        
    }
    
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStyleDone target:self action:@selector(pushSetting)];
    
    //测试用
//    [defaults removeObjectForKey:@"session"];
}
/**
 *  右侧按钮点击事件
 */
- (void)pushSetting{
    
    UserSettingController * VC = [[UserSettingController alloc] init];
    VC.delegate = self;
    
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma ----mark----UserSettingDelegate
- (void)loginOutAndReloadSuccess:(Reload)success{

    self.model = nil;
    [self.tableView reloadData];
    success(YES);
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
    }else if(indexPath.section==0 && indexPath.row==1){
    
        return threeBtnCellHeight;
    }
    
    return 50*SCREEN_WIDTH_RATIO55;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return (section == 0) ? 2 : 4;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return (section==0)?10:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserMessCell * cell = [UserMessCell cellWithTableView:tableView indexPath:indexPath Model:_model];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self isLogin]) {
    
        if (indexPath.section == 1) {
            
            [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
            
        }
    }
    
    
}
#pragma ----mark-----UserMessCellDelegate
- (void)bottomBtnIndex:(NSInteger)index{

    NSLog(@"%ld",(long)index);
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
