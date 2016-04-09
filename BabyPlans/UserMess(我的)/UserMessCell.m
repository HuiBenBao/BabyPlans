//
//  UserMessCell.m
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserMessCell.h"

@interface UserMessCell ()

@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,weak) UIImageView * iconView;


@end

@implementation UserMessCell



+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"UserMessCell";
    UserMessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    
    if (cell == nil) {
        cell = [[UserMessCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    if (indexPath.section == 1) {
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = ColorI(0x3b3b3b);
        cell.textLabel.font = FONT_ADAPTED_NUM(14);
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text = @"我的二维码";
                break;
            case 1:
                cell.textLabel.text = @"消息";
                break;
            case 2:
                cell.textLabel.text = @"我的收藏";
                break;
            case 3:
                cell.textLabel.text = @"扫码加好友";
                break;
            default:
                break;
        }
    }else{
        [cell createTopCell];
    }

    return cell;
}

- (void)createTopCell{

    UIImageView * iconV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DefaultImage"]];
    CGFloat iconW = 100*SCREEN_WIDTH_RATIO55;
    CGFloat iconH = 100*SCREEN_WIDTH_RATIO55;
    CGFloat iconX = (KScreenWidth-iconW)/2;
    CGFloat iconY = 0;
    
    iconV.frame = CGRectMake(iconX, iconY, iconW, iconH);
    iconV.layer.cornerRadius = iconH/2;
    iconV.clipsToBounds = YES;
    
    [self.contentView addSubview:iconV];
    
    self.iconView = iconV;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    //分割线
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, KScreenWidth, 1)];
    
    lineV.backgroundColor = ColorI(0xdddddd);
    
    [self.contentView addSubview:lineV];
    
    
    if (self.iconView) {
       
        CGRect iconF = self.iconView.frame;
        
        iconF.origin.y = (self.frame.size.height - iconF.size.height)/2;
        self.iconView.frame = iconF;
        
    }
}

@end
