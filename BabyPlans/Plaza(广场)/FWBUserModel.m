//
//  FWBUserModel.m
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FWBUserModel.h"

@implementation FWBUserModel
+ (instancetype)valueWithDic:(NSDictionary *)dic{

    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{

    if (self = [super init]) {
        
        if (ValidStr(dic[@"name"])) {
            self.name = dic[@"name"];
        }
        
//        if (ValidStr(dic[@"age"])) {
//            self.age = dic[@"age"];
//        }
        
        if (ValidNum(dic[@"id"])) {
            self.userID = dic[@"id"];
        }
        
        if (ValidStr(dic[@"nickName"])) {
            self.nickName = dic[@"nickName"];
        }
        
        if (ValidNum(dic[@"createTime"])) {
            
            long long time = [dic[@"createTime"] longLongValue];
            self.date = [PersonalMethod stringFromUnixTime:time];
            
        }
        
        if (ValidStr(dic[@"gender"])) {
            self.sex = dic[@"gender"];
        }
        
        if (ValidStr(dic[@"avatarSmall"])) {
            self.icon = dic[@"avatarSmall"];
        }
        
    }
    
    return self;
}
@end
