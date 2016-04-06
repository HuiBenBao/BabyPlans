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
            self.date = dic[@"createTime"];
            
            NSNumber *time = dic[@"createTime"];
            NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:[time integerValue]/1000.0];
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
            dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
            self.date = [dateFormatter stringFromDate:d];
            
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
