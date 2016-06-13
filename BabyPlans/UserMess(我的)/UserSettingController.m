//
//  UserSettingController.m
//  BabyPlans
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserSettingController.h"
#import "AppAboutViewController.h"
#import "RegisterController.h"
@interface UserSettingController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * titleArr;

@end

@implementation UserSettingController

- (NSArray *)titleArr{
    
    if (!_titleArr) {
        _titleArr = @[@"清除缓存",@"关于",@"修改密码"];
    }
    return _titleArr;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.view addSubview:_tableView];
}

#pragma ----TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return (section==0) ? self.titleArr.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellEditingStyleNone;

    if (indexPath.section==0) {
        cell.textLabel.text = _titleArr[indexPath.row];
        cell.textLabel.font = FONT_ADAPTED_NUM(17);
        cell.textLabel.textColor = ColorI(0x3b3b3b);
        
        //分割线
        [cell.contentView buildBgView:ColorI(0xdddddd) frame:CGRectMake(0, cell.height-1, KScreenWidth, 1)];
    }else{

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor orangeColor];
        
        CGFloat btnX = 30*SCREEN_WIDTH_RATIO55;
        CGFloat btnW = KScreenWidth - btnX*2;
        
        btn.frame = CGRectMake(btnX,0, btnW, cell.frame.size.height);
        btn.layer.cornerRadius = 10*SCREEN_WIDTH_RATIO55;
        btn.clipsToBounds = YES;
        [btn setTitle:@"注销" forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [cell.contentView addSubview:btn];
        
        cell.backgroundColor = [UIColor clearColor];
    }
    
    return cell;
}
- (void)BtnClick:(UIButton *)sender{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"确认注销？"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"注销", nil];
        [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {        
        
        [defaults removeObjectForKey:@"session"];
        [defaults removeObjectForKey:@"token"];
        
        if ([self.delegate respondsToSelector:@selector(loginOutAndReloadSuccess:)]) {
            [self.delegate loginOutAndReloadSuccess:^(BOOL isReload) {
               
                if (isReload) {
                    [self.navigationController popViewControllerAnimated:YES];
                }
            }];
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSInteger row = indexPath.row;
    if (indexPath.section==0) {
   if (row==0){//清除缓存
        
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"重置缓存"
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"重置", nil];
            [sheet showInView:self.view];
            
        }else if (row==1){//关于
            [self.navigationController pushViewController:[[AppAboutViewController alloc] init] animated:YES];
        }else if (row==2){
            [self.navigationController pushViewController:[[RegisterController alloc]init] animated:YES];
        }
    }
}

#pragma mark uiactionsheet delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
        NSString *imgPath = [NSTemporaryDirectory() stringByAppendingString:@"image"];
        if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
            [[NSFileManager defaultManager] removeItemAtPath:imgPath error:nil];
        }
        [[NSFileManager defaultManager] createDirectoryAtPath:imgPath
                                  withIntermediateDirectories:NO
                                                   attributes:nil
                                                        error:nil];
        
        [self.view poptips:@"重置成功"];
    }
}
@end
