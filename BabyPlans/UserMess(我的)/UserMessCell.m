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
    
    if (indexPath.section == 1) {
        
        static NSString *ID = @"UserMessCell";
        
        UserMessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        cell.indexPath = indexPath;
        
        if (cell == nil) {
            cell = [[UserMessCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            
            
        }

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
        
        
        return cell;
    }else{
        
        static NSString *ID = @"UserMessCellFirst";
        
        UserMessCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
        
        
        cell.indexPath = indexPath;
        
        if (cell == nil) {
            cell = [[UserMessCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
            
        }else{
        
            for (UIView * myView in cell.contentView.subviews) {
                [myView removeFromSuperview];
            }
        }
        
        [cell createTopCell];
        
        return cell;
    }

    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if ([reuseIdentifier isEqualToString:@"UserMessCellFirst"]) {
            self.backgroundColor = [UIColor orangeColor];
        }else{
        
            self.backgroundColor = [UIColor whiteColor];
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.textLabel.textColor = ColorI(0x3b3b3b);
            self.textLabel.font = FONT_ADAPTED_NUM(14);
        }
        
    }
    
    return self;
}

- (void)createTopCell{

    CGFloat iconW = 100*SCREEN_WIDTH_RATIO55;
    CGFloat iconH = 100*SCREEN_WIDTH_RATIO55;
    CGFloat iconX = (KScreenWidth-iconW)/2;
    CGFloat iconY = 0;
    
    UIImageView * iconV = [[UIImageView alloc] initWithFrame:CGRectMake(iconX, iconY, iconW, iconH)];

    iconV.layer.cornerRadius = iconH/2;
    iconV.clipsToBounds = YES;
    
    [iconV sd_setImageWithURL:[NSURL URLWithString:self.model.iconStr] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    
    [iconV addTarget:self action:@selector(iconClick)];
    
    [self.contentView addSubview:iconV];
    
    self.iconView = iconV;
    
    CGRect iconF = self.iconView.frame;
    
    iconF.origin.y = (iconCellHeight - iconF.size.height)/3;
    self.iconView.frame = iconF;

    //已登录时，显示下方三个按钮
    if (self.model) {
        //添加下方三个按钮
        UIView * bottomV = [[UIView alloc] init];
        CGFloat bottomH = 50*SCREEN_WIDTH_RATIO55;
        CGFloat bottomY = iconCellHeight - bottomH;
        
        bottomV.frame = CGRectMake(0, bottomY, KScreenWidth, bottomH);
        
        [self.contentView addSubview:bottomV];
        
        NSArray * titleArr = @[@"发布的绘本",@"关注",@"粉丝"];
        CGFloat lineW = 1;
        for (int i = 0; i < titleArr.count; i ++) {
            
            CGFloat btnW = KScreenWidth / 3 - (titleArr.count-1)*lineW;
            CGFloat btnH = bottomH;
            CGFloat btnX = (btnW+lineW)*i;
            
            for (int j = 0; j < 2; j++) {
                
                CGFloat lblX = btnX;
                CGFloat lblH = btnH/2;
                CGFloat lblY = lblH*j;
                CGFloat lblW = btnW;
                
                UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
                
                lbl.textAlignment = NSTextAlignmentCenter;
                lbl.textColor = ColorI(0xffffff);
                lbl.font = FONT_ADAPTED_NUM(14);
                
                if (j==0) {
                    
                    NSString * text;
                    
                    if (self.model) {
                        switch (i) {
                            case 0:
                                text = _model.galleryCnt;
                                break;
                            case 1:
                                text = _model.friendCount;
                                break;
                            case 2:
                                text = _model.fanCount;
                                break;
                            default:
                                break;
                        }
                    }else{
                        text = @"0";
                    }
                    
                    lbl.text = text;
                }else{
                    
                    lbl.text = titleArr[i];
                }
                
                [bottomV addSubview:lbl];
            }
            
            UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(btnX, 0, btnW, btnH);
            
            button.tag = i;
            [button addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button.backgroundColor = [UIColor clearColor];
            
            [bottomV addSubview:button];
            
            if (i!=(titleArr.count-1)) {
                UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 0, 1, btnH)];
                lineV.backgroundColor = ColorI(0xffffff);
                [bottomV addSubview:lineV];
                
            }
        }

    }else{
    
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect btnF = self.iconView.frame;
        btnF.origin.y = CGRectGetMaxY(self.iconView.frame);
        btnF.size.height = iconCellHeight - btnF.origin.y;
        
        btn.frame = btnF;
        
        [btn setTitle:@"点 击 登 录" forState:UIControlStateNormal];
        btn.titleLabel.font = FontBold(16);
        [btn setTitleColor:ColorI(0xeeeeee) forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:btn];
    }
    
}
/**
 *  头像下方三个按钮的点击事件
 */
- (void)bottomBtnClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(bottomBtnIndex:)]) {
        [self.delegate bottomBtnIndex:sender.tag];
    }
}
/**
 *  点击去登录按钮
 */
- (void)login{

    if ([self.delegate respondsToSelector:@selector(goLogin)]) {
        [self.delegate goLogin];
    }
}
/**
 *  点击头像
 */
- (void)iconClick{

    if (self.model) {
        if ([self.delegate respondsToSelector:@selector(pushDetailViewWithModel:)]) {
            [self.delegate pushDetailViewWithModel:self.model];
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(goLogin)]) {
            [self.delegate goLogin];
        }
    }
   
}

- (void)setModel:(UserMessModel *)model{

    _model = model;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    //分割线
    UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, KScreenWidth, 1)];
    
    lineV.backgroundColor = ColorI(0xdddddd);
    
    [self.contentView addSubview:lineV];
}

@end
