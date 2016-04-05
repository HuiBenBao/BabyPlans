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
@end
