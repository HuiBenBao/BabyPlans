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
 *  缩略图（分享用）
 */
@property (nonatomic,strong) NSString * minImg;
/**
 *  图片数量
 */
@property (nonatomic,strong) NSString * pictureCount;
/**
 *  发布时间
 */
@property (nonatomic,strong) NSString * date;
/**
 *  点赞数量
 */
@property (nonatomic,strong) NSString * likeCount;
/**
 *  评论数量
 */
@property (nonatomic,strong) NSString * commentCount;
/**
 *  合在一起的声音（分享时用到）
 */
@property (nonatomic,strong) NSString * galleryBase;
/**
 *  标题(合成后)
 */
@property (nonatomic,strong) NSString * title;
/**
 *  原始标题（分享用）
 */
@property (nonatomic,strong) NSString * oldTitle;
/**
 *  是否收藏
 */
@property (nonatomic,assign) BOOL isCollect;
/**
 *  是否关注
 */
@property (nonatomic,assign) BOOL isAttention;


- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;

@end
