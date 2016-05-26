//
//  UserMessCell.h
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserMessModel.h"

#define iconCellHeight 80*SCREEN_WIDTH_RATIO55
#define threeBtnCellHeight  50*SCREEN_WIDTH_RATIO55

@protocol UserMessCellDelegate <NSObject>

@optional
- (void)bottomBtnIndex:(NSInteger)index;

- (void)goLogin;

@end

@interface UserMessCell : UITableViewCell


@property (nonatomic,weak) id <UserMessCellDelegate>delegate;
/**
 *  小红点
 */
@property (nonatomic,strong,readonly) UIView * redView;


+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath*)indexPath Model:(UserMessModel *)model;

@end
