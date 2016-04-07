//
//  PictureModel.m
//  BabyPlans
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel
+ (instancetype)valueWithDic:(NSDictionary *)dic{
    
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        if (ValidNum(dic[@"id"])) {
            self.pictureID = dic[@"id"];
        }
        
        if (ValidStr(dic[@"imageBig"])) {
            self.image = dic[@"imageBig"];
        }
        
        if (ValidStr(dic[@"voice"])) {
            self.voice = dic[@"voice"];
        }
        
        if (ValidNum(dic[@"voiceLength"])) {
            self.voiceLength = dic[@"voiceLength"];
        }
    }
    
    return self;
}
@end
