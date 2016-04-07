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
@property (nonatomic,weak) UIView * divLine;
@property (nonatomic,weak) UILabel * imgTextLbl;


@end

@implementation PlazaMainCell
+ (instancetype)cellWithTableView:(UITableView *)tableView{

    static NSString * ident = @"PlazaMainCell";
    PlazaMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (cell == nil) {
        cell = [[PlazaMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
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
        nameLbl.font = FONT_ADAPTED_NUM(kNameFont);
        
        self.nameLbl = nameLbl;
        
        [self addSubview:nameLbl];
        
        //时间
        UILabel * dateLbl = [[UILabel alloc] init];
        dateLbl.font = FONT_ADAPTED_NUM(kDateFont);
        dateLbl.textColor = ColorI(0x8b8b8b);
        
        self.dateLbl = dateLbl;
        [self addSubview:dateLbl];
        
        //图片
        UIImageView * imageV = [[UIImageView alloc] init];
        self.coverImgView = imageV;
        
        [self addSubview:imageV];
        
        //图片上文字
        UILabel * imgTextLbl = [[UILabel alloc] init];
        imgTextLbl.textColor = ColorI(0xffffff);
        imgTextLbl.font = FONT_ADAPTED_NUM(kNameFont);
        imgTextLbl.backgroundColor = [UIColor blackColor];
        imgTextLbl.alpha = 0.5;
        
        self.imgTextLbl = imgTextLbl;
        [imageV addSubview:imgTextLbl];
        
        //内容
        UILabel * contentLbl = [[UILabel alloc] init];
        contentLbl.font = FONT_ADAPTED_NUM(kContentFont);
        contentLbl.textColor = ColorI(0x3b3b3b);
        contentLbl.textAlignment = NSTextAlignmentLeft;
        contentLbl.numberOfLines = 0;
        
        self.contentLbl = contentLbl;
        [self addSubview:contentLbl];
        
        //分割线
        UIView * lineV = [[UIView alloc] init];
        lineV.backgroundColor = ColorI(0xdddddd);
        self.divLine = lineV;
        
        [self addSubview:lineV];
        
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
    self.nameLbl.text = (_model.user.nickName) ? _model.user.nickName : _model.user.name;;
    
    self.dateLbl.text = self.model.user.date;
    self.dateLbl.frame = self.modelFrame.dateF;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"allowDel"]];
    self.coverImgView.layer.cornerRadius = 8*SCREEN_WIDTH_RATIO55;
    self.coverImgView.clipsToBounds = YES;
    
    self.coverImgView.frame = self.modelFrame.imageF;
    
    //图片添加点击事件
    [self.coverImgView addTarget:self action:@selector(coverImgClick:)];
    
    if([self.model.pictureCount intValue] > 1){
        
        self.imgTextLbl.frame = self.modelFrame.imageTextF;
        self.imgTextLbl.layer.cornerRadius = 3;
        self.imgTextLbl.clipsToBounds = YES;
        self.imgTextLbl.text = [NSString stringWithFormat:@" %@ 张",self.model.pictureCount];

    }
    
    self.contentLbl.text = self.model.content;
    self.contentLbl.frame = self.modelFrame.contentF;
    
    self.divLine.frame = self.modelFrame.divLineF;
}
/**
 *  图片点击方法
 */
- (void)coverImgClick:(id)sender{
    
    if ([self.delegate respondsToSelector:@selector(getImageArrWithID:)]) {
        [self.delegate getImageArrWithID:_model.galleryID];
    }
}
@end
