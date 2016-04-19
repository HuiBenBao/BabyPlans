//
//  UserDetailController.m
//  BabyPlans
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserDetailController.h"

#define iconCellHeight 120*SCREEN_WIDTH_RATIO55
#define generalCellHeight 60*SCREEN_WIDTH_RATIO55

@interface UserDetailController ()

@property (nonatomic,strong) UserMessModel * userModel;

@property (nonatomic,weak) UIImageView * iconView;

@end

@implementation UserDetailController
+ (instancetype)userDetailWithModel:(UserMessModel *)model{

    UserDetailController * detailVC = [[UserDetailController alloc] init];
 
    detailVC.userModel = model;
    
    return detailVC;
}

- (void)viewDidLoad{

    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return (indexPath.row==0) ?  iconCellHeight: generalCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * ident = @"UserDetailCell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ident];
    }
    
    CGFloat cellHeight = generalCellHeight;
    if (indexPath.row==0) {
        
        cell.textLabel.text = @"头像";
        
        cellHeight = iconCellHeight;
        
        CGFloat imgY = 10*SCREEN_WIDTH_RATIO55;
        CGFloat imgH = iconCellHeight - imgY*2;
        CGFloat imgW = imgH;
        
        UIImageView * imageV = [[UIImageView alloc] initWithFrame:CGRectMake(iconCellHeight, imgY, imgW, imgH)];
        [imageV sd_setImageWithURL:[NSURL URLWithString:self.userModel.iconStr] placeholderImage:[UIImage imageNamed:@"defaultIconImg"]];
        
        imageV.layer.cornerRadius = imgH/2;
        imageV.clipsToBounds = YES;
        [imageV addTarget:self action:@selector(iconClick)];
        
        self.iconView = imageV;
        
        [cell.contentView addSubview:imageV];
        
    }else{
        switch (indexPath.row) {
            case 1:
                cell.textLabel.text = @"昵称";
                break;
                
            default:
                break;
        }
    }
    
    //分割线
    [cell.contentView buildBgView:ColorI(0xdddddd) frame:CGRectMake(0, cellHeight-1, KScreenWidth, 1)];
    
    return cell;
}
/**
 *  图像点击方法
 */
- (void)iconClick{
    
    
}
@end
