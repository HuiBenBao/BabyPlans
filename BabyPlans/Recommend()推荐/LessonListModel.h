//
//  LessonListModel.h
//  BabyPlans
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LessonListModel : NSObject

@property (nonatomic,strong) NSString * title;
/**
 *  评论数量
 */
@property (nonatomic,strong) NSString * commentCnt;
/**
 *  主图
 */
@property (nonatomic,strong) NSString * coverImg;
@property (nonatomic,strong) NSString * createTime;

@property (nonatomic,strong) NSString * videoLength;
/**
 *  主视频
 */
@property (nonatomic,strong) NSString * videoMain;
/**
 *  预告片
 */
@property (nonatomic,strong) NSString * videoPreview;

@property (nonatomic,strong) NSString * messID;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;
@end
