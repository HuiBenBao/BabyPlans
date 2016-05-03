//
//  PlazaDataModel.m
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PlazaDataModel.h"

@implementation PlazaDataModel
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
        if (ValidStr(dic[@"avatarSmall"])) {
            self.minImg = dic[@"avatarSmall"];
        }
        if (ValidNum(dic[@"pictureCnt"])) {
            self.pictureCount = dic[@"pictureCnt"];
        }
        
        if (ValidNum(dic[@"id"])) {
            self.galleryID = dic[@"id"];
            
        }
        
        if (ValidNum(dic[@"likeCnt"])) {
            NSNumber * like = dic[@"likeCnt"];
            NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
            self.likeCount = [numberFormatter stringFromNumber:like];
            
        }
        
        if (ValidNum(dic[@"createTime"])) {
            
            long long time = [dic[@"createTime"] longLongValue];
            self.date = [PersonalMethod stringFromUnixTime:time];
            
        }
        
        if (ValidNum(dic[@"commentCnt"])) {
            self.commentCount = [[[NSNumberFormatter alloc] init] stringFromNumber:dic[@"commentCnt"]];
            
        }
        
        if (ValidStr(dic[@"galleryBase"])) {
            self.galleryBase = dic[@"galleryBase"];
        }
    }
    
    return self;
}
@end
