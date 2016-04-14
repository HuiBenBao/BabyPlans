//
//  CloudLogin.h
//  TCMHealth
//  
//  Created by 12344 on 15/9/18.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^Success)(NSDictionary * responseObject);
typedef void (^Failure)(NSError * errorMessage);

@interface CloudLogin : NSObject
/**
 *  获取验证码
 *
 *  @param phoneNum 手机号
 */
+ (void)getCodeWithPhoneNum:(NSString *)phoneNum success:(Success)success failure:(Failure)failure;
/**
 *  登录
 *
 *  @param phoneNum 手机号
 *  @param password 密码
 */
+ (void)loginWithPhoneNum:(NSString *)phoneNum password:(NSString *)password success:(Success)success failure:(Failure)failure;
/**
 *  获取广场数据
 *
 *  @param type    0：原创绘本 1:经典绘本
 *  @param page    页码
 *  @param count   每页显示的信息条数
 */
+ (void)getPlazaDataWithType:(NSString *)type page:(NSString *)page count:(NSString *)count success:(Success)success failure:(Failure)failure;
/**
 *  获取图集
 *
 *  @param galleryID 图集id
 */
+ (void)getPictureArrWithGalleryID:(NSString *)galleryID success:(Success)success failure:(Failure)failure;

/**
 *  获取评论
 *
 *  @param galleryID 图集id
 */
+ (void)getCommentArrWithGalleryID:(NSString *)galleryID Page:(NSString *)page Count:(NSString *)count success:(void(^)(NSDictionary * responseObject))success failure:(void (^)(NSError * errorMessage))failure;
/**
 *  上传评论
 *
 *  @param galleryID 图集id
 *  @param replyTo   回复给某人的id
 *  @param voice     声音
 *  @param voiceLen  声音长度
 *  @param content   评论文字内容
 */
+ (void)pushCommentWithWithGalleryID:(NSString *)galleryID replyTo:(NSString *)replyTo voice:(NSString *)voice voiceLen:(NSString *)voiceLen content:(NSString *)content success:(Success)success failure:(Failure)failure;
/**
 *  点赞
 *
 *  @param galleryID 图集id
 *  @param type 0/1 true/false
 */
+ (void)likeWithGalleryID:(NSString *)galleryID type:(NSString *)type success:(Success)success failure:(Failure)failure;

/**
 *  关注
 *
 *  @param userID 被关注者的id
 *  @param type 0/1 true/false
 */
+ (void)attentionToUserID:(NSString *)userID type:(NSString *)type success:(Success)success failure:(Failure)failure;

@end
