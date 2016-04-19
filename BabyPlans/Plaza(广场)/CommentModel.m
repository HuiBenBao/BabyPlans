//
//  CommentModel.m
//  BabyPlans
//
//  Created by apple on 16/4/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
+ (instancetype)valueWithDic:(NSDictionary *)dic{

    return [[self alloc] initWithDic:dic];
}
- (instancetype)initWithDic:(NSDictionary *)dic{

    if (self = [super init]) {
        if (ValidNum(dic[@"createTime"])) {
            long long time = [dic[@"createTime"] longLongValue];

            self.createTime = [PersonalMethod stringFromUnixTime:time];
            
        }
        
        if (ValidDict(dic[@"user"])) {
            self.user = [FWBUserModel valueWithDic:dic[@"user"]];
        }
        
        if (ValidNum(dic[@"id"])) {
            
            self.commentID = [dic[@"id"] stringValue];
        }
        
        if (ValidNum(dic[@"voiceLength"])) {
            self.voiceLen = [dic[@"voiceLength"] stringValue];
        }
        
        if (ValidStr(dic[@"voice"])) {
            self.voice = dic[@"voice"];
        }
        
        if (ValidStr(dic[@"content"])) {
            self.content = dic[@"content"];
        }

    }
    
    return self;
}
@end
