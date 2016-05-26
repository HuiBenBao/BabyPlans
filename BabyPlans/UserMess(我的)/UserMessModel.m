//
//  UserMessModel.m
//  BabyPlans
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UserMessModel.h"

@implementation UserMessModel

+ (instancetype)valueWithDic:(NSDictionary *)dic{

    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{

    if (self = [super init]) {
        
        if (ValidStr(dic[@"name"])) {
            self.name = dic[@"name"];
        }
        
        if (ValidStr(dic[@"nickName"])) {
            self.nickName = dic[@"nickName"];
        }
        
        if (ValidNum(dic[@"friendCnt"])) {
            int count = [dic[@"friendCnt"] intValue];
            self.friendCount = [NSString stringWithFormat:@"%d",count];
            
        }
        
        if (ValidNum(dic[@"id"])) {
            int count = [dic[@"id"] intValue];
            self.userID = [NSString stringWithFormat:@"%d",count];
            
        }
        
        if (ValidNum(dic[@"systemMessage"])) {
            int count = [dic[@"systemMessage"] intValue];
            self.systemMess = [NSString stringWithFormat:@"%d",count];
        }
        
        if (ValidNum(dic[@"fanCnt"])) {
            int count = [dic[@"fanCnt"] intValue];
            self.fanCount = [NSString stringWithFormat:@"%d",count];
        }
        if (ValidNum(dic[@"friendMessage"])) {
            int count = [dic[@"friendMessage"] intValue];
            self.friendMessage = [NSString stringWithFormat:@"%d",count];
        }
        
        if (ValidNum(dic[@"commentMessage"])) {
            int count = [dic[@"commentMessage"] intValue];
            self.commentMess = [NSString stringWithFormat:@"%d",count];
        }
        
        if (ValidNum(dic[@"galleryCnt"])) {
            int count = [dic[@"galleryCnt"] intValue];
            self.galleryCnt = [NSString stringWithFormat:@"%d",count];
        }
        
        if (ValidStr(dic[@"avatarBig"])) {
            self.iconStr = dic[@"avatarBig"];
        }
    }
    
    return self;
}

@end
