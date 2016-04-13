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
    return [f stringFromDate:[NSDate dateWithTimeIntervalSince1970:time/1000]];
}
@end
