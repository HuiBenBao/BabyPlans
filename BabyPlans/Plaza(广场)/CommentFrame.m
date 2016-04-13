//
//  CommentFrame.m
//  BabyPlans
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CommentFrame.h"

@implementation CommentFrame

- (void)setModel:(CommentModel *)model{
    
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
    NSString * dateStr = _model.createTime;
    CGSize dateSize = textSizeFont(dateStr, FONT_ADAPTED_NUM(kDateFont), MAXFLOAT, MAXFLOAT);
    
    CGFloat dateX = CGRectGetMaxX(_iconF)+kMargin;
    CGFloat dateY = CGRectGetMaxY(_iconF) - dateSize.height;
    _dateF = CGRectMake(dateX, dateY, dateSize.width, dateSize.height);
    
    // 5、计算内容位置
    CGFloat contentY = CGRectGetMaxY(_iconF) + kMargin;
    CGFloat contentX = CGRectGetMaxX(_iconF) + kMargin;

    CGFloat cellMaxY = CGRectGetMaxY(_dateF);
    if (model.voice) {//内容为声音时
        
        CGFloat contentW = 120*SCREEN_WIDTH_RATIO55;
        CGFloat contentH = 30*SCREEN_WIDTH_RATIO55;
        _voiceF = CGRectMake(contentX, contentY, contentW, contentH);
        
        cellMaxY = CGRectGetMaxY(_voiceF) + kMargin;
    }else{
        
        CGFloat contentW = KScreenWidth - contentX - kMargin;

        CGSize contentSize = textSizeFont(model.content, FONT_ADAPTED_WIDTH(kContentFont), contentW, MAXFLOAT);
        
        _contentF = CGRectMake(contentX, contentY, contentSize.width, contentSize.height);
        cellMaxY = CGRectGetMaxY(_contentF) + kMargin;

    }
    
    
    
    
    //分割线
    CGFloat lineY = cellMaxY;
    
    _divLineF = CGRectMake(0, lineY, KScreenWidth, 1);
    
    _cellHeight = CGRectGetMaxY(_divLineF);
}

@end
