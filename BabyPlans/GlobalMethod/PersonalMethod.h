//
//  PersonalMethod.h
//  baby
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 zhang da. All rights reserved.
//



#import <Foundation/Foundation.h>

@interface PersonalMethod : NSObject
/**
 *  获取设备型号
 */
+ (NSString *)getDeviceInfo;
/**
 *  将毫秒转化为时间
 */
+ (NSString *)stringFromUnixTime:(long long)time;
@end
