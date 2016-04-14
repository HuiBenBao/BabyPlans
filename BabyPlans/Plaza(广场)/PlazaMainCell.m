//
//  PlazaMainCell.m
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaMainCell.h"

#define BtnCount 4

@interface PlazaMainCell ()

@property (nonatomic,strong) PlazaDataModel * model;

@property (nonatomic,strong) NSIndexPath * indexPath;
@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,weak) UIImageView * iconView;
@property (nonatomic,weak) UILabel * nameLbl;
@property (nonatomic,weak) UILabel * dateLbl;
@property (nonatomic,weak) UIImageView * coverImgView;
@property (nonatomic,weak) UILabel * contentLbl;
@property (nonatomic,weak) UIView * divLine;
@property (nonatomic,weak) UILabel * imgTextLbl;

@property (nonatomic,strong) UIView * bottomView;//评论、点赞、分享、关注等按钮所在的view

@end

@implementation PlazaMainCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{

    static NSString * ident = @"PlazaMainCell";
    PlazaMainCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    
    if (cell == nil) {
        cell = [[PlazaMainCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.indexPath = indexPath;
    cell.tableView = tableView;
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
        
        //底部view
        UIView * bottomV = [[UIView alloc] init];
        
        for (int i = 0; i < BtnCount; i++) {
            
            UIButton * bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            bottomBtn.titleLabel.font = FONT_ADAPTED_NUM(16);
            [bottomBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//            bottomBtn.backgroundColor = [UIColor greenColor];
            
            bottomBtn.tag = i;
            NSString * imgName = [NSString stringWithFormat:@"plaza_bottomview%d",i];
            [bottomBtn setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
            [bottomBtn addTarget:self action:@selector(bottomClick:) forControlEvents:UIControlEventTouchUpInside];
            [bottomV addSubview:bottomBtn];
        }
        
        self.bottomView = bottomV;
        
        [self addSubview:bottomV];
        
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
    [_iconView sd_setImageWithURL:[NSURL URLWithString:self.model.user.icon] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
    _iconView.layer.cornerRadius = _iconView.height/2;
    _iconView.clipsToBounds = YES;
    
    self.nameLbl.frame = self.modelFrame.nameF;
    self.nameLbl.text = (_model.user.nickName) ? _model.user.nickName : _model.user.name;;
    
    self.dateLbl.text = self.model.user.date;
    self.dateLbl.frame = self.modelFrame.dateF;
    
    [self.coverImgView sd_setImageWithURL:[NSURL URLWithString:self.model.coverImg] placeholderImage:[UIImage imageNamed:@"DefaultImage"]];
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
    
    self.bottomView.frame = self.modelFrame.bottomViewF;
    for (UIButton * btn in self.bottomView.subviews) {
        
        CGFloat btnH = self.bottomView.height;
        CGFloat btnW = (KScreenWidth - kMargin*(BtnCount+1))/BtnCount;
        CGFloat btnX = kMargin + (kMargin + btnW)*btn.tag;
        
        btn.frame = CGRectMake(btnX, 0, btnW, btnH);
        
        NSString * title;
        switch (btn.tag) {
            case 0:
                title = _model.likeCount;
                break;
            case 1:
                title = _model.commentCount;
                break;
            case 2:
                title = @"关注";
                break;
            default:
                title = @"分享";
                break;
        }
        [btn setTitle:title forState:UIControlStateNormal];
        
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, kMargin, 0, 0);
        btn.imageEdgeInsets = UIEdgeInsetsMake(0, -kMargin, 0, 0);
        
    }
    
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
/**
 *  底部按钮点击方法
 */
- (void)bottomClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(clickBottomBtn:galleryID:indexPath:tableTag:)]) {
        [self.delegate clickBottomBtn:sender galleryID:_model.galleryID indexPath:self.indexPath tableTag:self.tableView.tag];
    }
}
@end
