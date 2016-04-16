//
//  UserSettingController.m
//  BabyPlans
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserSettingController.h"
@interface UserSettingController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSArray * titleArr;

@end

@implementation UserSettingController

- (NSArray *)titleArr{
    
    if (!_titleArr) {
        _titleArr = @[@"意见反馈",@"清除缓存",@"关于"];
    }
    return _titleArr;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
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
    if (indexPath.section==0) {
        cell.textLabel.text = _titleArr[indexPath.row];
        cell.textLabel.font = FONT_ADAPTED_NUM(17);
        cell.textLabel.textColor = ColorI(0x3b3b3b);
    }else{
//        cell = [[UITableViewCell alloc] init];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        btn.frame = CGRectMake(0, 0, KScreenWidth, 50);
        cell.textLabel.backgroundColor = [UIColor orangeColor];
        cell.textLabel.text = @"注销";
        [cell addSubview:btn];
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
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
}
@end
