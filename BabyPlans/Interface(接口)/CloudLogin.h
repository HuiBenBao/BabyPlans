//
//  CloudLogin.h
//  TCMHealth
//  
//  Created by 12344 on 15/9/18.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface CloudLogin : NSObject

/**
 *  验证码获取方法
 *
 *  @param phoneNum 手机号
 *  @param success  请求成功时调用
 *  @param failure  失败时调用
 */
+ (void)getCodeWithPhoneNum:(NSString *)phoneNum type:(NSString *)type success:(void (^)(NSDictionary * responseDic))success
                    failure:(void (^)(NSError * errorMessage))failure;
/**
 *  登陆接口调用
 *
 *  @param phone    手机号
 *  @param code     验证码
 *  @param pushCode 企业地推码
 *  @param success  请求成功时调用
 *  @param failure  失败时调用
 */
+ (void)loginWithPhone:(NSString *)phone code:(NSString *)code cardNumber:(NSString *)cardNumber success:(void(^)(NSDictionary * responseDic))success
failue:(void(^)(NSError * errorMessage))failure;

/**
 *  下载用户头像
 */
+ (void)headIconDownloadWithToken:(NSString *)token success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure;
/**
 *  上传用户头像
 */
+ (void)headIconUploadWithToken:(NSString *)token pictures:(NSData *)pictures success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure;
/**
 *  广告轮播图
 */
+ (void)getADImgSuccess:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError * errorMessage))failure;
/**
 *  根据地区获取医馆列表
 *
 *  @param provinceID   省或直辖市的ID(可选)
 *  @param areaID       二级城市或直辖市的区 (可选)
 *  @param page         页码，每页返回20条（可选）
 *  @param type         类型：0全部，1关键词搜医馆，2：找附近医馆
 *  @param keywords     关键词
 *  @param position     位置坐标
 */
+ (void)chooseHospitalWithProviceID:(NSString *)provinceID areaID:(NSString *)areaID page:(NSString *)page type:(NSString *)type keywords:(NSString *)keywords position:(NSString *)position success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure;

/**
 *   提交问诊
 *
 *  @param token         用户token
 *  @param inquiryType   咨询类型ID:0用药，1疾病，2营养...
 *  @param symptomStatus 症状描述
 *  @param piture        上传图片（二进制）
 */
+ (void)inquiryUploadWithToken:(NSString *)token inquiryType:(NSString *)inquiryType symptomStatus:(NSString *)symptomStatus picture:(NSArray *)picture success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure;
/**
 *  问诊界面获取科室
 */
+ (void)inquiryDepartmentsSuccess:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure;
#pragma -----mark-------我的预约
/**
 *  我的预约接口
 *
 *  @param deviceToken 设备token
 *  @param deviceId     设备id
 *  @param token       用户token
 *  @param page        请求的页数，第一页为0
 */
//+ (void)myAppointWithToken:(NSString *)token page:(NSString *)page success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure;


/**
 *  我的预约详情接口
 *
 *  @param token     用户token
 *  @param appointID 预约id
 */
+ (void)myAppointDetailWithToken:(NSString *)token appointID:(NSString *)appointID type:(NSString *)appointType success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure;

/**
 *  我的预约界面服务反馈
 *
 *  @param appointID  预约id
 *  @param status     是否已就医； 0，未就医；1，已就医
 *  @param serviceDes 服务情况、检查结果（可选）
 *  @param pictures   病历、化验单、照片等（可选）
 *  @param star       评星
 *  @param reason     选择未服务的原因：1忘了，2医生没来...
 *  @param content    反馈的意见（或其他未服务的原因）
 */
+ (void)serviceFeedbackWithAppointID:(NSString *)appointID status:(NSString *)status serviceDes:(NSString *)serviceDes pictures:(NSArray *)pictures star:(NSString *)star reason:(NSString *)reason content:(NSString *)content andType:(NSString *)appointType success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;


/**
 *  取消预约
 *  @param cancelReason 取消原因
 *  @param appointID 问诊id
 *  @param Token 用户token
 */
+ (void)cancelAppointWithToken:(NSString *)token appointID:(NSString *)appointID cancelReason:(NSString *)cancelReason type:(NSString *)appointType success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
#pragma -----mark-------我的问诊列表
/**
 *  我的问诊列表
 *
 *  @param Token 用户token
 */
+ (void)inquiryWithToken:(NSString *)token success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
#pragma -----mark-------我的问诊详情
/**
 *  我的问诊详情
 *
 *  @param inquiryID 问诊ID
 */
+ (void)inquiryDetailWithInquiryID:(NSString *)inquiryID page:(NSString *)page success:(void (^)(NSDictionary *responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  提交问诊回复
 *
 *  @param inquiryID 问诊ID
 *  @param usrType   用户类型0医生 1用户
 *  @param question  问题内容
 */
+ (void)returnInquiryWithInquiryID:(NSString *)inquiryID question:(NSString *)question replyImg:(UIImage *)replyImg Success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  采纳医生的回复
 *
 *  @param inquiryID 问诊ID
 *  @param messageID 消息ID
 *  @param time      回复时间
 *  @param adopt     是否采纳（0：否 1：是）
 */
+ (void)adoptDocReplyWithInquiryID:(NSString *)inquiryID messageID:(NSString *)messageID time:(NSString *)time adopt:(NSString *)adopt success:(void (^)(NSDictionary * responseDic))success failure:(void (^)(NSError * errorMessage))failure;

#pragma -----mark------活动义诊 
/**
 *  活动义诊
 *
 *  @param Token 用户token
 */
+ (void)activityWithToken:(NSString *)token success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;

/**
 *  活动义诊详情
 *
 *  @param activityID 活动ID
 */
+ (void)activityDetailWithID:(NSString *)activityID success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
#pragma -----mark-----发现
/**
 *  发现界面
 */
+ (void)disCoverSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError *errorMessage))failure;
/**
 *  上传选择医馆
 *
 *  @param token   用户token
 *  @param hosID   选择的医馆
 */
+ (void)upLoadHosArrWithToken:(NSString *)token HosIDArr:(NSString *)hosID success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  根据医馆id获取详情
 *
 *  @param hosID   选择的医馆
 */
+ (void)getHosDetailWithHosID:(NSString *)hosID success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  我的服务包
 *
 *  @param token   用户token
 *  @param page    请求的页数，第一页为0
 */
+ (void)myPackagesWithToken:(NSString *)token page:(NSString *)page success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;


/**
 *  我的服务包使用详情
 *
 *  @param token   用户token
 *  @param itemID    服务项目ID
 */
+ (void)packagesDetailWithToken:(NSString *)token itemID:(NSString *)itemID success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
#pragma ----mark-----我的钱包
/**
 *  获取我的钱包使用情况
 */
+ (void)myWalletSuccess:(void (^)(NSDictionary * responseDic))success failure:(void (^)(NSError * errorMessage))failure;
/**
 *  获取我的钱包余额
 */
+ (void)myWalletNewestBalanceSuccess:(void(^)(NSDictionary * responseDic))success failure:(void (^)(NSError * errorMessage))failure;

#pragma ----mark-----医疗服务列表
/**
 *  医疗服务列表
 *
 *  @param Token 用户token
 */
+ (void)serverWithToken:(NSString *)token success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  医疗服务详情
 *
 *  @param token   用户token
 *  @param serviceID    服务项目ID
 */
+ (void)serverDetailWithToken:(NSString *)token serviceID:(NSString *)serviceID success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;


/**
 *  写入健康档案
 *
 *  @param token               用户token
 *  @param maritalStatus       婚姻状况
 *  @param birthCondition      生育状况
 *  @param operation           手术和外伤情况
 *  @param operationDetail     手术和外伤情况补充
 *  @param familyHistory       家族病史
 *  @param familyHistoryDetail 家族病史补充内容
 *  @param drugAllergy         药物过敏
 *  @param drugAllergyDetail   药物过敏补充内容
 *  @param foodAllergy         食物过敏
 *  @param foodAllergyDetail   食物过敏补充内容
 *  @param habits              个人习惯
 *  @param habitsDetail        个人习惯补充内容
 */
+ (void)writeArchivesWithToken:(NSString *)token maritalStatus:(NSString *)maritalStatus birthCondition:(NSString *)birthCondition operation:(NSString *)operation operationDetail:(NSString *)operationDetail familyHistory:(NSString *)familyHistory familyHistoryDetail:(NSString *)familyHistoryDetail drugAllergy:(NSString *)drugAllergy drugAllergyDetail:(NSString *)drugAllergyDetail foodAllergy:(NSString *)foodAllergy foodAllergyDetail:(NSString *)foodAllergyDetail habits:(NSString *)habits habitsDetail:(NSString *)habitsDetail success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;

/**
 *  读取健康档案基本信息
 *
 *  @param Token 用户token
 */
+ (void)readArchivesWithToken:(NSString *)token success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  读取健康档案健康建议
 */
+ (void)getHealthDocSuggestSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;


/**
 *  补充医疗服务照片
 *
 *  @param token    用户token
 *  @param serviceID 医疗服务ID
 *  @param pictures  病历，检查结果的图片(数组)
 */
+ (void)addMedicalServerImgWithToken:(NSString *)token serviceID:(NSString *)serviceID pictures:(NSArray *)pictures success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure;

/**
 *  获取健康管理列表
 *
 *  @param token   用户token
 */
+ (void)healthManagersWithToken:(NSString *)token success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;

/**
 *  意见反馈
 *
 *  @param Token 用户token
 *  @parm content  反馈意见
 */
+ (void)suggestionWithToken:(NSString *)token content:(NSString *)content success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  获取地区列表
 */
+ (void)getAreaSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  版本更新
 */
+ (void)versionUpdateSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  服务券详情
 */
+ (void)ticketDetailWithTicketid:(NSString *)ticketid cutoffdate:(NSString *)cutoffdate Success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
#pragma ---mark----签到
/**
 *  签到详情数据
 */
+ (void)signInDataSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;

/**
 *  点击签到
 */
+ (void)signInSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  判断是否签到
 */
+ (void)isSignInSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;

#pragma ----mark----答题
/**
 *  获取问题库
 */
+ (void)getAnswerWithType:(NSString *)typeID Success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;
/**
 *  提交答案
 */
+ (void)updateAnswer:(NSArray *)answers Type:(NSString *)typeID Success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;

/**
 *  体质详情
 */
+ (void)getBodyMessDetailWithType:(NSString *)healtyTypeID Success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;

#pragma ----mark----获取答题情况

+ (void)getTestReslutSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure;

/**
 *  获取个人信息
 */
+ (void)getPersonalMessSuccess:(void (^)(NSDictionary *responseDic))success failue:(void (^)(NSError *errorMessage))failure;
/**
 *  上传个人信息（name:昵称）
 */
+ (void)updatePersonalMessWithName:(NSString *)name Success:(void (^)(NSDictionary *responseDic))success failue:(void (^)(NSError *errorMessage))failure;

/**
 *  获取地址列表
 */
+ (void)getAdressTableSuccess:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

/**
 *  添加用户收件地址
 */
+ (void)addAdressWithName:(NSString *)name mobile:(NSString *)mobile adress:(NSString *)area street:(NSString *)street type:(NSString *)type adressID:(NSString *)adressID Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;
/**
 *  删除地址
 *
 *  @param adressID 地址ID
 */
+ (void)deleteAdressWithAdressID:(NSString *)adressID Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

/**
 *  修改默认地址
 */
+ (void)changeDefaultAdressWithAdressID:(NSString *)adressID Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;
/**
 *  获取评论列表
 */
+ (void)getArticleCommentsWithArticleID:(NSString *)articleID page:(NSString *)page Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;
/**
 *  上传回复
 */
+ (void)updateCommentWithArticleID:(NSString *)articleID commentcontent:(NSString *)commentcontent userID:(NSString *)userID Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;
/**
 *  收藏文章
 */
+ (void)saveArticleWithArticleID:(NSString *)articleID Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

/**
 *  我的收藏
 */
+ (void)getMySaveSuccess:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

/**
 *  点赞文章
 */
+ (void)likeArticleWithArticleID:(NSString *)articleID Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;
/**
 *  判断当前文章是否已点赞和收藏
 */
+ (void)checkArticleWithArticleID:(NSString *)articleID Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

/**
 *  上传在线咨询信息
 */
+ (void)updateChatMessWithOrderID:(NSString *)OrderID content:(NSString *)content image:(UIImage *)image Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;
/**
 *  绑定岐黄卡
 */
+ (void)bindingCardWithCardNum:(NSString *)CardNum phone:(NSString *)phone code:(NSString *)phoneCode Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

/**
 *  完善个人信息
 */
+ (void)updatePersonMessWithSex:(NSString *)sex name:(NSString *)name dateofbirth:(NSString *)dateofbirth Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;
/**
 *  扫描二维码后请求接口
 */
+ (void)scanCodeWithNumber:(NSString *)number Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

/**
 *  科室获取医生
 */
+ (void)getDepartDoctorWithParam:(NSDictionary *)param Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

/**
 *  补发预约码
 *  orderNo  :  订单号
 */
+ (void)getAppointCodeWithPhone:(NSString *)phone orderNo:(NSString *)orderNo Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure;

@end
