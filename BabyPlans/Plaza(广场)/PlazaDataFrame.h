//
//  PlazaDataFrame.h
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlazaDataModel.h"

#define kMargin 10*SCREEN_WIDTH_RATIO55 //间隔
#define kIconWH (40*SCREEN_WIDTH_RATIO55) //头像宽高
//#define kNameH (16*SCREEN_WIDTH_RATIO55) //姓名高度
#define kImageH (300*SCREEN_WIDTH_RATIO55) //图片高度
#define kContentFont 14 //内容字体

@interface PlazaDataFrame : NSObject

@property (nonatomic,assign,readonly) CGRect iconF;
@property (nonatomic,assign,readonly) CGRect nameF;
@property (nonatomic,assign,readonly) CGRect dateF;
@property (nonatomic,assign,readonly) CGRect imageF;
@property (nonatomic,assign,readonly) CGRect contentF; //文章
@property (nonatomic,assign,readonly) CGRect saveF; //收藏
@property (nonatomic,assign,readonly) CGRect commentF; //评论
@property (nonatomic,assign,readonly) CGRect attenF; //关注
@property (nonatomic,assign,readonly) CGRect shareF; //分享

@property (nonatomic,strong) PlazaDataModel * model;

@property (nonatomic,assign,readonly) CGFloat cellHeight; //总高度

@end
