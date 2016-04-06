//
//  PlazaDataFrame.h
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlazaDataModel.h"

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
