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
+ (void)getCodeWithPhoneNum:(NSString *)phoneNum type:(NSString *)type success:(Success)success failure:(Failure)failure;
/**
 *  登录
 *
 *  @param phoneNum 手机号
 *  @param password 密码
 */
+ (void)loginWithPhoneNum:(NSString *)phoneNum password:(NSString *)password success:(Success)success failure:(Failure)failure;

/**
 *  第三方登录
 *
 *  @param phoneNum 手机号
 *  @param password 密码
 *  @param openid 第三方登录返回参数
 */
+ (void)shareLoginWithPhoneNum:(NSString *)phoneNum openid:(NSString*)openid success:(Success)success failure:(Failure)failure;

/**
 *  注册 or 修改密码
 *
 *  @param phoneNum 手机号
 *  @param password 密码
 *  @param code 验证码
 *  @param type 0:修改密码 1：注册
 */
+ (void)registerWithPhoneNum:(NSString *)phoneNum password:(NSString *)password code:(NSString *)code type:(NSInteger)type success:(Success)success failure:(Failure)failure;

/**
 *  获取广场数据
 *
 *  @param type    0：原创绘本 1:经典绘本
 *  @param page    页码
 *  @param count   每页显示的信息条数
 *  @param userID  要查询此用户的图集时使用
 */
+ (void)getPlazaDataWithType:(NSString *)type page:(NSString *)page count:(NSString *)count userID:(NSString *)userID success:(Success)success failure:(Failure)failure;
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

/**
 *  查看用户资料
 */
+ (void)getUserMessageWithID:(NSString *)userID success:(Success)success failure:(Failure)failure;

/**
 *  查看课程
 *  @param count 每页显示个数
 *  @param page 显示页数（从1开始）
 */
+ (void)getLessonCount:(NSString *)count Page:(NSString *)page Success:(Success)success failure:(Failure)failure;
/**
 *  上传图片和声音
 *
 *  @param image    图片
 *  @param voiceLen 声音长度
 */
+ (void)updatePictureWithImage:(UIImage *)image voiceLength:(NSString *)voiceLen uccess:(Success)success failure:(Failure)failure;
/**
 *  发布
 *
 *  @param content  内容
 *  @param imgIDArr 图片id数组
 */
+ (void)publishContent:(NSString *)content title:(NSString *)title type:(NSString *)type ImgIDArr:(NSArray *)imgIDArr Success:(Success)success failure:(Failure)failure;
/**
 *  修改用户信息
 *
 *  @param icon     头像
 *  @param name     昵称
 *  @param birthday 生日
 *  @param sex      性别
 */
+ (void)changeIcon:(UIImage *)icon nikeName:(NSString *)name birthday:(NSString *)birthday sex:(NSString *)sex Success:(Success)success failure:(Failure)failure;
/**
 *  意见反馈
 *
 *  @param content 反馈内容
 */
+ (void)SuggestWithContent:(NSString *)content Success:(Success)success failure:(Failure)failure;
/**
 *  获取系统反馈消息
 */
+ (void)SystemMessSuccess:(Success)success failure:(Failure)failure;
/**
 *  获取用户收藏
 *
 *  @param page    页数
 *  @param count   每页个数
 */
+ (void)UserCollectWihtPage:(NSString *)page count:(NSString *)count Success:(Success)success failure:(Failure)failure;

/**
 *  获取用户关注
 *
 *  @param page    页数
 *  @param count   每页个数
 */
+ (void)UserAttentionWihtPage:(NSString *)page count:(NSString *)count Success:(Success)success failure:(Failure)failure;
/**
 *  获取用户关注
 *
 *  @param page    页数
 *  @param count   每页个数
 */
+ (void)UserFansWihtPage:(NSString *)page count:(NSString *)count Success:(Success)success failure:(Failure)failure;
/**
 *  获取未读消息数目
 */
+ (void)GetUnreadMessCountSuccess:(Success)success failure:(Failure)failure;
@end
