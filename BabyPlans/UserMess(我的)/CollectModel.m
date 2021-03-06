//
//  CollectModel.m
//  BabyPlans
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CollectModel.h"

@implementation CollectModel

+ (instancetype)valueWithDic:(NSDictionary *)dic{
    
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        if (ValidDict(dic[@"user"])) {
            self.user = [FWBUserModel valueWithDic:dic[@"user"]];
        }
        
        if (ValidStr(dic[@"age"])) {
            self.age = dic[@"age"];
        }
        
        if (ValidStr(dic[@"content"])) {
            self.content = dic[@"content"];
        }
        
        if (ValidStr(dic[@"cover"])) {
            self.coverImg = dic[@"cover"];
        }
 
        if (ValidNum(dic[@"pictureCnt"])) {
            self.pictureCount = dic[@"pictureCnt"];
        }
        
        if (ValidNum(dic[@"id"])) {
            self.galleryID = dic[@"id"];
            
        }
        
        if (ValidNum(dic[@"createTime"])) {
            
            long long time = [dic[@"createTime"] longLongValue];
            self.date = [PersonalMethod stringFromUnixTime:time];
        }
        
    }
    
    return self;
}
@end
