//
//  CollectModel.h
//  BabyPlans
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWBUserModel.h"

@interface CollectModel : NSObject

@property (nonatomic,strong) FWBUserModel * user;

@property (nonatomic,strong) NSString * age;
/**
 *  图集ID
 */
@property (nonatomic,strong) NSString * galleryID;
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
/**
 *  发布时间
 */
@property (nonatomic,strong) NSString * date;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;
@end
