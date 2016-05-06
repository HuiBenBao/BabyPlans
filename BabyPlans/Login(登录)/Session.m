//
//  Session.m
//  BabyPlans
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "Session.h"

@implementation Session
+ (instancetype)shareSession{

    return [[self alloc] init];
}
- (instancetype)init {
    
    static Session *sharedManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [super init];
    });
    return sharedManager;
}
- (void)setValueWithDic:(NSDictionary *)dic{

    self.expireTime = dic[@"expireTime"];
    self.loginIP = dic[@"loginIP"];

    self.loginTime = dic[@"loginTime"];
    
    self.sessionID = dic[@"session"];
    
    int userid = [dic[@"userId"] intValue];
    self.userId = [NSString stringWithFormat:@"%d",userid];

}
@end
