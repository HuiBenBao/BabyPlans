//
//  Session.h
//  BabyPlans
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

@property (nonatomic,strong) NSString * expireTime;
@property (nonatomic,strong) NSString * loginIP;
@property (nonatomic,strong) NSString * loginTime;
@property (nonatomic,strong) NSString * sessionID;
@property (nonatomic,strong) NSString * userId;

+ (instancetype)shareSession;
- (void)setValueWithDic:(NSDictionary *)dic;
@end
