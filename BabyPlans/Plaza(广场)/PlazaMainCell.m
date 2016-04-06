//
//  PlazaMainCell.m
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaMainCell.h"

@interface PlazaMainCell ()

@property (nonatomic,strong) PlazaDataModel * model;

@property (nonatomic,weak) UIImageView * iconView;
@property (nonatomic,weak) UILabel * nameLbl;
@property (nonatomic,weak) UILabel * dateLbl;
@property (nonatomic,weak) UIImageView * coverImgView;
@property (nonatomic,weak) UILabel * contentLbl;


@end

@implementation PlazaMainCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString * ident = @"PlazaMainCell";
    PlazaMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        cell = [[PlazaMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
    }
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        //头像
        UIImageView * imageView = [[UIImageView alloc] init];
        
        self.iconView = imageView;
        [self addSubview:imageView];
        
        //昵称
        UILabel * nameLbl = [[UILabel alloc] init];
        nameLbl.textColor = ColorI(0x5b5b5b);
        nameLbl.font = FONT_ADAPTED_NUM(kContentFont);
        
        self.nameLbl = nameLbl;
        
        [self addSubview:nameLbl];
        
        
    }
    return self;
}
- (void)setModelFrame:(PlazaDataFrame *)modelFrame{

    _modelFrame = modelFrame;
    self.model = modelFrame.model;

}

- (void)layoutSubviews{

    self.iconView.frame = self.modelFrame.iconF;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:self.model.user.icon] placeholderImage:[UIImage imageNamed:@"allowDel"]];
    _iconView.layer.cornerRadius = _iconView.height/2;
    _iconView.clipsToBounds = YES;
    
    self.nameLbl.frame = self.modelFrame.nameF;
    self.nameLbl.text = self.model.user.nickName;
    
}
@end
