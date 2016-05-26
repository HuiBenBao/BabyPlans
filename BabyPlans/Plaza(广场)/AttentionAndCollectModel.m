//
//  AttentionAndCollectModel.m
//  BabyPlans
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AttentionAndCollectModel.h"

@implementation AttentionAndCollectModel

+ (instancetype)valueWithDic:(NSDictionary *)dic{
    
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        if (ValidArray(dic[@"attentionList"])) {
            self.attentionArr = dic[@"attentionList"];
        }
        
        if (ValidArray(dic[@"collectionList"])) {
            self.collectArr = dic[@"collectionList"];
        }
    }
    
    return self;
}

@end
