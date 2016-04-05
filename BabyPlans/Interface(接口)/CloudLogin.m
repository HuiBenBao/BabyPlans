//
//  CloudLogin.m
//  TCMHealth
//
//  Created by 12344 on 15/9/18.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import "CloudLogin.h"
#import "Encrypt.h"

@interface CloudLogin()

@property (nonatomic,strong) id data;

@end


@implementation CloudLogin

#pragma -----mark------验证码获取方法

+ (void)getCodeWithPhoneNum:(NSString *)phoneNum type:(NSString *)type success:(void (^)(NSDictionary * responseDic))success
                 failure:(void (^)(NSError * errorMessage))failure{

    
    //接口
    NSString * url = @"User/identify_code";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
   
    parameter[@"phoneNum"] = phoneNum;
    parameter[@"type"] = type;
    
    [CloudLogin getDataWithURL:url parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
    
}

#pragma -----mark------登陆接口调用方法

+ (void)loginWithPhone:(NSString *)phone code:(NSString *)code cardNumber:(NSString *)cardNumber success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{
    
    //接口
    NSString * url = @"User/login";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"deviceToken"] = [defaults objectForKey:@"deviceToken"];
    parameter[@"phoneNum"] = phone;
    parameter[@"code"] = code;
    parameter[@"cardnumber"] = cardNumber;
    parameter[@"deviceType"] = @"2";
    [CloudLogin getDataWithURL:url parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];


    
}

#pragma -----mark------下载用户头像

+ (void)headIconDownloadWithToken:(NSString *)token success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{
    
    
    NSString * path = @"User/headIcon_download";
//     NSString * path = @"User/ceshi";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
                
        success(data);
        
    } failure:^(NSError * errorMessage) {
        
        failure(errorMessage);
    }];


}

#pragma ------mark-----上传用户头像

+ (void)headIconUploadWithToken:(NSString *)token pictures:(NSData *)pictures success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/headIcon_upload";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    
    NSString * myData = [pictures base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    parameter[@"pictures"] = myData;

    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        
        success(data);
        
    } failure:^(NSError * errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma -----mark- ----广告轮播图
+ (void)getADImgSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"User/ad";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    
    parameter[@"token"] = [defaults objectForKey:@"token"];
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
#pragma -----mark------根据地区获取医馆列表

+ (void)chooseHospitalWithProviceID:(NSString *)provinceID areaID:(NSString *)areaID page:(NSString *)page type:(NSString *)type keywords:(NSString *)keywords position:(NSString *)position success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure{

    NSString * path = @"Appoint/choose_hospitals";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"provinceID"] = provinceID;
    parameter[@"areaID"] = areaID;
    parameter[@"page"] = page;
    parameter[@"type"] = type;
    parameter[@"keywords"] = keywords;
    parameter[@"position"] = position;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
       
        success(data);
        TCMLog(@"--- %@ --- %@ --- %@ ---",path,parameter,[data description]);
    } failure:^(NSError *errorMessage) {
        TCMLog(@"--- %@ --- %@ --- %@ ---",path,parameter,[errorMessage description]);
        failure(errorMessage);
    }];
    

    
}
#pragma -----mark-----获取问诊科室
+ (void)inquiryDepartmentsSuccess:(void (^)(NSDictionary *responseDic))success failue:(void (^)(NSError *errorMessage))failure{

    NSString * path = @"User/inquiry_departments";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}

#pragma -----mark-------提交问诊

+ (void)inquiryUploadWithToken:(NSString *)token inquiryType:(NSString *)inquiryType symptomStatus:(NSString *)symptomStatus picture:(NSArray *)picture success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure{

    NSString * path = @"Appoint/inquiry_commit";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"departmentID"] = inquiryType;
    parameter[@"inquiryContent"] = symptomStatus;
    parameter[@"picture"] = picture;


    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        
        
        success(data);
        
    } failure:^(NSError * errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma -----mark--------我的预约接口请求

//+ (void)myAppointWithToken:(NSString *)token page:(NSString *)page success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{
//    
//    NSString * path = @"User/appointments";
//    //上传参数字典
//    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
//    //设置上传参数
//    
//    parameter[@"token"] = [defaults objectForKey:@"token"];
//    parameter[@"page"] = page;
//    
//    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
//        success(data);
//        
//    } failure:^(NSError *errorMessage) {
//        failure(errorMessage);
//    }];
//
//    
//}

#pragma -----mark--------我的预约详情
+ (void)myAppointDetailWithToken:(NSString *)token appointID:(NSString *)appointID type:(NSString *)appointType success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/appointment_detail";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"appointID"] = appointID;
    parameter[@"type"] = appointType;
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        

        success(data);
        
    } failure:^(NSError * errorMessage) {

        failure(errorMessage);
    }];

}

#pragma -----mark-------服务反馈
+ (void)serviceFeedbackWithAppointID:(NSString *)appointID status:(NSString *)status serviceDes:(NSString *)serviceDes pictures:(NSArray *)pictures star:(NSString *)star reason:(NSString *)reason content:(NSString *)content andType:(NSString *)appointType success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/service_feedback";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"appointID"] = appointID;
    parameter[@"status"] = status;
    parameter[@"serviceDes"] = serviceDes;
    parameter[@"pictures"] = pictures;
    parameter[@"star"] = star;
    parameter[@"reason"] = reason;
    parameter[@"content"] = content;
    parameter[@"appointtype"] = appointType;
	
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        
        
        success(data);
        
    } failure:^(NSError * errorMessage) {
        
        failure(errorMessage);
    }];

    
}
#pragma ------mark------取消预约

+ (void)cancelAppointWithToken:(NSString *)token appointID:(NSString *)appointID cancelReason:(NSString *)cancelReason type:(NSString *)appointType success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError *errorMessage))failure{

    NSString * path = @"User/appointment_cancel";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"appointID"] = appointID;
    parameter[@"cancelReason"] = cancelReason;
    parameter[@"type"] = appointType;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}
#pragma -----mark-------我的问诊

+ (void)inquiryWithToken:(NSString *)token success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError *errorMessage))failure{
    
    NSString * path = @"User/inquiries";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    
    //设置上传参数
    parameter[@"token"] = token;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
#pragma -----mark-------我的问诊详情

+ (void)inquiryDetailWithInquiryID:(NSString *)inquiryID page:(NSString *)page success:(void (^)(NSDictionary *responseDic ))success failue:(void (^)(NSError * errorMessage))failure{

    NSString * path = @"User/inquiry_detail";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"inquiryID"] = inquiryID;
    parameter[@"page"] = page;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
#pragma -----mark------上传问诊回复

+ (void)returnInquiryWithInquiryID:(NSString *)inquiryID question:(NSString *)question replyImg:(UIImage *)replyImg Success:(void (^)(NSDictionary *responseDic))success failue:(void (^)(NSError *errorMessage))failure{

    NSString * path = @"User/inquiry_reply";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"inquiryID"] = inquiryID;
    parameter[@"reply"] = question;
    parameter[@"usrType"] = @"1";
    
    NSString * upStr;
    if (replyImg) {
        NSData * data = UIImageJPEGRepresentation(replyImg, 0.01);
        
        upStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    parameter[@"replyImg"] = upStr;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}

#pragma -----mark------采纳医生的回复

+ (void)adoptDocReplyWithInquiryID:(NSString *)inquiryID messageID:(NSString *)messageID time:(NSString *)time adopt:(NSString *)adopt success:(void (^)(NSDictionary *responseDic))success failure:(void (^)(NSError *errorMessage))failure{

    NSString * path = @"User/adopt_reply";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"inquiryID"] = inquiryID;
    parameter[@"messageID"] = messageID;
    parameter[@"time"] = time;
    parameter[@"adopt"] = adopt;
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}

#pragma -----mark------活动义诊
+ (void)activityWithToken:(NSString *)token success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"Common/activities";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];

    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
#pragma -----mark------活动义诊详情
+ (void)activityDetailWithID:(NSString *)activityID success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{
    
    NSString * path = @"Common/activity_content";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    
    parameter[@"activityID"] = activityID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

    
}
#pragma ----mark-----发现
+ (void)disCoverSuccess:(void (^)(NSDictionary *responseDic))success failue:(void (^)(NSError *errorMessage))failure{

    NSString * path = @"discovery/discovery";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    parameter[@"page"] = 0;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
    
}
#pragma -----mark------上传选择的两家医馆
+ (void)upLoadHosArrWithToken:(NSString *)token HosIDArr:(NSString *)hosID success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure{

    NSString * path = @"User/hospitals_upload";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"hosID"] = hosID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
    
}

#pragma ----mark-----根据hosID获取医馆详情
+ (void)getHosDetailWithHosID:(NSString *)hosID success:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure{

    NSString * path = @"user/getPersonalCenter";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"centerid"] = hosID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma -----mark------我的服务包

+ (void)myPackagesWithToken:(NSString *)token page:(NSString *)page success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/packages";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"page"] = page;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}

#pragma -----mark------我的服务包使用详情

+ (void)packagesDetailWithToken:(NSString *)token itemID:(NSString *)itemID success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/package_detail";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"itemID"] = itemID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}

#pragma -----mark------我的钱包

+ (void)myWalletSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"User/myWallet";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    NSString * token = [defaults objectForKey:@"token"];
    parameter[@"token"] = token;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
       
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma -----mark-----钱包余额
+ (void)myWalletNewestBalanceSuccess:(void (^)(NSDictionary * responseDic))success failure:(void (^)(NSError * errorMessage))failure{
    
    NSString * path = @"User/myWallet_balance";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
    
}

#pragma -----mark------医疗服务列表

+ (void)serverWithToken:(NSString *)token success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/services";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    
    //设置上传参数
    parameter[@"token"] = token;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
        
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];


}

#pragma -----mark------医疗服务详情

+ (void)serverDetailWithToken:(NSString *)token serviceID:(NSString *)serviceID success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    
    NSString * path = @"User/service_detail";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"serviceID"] = serviceID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
    

}

#pragma ------mark---------写入健康档案

+ (void)writeArchivesWithToken:(NSString *)token maritalStatus:(NSString *)maritalStatus birthCondition:(NSString *)birthCondition operation:(NSString *)operation operationDetail:(NSString *)operationDetail familyHistory:(NSString *)familyHistory familyHistoryDetail:(NSString *)familyHistoryDetail drugAllergy:(NSString *)drugAllergy drugAllergyDetail:(NSString *)drugAllergyDetail foodAllergy:(NSString *)foodAllergy foodAllergyDetail:(NSString *)foodAllergyDetail habits:(NSString *)habits habitsDetail:(NSString *)habitsDetail success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/basic_info_add";
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    
    if (maritalStatus != nil || birthCondition != nil) {
        if ([maritalStatus isEqualToString:@"未婚"]) {
            maritalStatus = @"0";
        }else if ([maritalStatus isEqualToString:@"已婚"]){
            maritalStatus = @"1";
        }
        
        if ([birthCondition isEqualToString:@"未生育"]) {
            birthCondition = @"0";
        }else if ([birthCondition isEqualToString:@"已生育"]) {
            birthCondition = @"1";
        }else if ([birthCondition isEqualToString:@"备孕期"]) {
            birthCondition = @"2";
        }else if ([birthCondition isEqualToString:@"怀孕期"]) {
            birthCondition = @"3";
        }
        parameter[@"maritalStatus"] = maritalStatus;
        parameter[@"birthCondition"] = birthCondition;
    }
    
    if (operation != nil || operationDetail != nil) {
        parameter[@"operation"] = operation;
        parameter[@"operationDetail"] = operationDetail;
    }
    
    if (familyHistory != nil || familyHistoryDetail != nil) {
        parameter[@"familyHistory"] = familyHistory;
        parameter[@"familyHistoryDetail"] = familyHistoryDetail;
    }
    
    if (drugAllergy != nil || drugAllergyDetail != nil) {
        parameter[@"drugAllergy"] = drugAllergy;
        parameter[@"drugAllergyDetail"] = drugAllergyDetail;
    }
    
    if (foodAllergy != nil || foodAllergyDetail != nil) {
        parameter[@"foodAllergy"] = foodAllergy;
        parameter[@"foodAllergyDetail"] = foodAllergyDetail;
    }
    
    if (habits != nil || habitsDetail != nil) {
        parameter[@"habits"] = habits;
        parameter[@"habitsDetail"] = habitsDetail;
    }
    
    
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        
        
        success(data);
        
    } failure:^(NSError * errorMessage) {
        
        failure(errorMessage);
    }];

    
}

#pragma ------mark--------读取健康档案

+ (void)readArchivesWithToken:(NSString *)token success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/basic_info";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;

    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}

+ (void)getHealthDocSuggestSuccess:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"user/getDoctorEvaluate";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] =[defaults objectForKey:@"token"];
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}
#pragma ------mark--------补充医疗服务照片

+ (void)addMedicalServerImgWithToken:(NSString *)token serviceID:(NSString *)serviceID pictures:(NSArray *)pictures success:(void(^)(NSDictionary * responseDic))success failue:(void(^)(NSError * errorMessage))failure{

    NSString * path = @"User/add_pictures";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"serviceID"] = serviceID;
    parameter[@"pictures"] = pictures;
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}

#pragma ------mark--------获取健康管理列表

+ (void)healthManagersWithToken:(NSString *)token success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/feedback";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;

    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

    
}

#pragma ------mark-------意见反馈

+ (void)suggestionWithToken:(NSString *)token content:(NSString *)content success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/feedback";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = token;
    parameter[@"content"] = content;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}

#pragma -----mark-------获取全国所有地区

+ (void)getAreaSuccess:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"Common/provinces";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma -----mark------版本更新

+ (void)versionUpdateSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure{

    NSString * path = @"Common/version";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
    
}

#pragma -----mark-----服务券详情

+ (void)ticketDetailWithTicketid:(NSString *)ticketid cutoffdate:(NSString *)cutoffdate Success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/ticketDetail";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"ticketid"] = ticketid;
    parameter[@"cutoffdate"] = cutoffdate;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}

#pragma -----mark------签到数据

+ (void)signInDataSuccess:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/signAllMessage";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
    
}
#pragma ------mark-----点击签到
+ (void)isSignInSuccess:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/getReminderMessage";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

    
}

+ (void)signInSuccess:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"User/clickSign";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

    
}
#pragma -----mark-------获取问题库
+ (void)getAnswerWithType:(NSString *)typeID Success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"Intergral/intergralAnswer";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"typeID"] = typeID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}

#pragma ----mark-----上传答案

+ (void)updateAnswer:(NSArray *)answers Type:(NSString *)typeID Success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"Intergral/intergralResult";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:answers
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:nil];
    
    NSString * str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parameter[@"result"] = str;
    parameter[@"typeID"] = typeID;
	
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma ----mark----获取答题情况

+ (void)getTestReslutSuccess:(void (^)(NSDictionary * responseDic))success failue:(void (^)(NSError * errorMessage))failure{

    NSString * path = @"Conditioning/returnStatus";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}
#pragma ----mark-----体质详情
+ (void)getBodyMessDetailWithType:(NSString *)healtyTypeID Success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"Intergral/healthDetail";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"healthtypeID"] = healtyTypeID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma ----mark-----个人信息
+ (void)getPersonalMessSuccess:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{
    
    NSString * path = @"Intergral/personalDetails";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
    
}

+ (void)updatePersonalMessWithName:(NSString *)name Success:(void (^)(NSDictionary *))success failue:(void (^)(NSError *))failure{

    NSString * path = @"Intergral/setNickname";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"nickname"] = name;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

    
}
#pragma ----mark-----获取地址列表
+ (void)getAdressTableSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"Goods/getAllAddress";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];

    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

+ (void)addAdressWithName:(NSString *)name mobile:(NSString *)mobile adress:(NSString *)area street:(NSString *)street type:(NSString *)type adressID:(NSString *)adressID Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"Goods/addShipAddress";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"shipping_name"] = name;
    parameter[@"shipping_mobile"] = mobile;
    parameter[@"shipping_address"] = area;
    parameter[@"shipping_address_stree"] = street;
    parameter[@"type"] = type;
    parameter[@"addressID"] = adressID;

    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

+ (void)deleteAdressWithAdressID:(NSString *)adressID Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"Goods/deleteAddress";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"address_id"] = adressID;
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

+ (void)changeDefaultAdressWithAdressID:(NSString *)adressID Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"Goods/updateDefaultAddress";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"address_id"] = adressID;
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma ----mark-------评论列表

+ (void)getArticleCommentsWithArticleID:(NSString *)articleID page:(NSString *)page Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"discovery/getArticleComments";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"articleid"] = articleID;
    parameter[@"page"] = page;
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma ----mark------上传评论或回复
+ (void)updateCommentWithArticleID:(NSString *)articleID commentcontent:(NSString *)commentcontent userID:(NSString *)userID Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"discovery/replyComment";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"articleid"] = articleID;
    parameter[@"replyid"] = userID;
    parameter[@"commentcontent"] = commentcontent;
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma ----mark-----收藏文章
+ (void)saveArticleWithArticleID:(NSString *)articleID Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"discovery/collectArticle";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"articleid"] = articleID;
       
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma ----mark-----我的收藏
+ (void)getMySaveSuccess:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"discovery/collectArticleList";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma ----mark-----点赞文章

+ (void)likeArticleWithArticleID:(NSString *)articleID Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    NSString * path = @"discovery/likesArticle";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"articleid"] = articleID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma ----mark-----判断当前文章是否已点赞和收藏

+ (void)checkArticleWithArticleID:(NSString *)articleID Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    NSString * path = @"discovery/check";
   
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"articleid"] = articleID;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma ----mark------在线咨询

+ (void)updateChatMessWithOrderID:(NSString *)OrderID content:(NSString *)content image:(UIImage *)image Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"service/getDialogue";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"ordernumber"] = OrderID;
    parameter[@"content"] = content;
    
    
    NSString * upStr;
    if (image) {
        NSData * data = UIImageJPEGRepresentation(image, 0.01);
        
        upStr = [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    parameter[@"url"] = upStr;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma ----mark-----绑定岐黄卡
+ (void)bindingCardWithCardNum:(NSString *)CardNum phone:(NSString *)phone code:(NSString *)phoneCode Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"user/bindingCard";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"cardnumber"] = CardNum;
    parameter[@"code"] = phoneCode;
    parameter[@"phoneNum"] = phone;
    
       
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}

#pragma ----mark------完善个人信息
+ (void)updatePersonMessWithSex:(NSString *)sex name:(NSString *)name dateofbirth:(NSString *)dateofbirth Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure{

    NSString * path = @"user/updateUserAgeAndGender";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"gender"] = [sex isEqualToString:@"男"] ? @"0" : @"1";
    parameter[@"name"] = name;
    parameter[@"dateofbirth"] = dateofbirth;
    
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}

#pragma ----mark-----扫描二维码后请求接口
+ (void)scanCodeWithNumber:(NSString *)number Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure{

    NSString * path = @"goods/scanCode";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"number"] = number;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma ----mark-----科室获取医生

+ (void)getDepartDoctorWithParam:(NSDictionary *)param Success:(void(^)(NSDictionary * responseDic))success failure:(void(^)(NSError *errorMessage))failure{

    NSString * path = @"Appoint/doctors_diagnosis";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionaryWithDictionary:param];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];

}
#pragma ------mark-----------补发预约码

+ (void)getAppointCodeWithPhone:(NSString *)phone orderNo:(NSString *)orderNo Success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSString * path = @"User/getAppointmentVarification";
    
    //上传参数字典
    NSMutableDictionary * parameter = [NSMutableDictionary dictionary];
    //设置上传参数
    parameter[@"token"] = [defaults objectForKey:@"token"];
    parameter[@"phone"] = phone;
    parameter[@"orderNo"] = orderNo;
    
    [CloudLogin getDataWithURL:path parameter:parameter success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        
        failure(errorMessage);
    }];
}


#pragma mark>>>>>>------公用方法---------
#pragma -----mark------网络数据请求方法

+ (void)getDataWithURL:(NSString *)path parameter:(id)parameter success:(void(^)(id data))success failure:(void (^)(NSError * errorMessage))failure{

    
    //获取请求管理对象
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    
    //拼接接口
    NSString * url = [NSString stringWithFormat:@"%@%@",BASE_URL,path];
    
    //设置返回的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
    
    
//    //设置header
//    manager = [Encrypt getSignatureWithURL:url withParameters:parameter Manger:manager];

//    //数据加密
//    NSString * data = [Encrypt encryptRestultFormParam:parameter];
//    NSMutableDictionary * par = [NSMutableDictionary dictionary];
//    [par setValue:data forKey:@"params"];
//    TCMLog(@"--请求头header---%@",manager.requestSerializer.HTTPRequestHeaders);

    
    [manager POST:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //解密
//        NSDictionary * dic = [Encrypt decryptRestultFormData:responseObject];
        
        
          success(dic);
        
        
        if ([[dic objectForKey:@"code"] intValue ] == 252) {
            
            AppDelegate *delegate = [UIApplication sharedApplication].delegate;
            
//           [delegate.window poptips:@"账户异常，请重新登陆！" fadeOut:YES];
            
            [Util removeDefaultsObj:USER_INFO];
            
            [Util removeDefaultsObj:TOKEN];
            
//            TCMMyTabBarController * tabVC = (TCMMyTabBarController * )delegate.window.rootViewController;
//            
//            tabVC.selectedIndex = 1;
//            
//            tabVC.button.selected = YES;
        }
        
        
        
        
        
        
        
        
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failure(error);
    }];

}


@end
