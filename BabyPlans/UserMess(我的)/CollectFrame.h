//
//  CollectFrame.h
//  BabyPlans
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CollectModel.h"

#define kMargin 10*SCREEN_WIDTH_RATIO55 //间隔
#define kIconWH (40*SCREEN_WIDTH_RATIO55) //头像宽高
#define kImageH (400*SCREEN_WIDTH_RATIO55) //图片高度
#define kBottomH (50*SCREEN_WIDTH_RATIO55) //底部view高度
#define kContentFont 16 //内容字体
#define kNameFont 14    //姓名字体
#define kDateFont 12  //时间

@interface CollectFrame : NSObject

@property (nonatomic,assign,readonly) CGRect iconF;
@property (nonatomic,assign,readonly) CGRect nameF;
@property (nonatomic,assign,readonly) CGRect dateF;
@property (nonatomic,assign,readonly) CGRect imageF; //展示图片
@property (nonatomic,assign,readonly) CGRect imageTextF;//图片右下角文字
@property (nonatomic,assign,readonly) CGRect contentF; //文章
@property (nonatomic,assign,readonly) CGRect divLineF;//分割线

@property (nonatomic,strong) CollectModel * model;

@property (nonatomic,assign,readonly) CGFloat cellHeight; //总高度
@end
