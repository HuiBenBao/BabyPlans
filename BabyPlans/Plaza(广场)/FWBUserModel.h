//
//  FWBUserModel.h
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWBUserModel : NSObject

@property (nonatomic,strong) NSString * name;
@property (nonatomic,assign) BOOL sex;

//@property (nonatomic,strong) NSString * age;
@property (nonatomic,strong) NSString * userID;
/**
 *  昵称
 */
@property (nonatomic,strong) NSString * nickName;
/**
 *  发布时间
 */
@property (nonatomic,strong) NSString * date;
/**
 *  头像
 */
@property (nonatomic,strong) NSString * icon;

//@property (nonatomic,strong) NSString * <#name#>;


+ (instancetype)valueWithDic:(NSDictionary *)dic;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
