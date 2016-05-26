//
//  AttentionAndCollectModel.h
//  BabyPlans
//
//  Created by apple on 16/5/25.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttentionAndCollectModel : NSObject

@property (nonatomic,strong) NSArray * attentionArr;
@property (nonatomic,strong) NSArray * collectArr;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;

@end
