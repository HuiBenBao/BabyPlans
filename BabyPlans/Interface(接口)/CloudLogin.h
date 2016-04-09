//
//  CloudLogin.h
//  TCMHealth
//  
//  Created by 12344 on 15/9/18.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CloudLogin : NSObject
/**
 *  获取广场数据
 *
 *  @param type    0：原创绘本 1:经典绘本
 *  @param page    页码
 *  @param count   每页显示的信息条数
 */
+ (void)getPlazaDataWithType:(NSString *)type page:(NSString *)page count:(NSString *)count success:(void(^)(NSDictionary * responseObject))success failure:(void (^)(NSError * errorMessage))failure;
/**
 *  获取图集
 *
 *  @param galleryID 图集id
 */
+ (void)getPictureArrWithGalleryID:(NSString *)galleryID success:(void(^)(NSDictionary * responseObject))success failure:(void (^)(NSError * errorMessage))failure;

/**
 *  获取评论
 *
 *  @param galleryID 图集id
 */
+ (void)getCommentArrWithGalleryID:(NSString *)galleryID Page:(NSString *)page Count:(NSString *)count success:(void(^)(NSDictionary * responseObject))success failure:(void (^)(NSError * errorMessage))failure;

/**
 *  点赞
 *
 *  @param galleryID 图集id
 *  @param type 0/1 true/false
 */
+ (void)likeWithGalleryID:(NSString *)galleryID type:(NSString *)type success:(void(^)(NSDictionary * responseObject))success failure:(void (^)(NSError * errorMessage))failure;

@end
