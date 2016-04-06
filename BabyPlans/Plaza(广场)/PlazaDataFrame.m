//
//  PlazaDataFrame.m
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaDataFrame.h"

#define kMargin 10*SCREEN_WIDTH_RATIO55 //间隔
#define kIconWH (40*SCREEN_WIDTH_RATIO55) //头像宽高
#define kNameH (12*SCREEN_WIDTH_RATIO55) //姓名高度
#define kImageH (300*SCREEN_WIDTH_RATIO55) //图片高度
#define kContentFont 16 //内容字体


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
    NSString * nameStr = [NSString stringWithFormat:@"%@",_model.user.nickName];
    CGSize nameSize = textSizeFont(nameStr, FONT_ADAPTED_NUM(13), KScreenWidth, 0);
    
    CGFloat nameX = CGRectGetMaxX(_iconF)+kMargin;
    _nameF = CGRectMake(nameX, iconY, nameSize.width, kNameH);
    
    // 3、计算图片位置
    CGFloat imageX = kMargin;
    CGFloat imageY = CGRectGetMaxY(_iconF);
    CGFloat imageW = KScreenWidth - imageX*2;
    
    _imageF = CGRectMake(imageX, imageY, imageW, kImageH);
    
    // 4、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) + kMargin;
    CGFloat contentY = iconY;
    
    contentY = CGRectGetMaxY(_imageF) + kMargin;
    
    CGSize contentSize = textSizeFont(model.content, FONT_ADAPTED_WIDTH(kContentFont), imageW, CGFLOAT_MAX);

    _contentF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
    
    _cellHeight = CGRectGetMaxY(_contentF)+kMargin;
}

@end
