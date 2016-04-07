//
//  PlazaDataFrame.m
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaDataFrame.h"




@interface PlazaDataFrame ()



@end
@implementation PlazaDataFrame

- (void)setModel:(PlazaDataModel *)model{
    
    //1、模型赋值
    _model = model;
    
    // 2、计算头像位置
    CGFloat iconX = kMargin;
    CGFloat iconY = kMargin;
    
    _iconF = CGRectMake(iconX, iconY, kIconWH, kIconWH);
    
    //3、姓名
    NSString * nameStr = (_model.user.nickName) ? _model.user.nickName : _model.user.name;
    CGSize nameSize = textSizeFont(nameStr, FONT_ADAPTED_NUM(kNameFont), MAXFLOAT, MAXFLOAT);
    CGFloat nameX = CGRectGetMaxX(_iconF)+kMargin;
    _nameF = CGRectMake(nameX, iconY, nameSize.width, nameSize.height);
    
    //4、时间
    NSString * dateStr = _model.user.date;
    CGSize dateSize = textSizeFont(dateStr, FONT_ADAPTED_NUM(kDateFont), MAXFLOAT, MAXFLOAT);

    CGFloat dateX = CGRectGetMaxX(_iconF)+kMargin;
    CGFloat dateY = CGRectGetMaxY(_iconF) - dateSize.height;
    _dateF = CGRectMake(dateX, dateY, dateSize.width, dateSize.height);
    
    // 5、计算图片和其上面文字的位置
    CGFloat imageX = kMargin;
    CGFloat imageY = CGRectGetMaxY(_iconF) + kMargin;
    CGFloat imageW = KScreenWidth - imageX*2;
    
    _imageF = CGRectMake(imageX, imageY, imageW, kImageH);
    
    //图片数量大于1张时显示
    if ([_model.pictureCount intValue] > 1) {
        CGSize imgTextSize = textSizeFont(@" 30 张", FONT_ADAPTED_NUM(kNameFont), MAXFLOAT, MAXFLOAT)
        CGFloat imgTextX = imageW-imgTextSize.width - kMargin;
        CGFloat imgTextY = kImageH - imgTextSize.height - kMargin;
        _imageTextF = CGRectMake(imgTextX, imgTextY, imgTextSize.width, imgTextSize.height);
    }
    
    
    // 6、计算内容位置
    CGFloat contentX = kMargin;
    CGFloat contentY = iconY;
    
    contentY = CGRectGetMaxY(_imageF) + kMargin;
    
    CGSize contentSize = textSizeFont(model.content, FONT_ADAPTED_WIDTH(kContentFont), imageW, MAXFLOAT);

    _contentF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    
    //分割线
    CGFloat lineY = CGRectGetMaxY(_contentF)+kMargin;
    
    _divLineF = CGRectMake(0, lineY, KScreenWidth, 1);
    
    _cellHeight = CGRectGetMaxY(_divLineF);
}

@end
