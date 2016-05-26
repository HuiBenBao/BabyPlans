//
//  UserMessModel.h
//  BabyPlans
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserMessModel : NSObject

@property (nonatomic,strong) NSString * name;
/**
 *  粉丝
 */
@property (nonatomic,strong) NSString * fanCount;

@property (nonatomic,strong) NSString * userID;

@property (nonatomic,strong) NSString * systemMess;
/**
 *  关注
 */
@property (nonatomic,strong) NSString * friendCount;

@property (nonatomic,strong) NSString * friendMessage;

@property (nonatomic,strong) NSString * commentMess;
/**
 *  绘本数量
 */
@property (nonatomic,strong) NSString * galleryCnt;

@property (nonatomic,strong) NSString * iconStr;
/**
 *  昵称
 */
@property (nonatomic, strong) NSString * nickName;



- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;

@end
