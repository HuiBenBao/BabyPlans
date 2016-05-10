//
//  CommentModel.h
//  BabyPlans
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWBUserModel.h"


@interface CommentModel : NSObject

@property (nonatomic,strong) FWBUserModel * user;

/**
 *  评论ID
 */
@property (nonatomic,strong) NSString * commentID;
/**
 *  声音
 */
@property (nonatomic,strong) NSString * voice;
/**
 *  声音长度
 */
@property (nonatomic,strong) NSString * voiceLen;

/**
 *  时间
 */
@property (nonatomic,strong) NSString * createTime;
/**
 *  评论文字
 */
@property (nonatomic,strong) NSString * content;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;


@end
