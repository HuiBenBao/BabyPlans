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
    NSString * nameStr = [NSString stringWithFormat:@"%@",_model.user.nickName];
    CGSize nameSize = textSizeFont(nameStr, FONT_ADAPTED_NUM(kContentFont), MAXFLOAT, MAXFLOAT);
    NSLog(@"name ==%@",nameStr);
    CGFloat nameX = CGRectGetMaxX(_iconF)+kMargin;
    _nameF = CGRectMake(nameX, iconY, nameSize.width, nameSize.height);
    
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
