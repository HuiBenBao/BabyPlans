//
//  UserGalleryCell.m
//  BabyPlans
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserGalleryCell.h"

static const CGFloat kMargic = 10;

@interface UserGalleryCell ()

@property (nonatomic,weak) UIView * divLine;
@property (nonatomic,weak) UIImageView * iconView;
@property (nonatomic,weak) UILabel * titleLbl;
@property (nonatomic,weak) UILabel * detailLbl;

@property (nonatomic,weak) UILabel * timeLbl;


@end

@implementation UserGalleryCell
+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath{
    
    static NSString * ident = @"UserAttentionCell";
    UserGalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    
    if (cell == nil) {
        cell = [[UserGalleryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        
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
        
        //标题
        UILabel * titleLbl = [[UILabel alloc] init];
        titleLbl.textColor = ColorI(0x5b5b5b);
        titleLbl.font = FONT_ADAPTED_NUM(17);
        titleLbl.textAlignment = NSTextAlignmentLeft;
        
        self.titleLbl = titleLbl;
        [self.contentView addSubview:titleLbl];
        
        //内容摘要
        UILabel * detailLbl = [[UILabel alloc] init];
        detailLbl.textColor = ColorI(0x5b5b5b);
        detailLbl.font = FONT_ADAPTED_NUM(15);
        detailLbl.textAlignment = NSTextAlignmentLeft;
        detailLbl.numberOfLines = 2;
        
        self.detailLbl = detailLbl;
        [self.contentView addSubview:detailLbl];
        
        //时间
        UILabel * timeLbl = [[UILabel alloc] init];
        timeLbl.textColor = ColorI(0x5b5b5b);
        timeLbl.font = FONT_ADAPTED_NUM(16);
        timeLbl.textAlignment = NSTextAlignmentLeft;
        
        self.timeLbl = timeLbl;
        [self.contentView addSubview:timeLbl];
        
        //分割线
        UIView * lineV = [[UIView alloc] init];
        lineV.backgroundColor = ColorI(0xdddddd);
        self.divLine = lineV;
        
        [self.contentView addSubview:lineV];
        
    }
    return self;
}
- (void)setModel:(PlazaDataModel *)model{
    
    _model = model;
    [_iconView sd_setImageWithURL:[NSURL URLWithString:model.minImg] placeholderImage:[UIImage imageNamed:@"defaultIconImg"]];
    _titleLbl.text = model.title;
    _detailLbl.text = model.content;
    _timeLbl.text = model.date;
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat iconX = kMargic;
    CGFloat iconW = self.frame.size.height-iconX*2;
    self.iconView.frame = CGRectMake(kMargic, kMargic, iconW, iconW);
    self.iconView.layer.cornerRadius = 8;
    self.iconView.clipsToBounds = YES;
    
    
    
    CGSize timeSize = textSizeFont(_timeLbl.text, _timeLbl.font, KScreenWidth/3, _timeLbl.font.pointSize*2);
    CGFloat timeX = KScreenWidth - kMargic - timeSize.width;
    self.timeLbl.frame = CGRectMake(timeX, kMargic, timeSize.width, timeSize.height);
    
    CGFloat nameX = CGRectGetMaxX(_iconView.frame) + kMargic;
    
    CGFloat nameW = timeX - kMargic - nameX;
    CGSize titleSize = textSizeFont(_titleLbl.text, _titleLbl.font, KScreenWidth-nameX-kMargic, self.titleLbl.font.pointSize*2)
    
    nameW = (titleSize.width > nameW) ? nameW : titleSize.width;
    
    self.titleLbl.frame = CGRectMake(nameX, kMargic, nameW, titleSize.height);
    
    CGFloat detailY = kMargic+ self.titleLbl.bottom;
    self.detailLbl.frame = CGRectMake(nameX, detailY, KScreenWidth-kMargic-nameX, self.height - kMargic - detailY);
    
    self.divLine.frame = CGRectMake(0, self.frame.size.height-1, KScreenWidth, 1);
}


@end
