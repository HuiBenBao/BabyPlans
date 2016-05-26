//
//  UserAttentionCell.m
//  BabyPlans
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserAttentionCell.h"
#define kMargic 20*SCREEN_WIDTH_RATIO55

@interface UserAttentionCell ()

@property (nonatomic,weak) UIView * divLine;
@property (nonatomic,weak) UIImageView * iconView;
@property (nonatomic,weak) UILabel * nameLbl;


@end

@implementation UserAttentionCell

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    static NSString * ident = @"UserAttentionCell";
    UserAttentionCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    
    if (cell == nil) {
        cell = [[UserAttentionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //头像
        UIImageView * imageView = [[UIImageView alloc] init];
        
        self.iconView = imageView;
        [self.contentView addSubview:imageView];
        
        //昵称
        UILabel * nameLbl = [[UILabel alloc] init];
        nameLbl.textColor = ColorI(0x5b5b5b);
        nameLbl.font = FONT_ADAPTED_NUM(16);
        nameLbl.textAlignment = NSTextAlignmentLeft;
        
        self.nameLbl = nameLbl;
        [self.contentView addSubview:nameLbl];
        
        //分割线
        UIView * lineV = [[UIView alloc] init];
        lineV.backgroundColor = ColorI(0xdddddd);
        self.divLine = lineV;
        
        [self.contentView addSubview:lineV];
        
    }
    return self;
}
- (void)setModel:(FWBUserModel *)model{

    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:[UIImage imageNamed:@"defaultIconImg"]];
    _nameLbl.text = ValidStr(model.nickName) ? model.nickName : model.name;
}
- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGFloat iconX = kMargic;
    CGFloat iconW = self.frame.size.height-iconX*2;
    self.iconView.frame = CGRectMake(kMargic, kMargic, iconW, iconW);
    self.iconView.layer.cornerRadius = iconW/2;
    self.iconView.clipsToBounds = YES;
    
    CGFloat nameX = CGRectGetMaxX(_iconView.frame) + kMargic;
    
    self.nameLbl.frame = CGRectMake(nameX, kMargic, KScreenWidth-kMargic-nameX, iconW);
    self.divLine.frame = CGRectMake(0, self.frame.size.height-1, KScreenWidth, 1);
}
@end
