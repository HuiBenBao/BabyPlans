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
#import "UserDetailController.h"
#import "UserMessController.h"
#import "TwoCodeController.h"
#import "ZCZBarViewController.h"

@interface UserTableController ()<LoginDelegate,UserMessCellDelegate,UserSettingDelegate,UserDetailControllerDelegate>

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
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{

    UIView * footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    
    return footer;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserMessCell * cell = [UserMessCell cellWithTableView:tableView indexPath:indexPath Model:_model];
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self isLogin]) {
    
        if (indexPath.section == 1) {
            
            NSInteger row = indexPath.row;
            
            UIViewController * VC;
            if (row==0) {//二维码

                VC = [[TwoCodeController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];

            }else if (row==1){//消息
                VC = [[UserMessController alloc] init];
                [self.navigationController pushViewController:VC animated:YES];

            }else if (row==2){
            
            }else{
            
                //扫描二维码
                ZCZBarViewController*vc=[[ZCZBarViewController alloc]initWithBlock:^(NSString *str, BOOL isSucceed) {
                    
                    if (isSucceed) {
                        
                        [CloudLogin getUserMessageWithID:str success:^(NSDictionary *responseObject) {
                            
                            int status = [responseObject[@"status"] intValue];
                            NSLog(@"%@",responseObject);
                            
                            if (status == 0) {
                                
                                
                                [CloudLogin attentionToUserID:str type:nil success:^(NSDictionary *responseObject) {
                                    NSLog(@"%@",responseObject);
                                    
                                    int status = [responseObject[@"status"] intValue];
                                    if (status == 0) {
                                        
                                        int following = [responseObject[@"following"] intValue];
                                        
                                        following = (following==0) ? 1 : 0;
                                        
                                        [CloudLogin attentionToUserID:str type:[NSString stringWithFormat:@"%d",following] success:^(NSDictionary *responseObject) {
                                            int reslut = [responseObject[@"status"] intValue];
                                            NSLog(@"------%@",responseObject);
                                            if (reslut==0) {
                                                
                                                NSString * mess = (following == 0) ? @"关注成功" : @"已取消";
//                                                [self.view poptips:mess];
                                                
                                                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:mess preferredStyle:UIAlertControllerStyleAlert];
                                                
                                                UIAlertAction * cancelBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                                    
                                                    
                                                }];
                                                
                                                [alertVC addAction:cancelBtn];
                                                [self presentViewController:alertVC animated:YES completion:nil];
                                            }
                                        } failure:nil];

                                        
                                    }
                                    
                                    
                                    
                                    
                                } failure:^(NSError *errorMessage) {
                                    
                                }];
                                
                            }else{
                            
                                UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"查询不到此用记，请确认后再扫描" preferredStyle:UIAlertControllerStyleAlert];
                                
                                UIAlertAction * cancelBtn = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                                    
                                }];
                                
                                [alertVC addAction:cancelBtn];
                                
                                [vc presentViewController:alertVC animated:YES completion:nil];

                            }
                        } failure:^(NSError *errorMessage) {
                           
                            [self.view poptips:@"网络异常"];
                        }];
                        
                    }else{
                        
                    }
                }];
                
                [self presentViewController:vc animated:YES completion:nil];
            }
            
            
        }else if(indexPath.section==0){
        
            if (indexPath.row==0) {
                
                UserDetailController * VC = [UserDetailController userDetailWithModel:_model];
                VC.delegate = self;
                
                [self.navigationController pushViewController:VC animated:YES];

            }
        }
    }
    
    
}

#pragma ----mark-----UserDetailControllerDelegate
- (void)updateUserMess{

    self.model = nil;
    [self model];
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
