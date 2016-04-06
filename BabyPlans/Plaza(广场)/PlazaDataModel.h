//
//  PlazaDataModel.h
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWBUserModel.h"

@interface PlazaDataModel : NSObject

@property (nonatomic,strong) FWBUserModel * user;

@property (nonatomic,strong) NSString * age;
@property (nonatomic,strong) NSString * articleID;
/**
 *  内容
 */
@property (nonatomic,strong) NSString * content;
/**
 *  首张图片
 */
@property (nonatomic,strong) NSString * coverImg;

/**
 *  图片数量
 */
@property (nonatomic,strong) NSString * pictureCount;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;

@end
