//
//  CommentFrame.h
//  BabyPlans
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommentModel.h"

#define kMargin 10*SCREEN_WIDTH_RATIO55 //间隔
#define kIconWH (40*SCREEN_WIDTH_RATIO55) //头像宽高
#define kNameFont 14    //姓名字体
#define kDateFont 12  //时间
#define kContentFont 16 //内容字体

@interface CommentFrame : NSObject

@property (nonatomic,assign,readonly) CGRect iconF;
@property (nonatomic,assign,readonly) CGRect nameF;
@property (nonatomic,assign,readonly) CGRect dateF;
@property (nonatomic,assign,readonly) CGRect voiceF; //声音
@property (nonatomic,assign,readonly) CGRect contentF; //文章
@property (nonatomic,assign,readonly) CGRect divLineF;//分割线
@property (nonatomic,strong) CommentModel * model;

@property (nonatomic,assign,readonly) CGFloat cellHeight; //总高度

@end
