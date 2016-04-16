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

@property (nonatomic,strong) UserMessModel * model;

@end

@implementation UserMessCell



+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
Model:(UserMessModel *)model{
    
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
    }else {
        
        
        UserMessCell *cell = [[UserMessCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        
        
        cell.indexPath = indexPath;
        cell.model = model;
        
        if (indexPath.row == 0) {
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            cell.backgroundColor = [UIColor whiteColor];
            
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.iconStr] placeholderImage:[UIImage imageAutomaticName:@"defaultIconImg"]];
            
            cell.imageView.layer.cornerRadius = 10;
            cell.imageView.clipsToBounds = YES;
            
            cell.textLabel.font = FONT_ADAPTED_NUM(15);
            cell.textLabel.textColor = ColorI(0x5b5b5b);
            if (model) {
                cell.textLabel.text = model.name;
            }else{
                cell.textLabel.text = @"请登录";
            }
            
        }else{
            [cell createThreeBtn];
        }
        
        return cell;
    }

    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        if ([reuseIdentifier isEqualToString:@"UserMessCell"]) {
            
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

            self.backgroundColor = [UIColor whiteColor];
            self.textLabel.textColor = ColorI(0x3b3b3b);
            self.textLabel.font = FONT_ADAPTED_NUM(14);
        }
        
    }
    
    return self;
}

- (void)createThreeBtn{
    
    //添加下方三个按钮
    
    NSArray * titleArr = @[@"发布的绘本",@"关注",@"粉丝"];
    CGFloat lineW = 1;
    for (int i = 0; i < titleArr.count; i ++) {
        
        CGFloat btnW = KScreenWidth / 3 - (titleArr.count-1)*lineW;
        CGFloat btnH = threeBtnCellHeight;
        CGFloat btnX = (btnW+lineW)*i;
        
        for (int j = 0; j < 2; j++) {
            
            CGFloat margicY = 5*SCREEN_WIDTH_RATIO55;
            CGFloat lblX = btnX;
            CGFloat lblH = btnH/2 - margicY;
            CGFloat lblY = margicY + lblH*j;
            CGFloat lblW = btnW;
            
            UILabel * lbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblW, lblH)];
            
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.textColor = ColorI(0x5b5b5b);
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
            
            [self.contentView addSubview:lbl];
        }
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(btnX, 0, btnW, btnH);
        
        button.tag = i;
        [button addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        button.backgroundColor = [UIColor clearColor];
        
        [self addSubview:button];
        
        if (i!=(titleArr.count-1)) {
            UIView * lineV = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(button.frame), 0, 1, btnH)];
            lineV.backgroundColor = ColorI(0xdddddd);
            [self.contentView addSubview:lineV];
            
        }
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
    
    lineV.backgroundColor = ColorI(0xeeeeee);
    
    [self.contentView addSubview:lineV];
    
    CGRect imgF = self.imageView.frame;
    imgF.size.height = self.height*2/3;
    imgF.size.width = imgF.size.height;
    
    CGPoint imgPoint = self.imageView.center;
    imgPoint.y = self.height/2;
    
    self.imageView.frame = imgF;
    self.imageView.center = imgPoint;
    
    self.imageView.layer.cornerRadius = imgF.size.height/2;
    self.imageView.clipsToBounds = YES;
}

@end
