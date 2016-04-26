//
//  UserMessController.m
//  BabyPlans
//
//  Created by apple on 16/4/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserMessController.h"
#import "SystemMessController.h"

#define CellHeight 50

@interface UserMessController ()

@property (nonatomic,strong) NSArray * titleArr;


@end

@implementation UserMessController

- (NSArray *)titleArr{

    if (!_titleArr) {
        _titleArr = @[@"系统消息"];
    }
    return _titleArr;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.title = @"消息";
    self.view.backgroundColor = ViewBackColor;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return CellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * identFier = @"UserMessCell";
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identFier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identFier];
        
        [cell.contentView buildBgView:ColorI(0xdddddd) frame:CGRectMake(0, CellHeight-1, KScreenWidth, 1)];
    }
    
    cell.textLabel.text = [self.titleArr objectAtIndex:indexPath.row];
    cell.textLabel.textColor = ColorI(0x3b3b3b);
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [self.navigationController pushViewController:[[SystemMessController alloc] init] animated:YES];
}
@end
