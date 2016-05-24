//
//  PersonalMethod.m
//  baby
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 zhang da. All rights reserved.
//

#import "PersonalMethod.h"
#import <sys/utsname.h>

@implementation PersonalMethod

+ (NSString *)getDeviceInfo{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
}

+ (NSString *)stringFromUnixTime:(long long)time {
    NSDateFormatter *f = [[NSDateFormatter alloc] init];
    [f setDateFormat:@"yy-MM-dd HH:mm"];
    
    return [f stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000.0]];
}

+ (BOOL)isPhoneNumWithStr:(NSString *)phoneStr{
    
    phoneStr = [phoneStr trim];
    if (phoneStr.length != 11) {
        return NO;
    }
    
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:phoneStr];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:phoneStr];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:phoneStr];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    }else{
        return NO;
    }

}

+ (NSString *)phoneAddSecretWithStr:(NSString *)str{

    if ([PersonalMethod isPhoneNumWithStr:str]) {
        str = [str stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        
        return str;
    }else{
        
        return str;
    }
}
@end
