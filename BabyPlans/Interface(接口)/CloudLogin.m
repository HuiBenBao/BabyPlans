//
//  CloudLogin.m
//  TCMHealth
//
//  Created by 12344 on 15/9/18.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import "CloudLogin.h"


@interface CloudLogin()

@property (nonatomic,strong) id data;

@end


@implementation CloudLogin

+ (void)loginWithPhoneNum:(NSString *)phoneNum password:(NSString *)password success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:@"user_Login" forKey:@"action"];
    
    [parma setValue:phoneNum forKey:@"mobile"];
    [parma setValue:[password MD5String] forKey:@"password"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
+ (void)getCodeWithPhoneNum:(NSString *)phoneNum success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:@"verificode_Query" forKey:@"action"];
    
    [parma setValue:phoneNum forKey:@"mobile"];
    
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

    
}

+ (void)getPlazaDataWithType:(NSString *)type page:(NSString *)page count:(NSString *)count success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:type forKey:@"type"];
    [parma setValue:@"gallery_query" forKey:@"action"];
//    [parma setValue:@"gallery_list" forKey:@"action"];

    [parma setValue:page forKey:@"page"];
    [parma setValue:count forKey:@"count"];
//    [parma setValue:@"userId" forKey:@"5"];

    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}

+ (void)getPictureArrWithGalleryID:(NSString *)galleryID success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:@"gallery_Query" forKey:@"action"];
    
    
    [parma setValue:galleryID forKey:@"gallery_id"];
    
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
+ (void)getCommentArrWithGalleryID:(NSString *)galleryID Page:(NSString *)page Count:(NSString *)count success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"gcomment_Query" forKey:@"action"];
    [parma setValue:galleryID forKey:@"gallery_id"];
    [parma setValue:page forKey:@"page"];
    [parma setValue:count forKey:@"count"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
+ (void)likeWithGalleryID:(NSString *)galleryID type:(NSString *)type success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"gallery_Relation" forKey:@"action"];
    [parma setValue:galleryID forKey:@"gallery_id"];
    [parma setValue:type forKey:@"relation"];
//    [parma setValue:[defaults objectForKey:@"token"] forKey:@"userId"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
    
    
}
#pragma mark>>>>>>------公用方法---------
#pragma -----mark------网络数据请求方法

+ (void)getDataWithURL:(NSString *)path parameter:(id)parameter success:(void(^)(id data))success failure:(void (^)(NSError * errorMessage))failure{

    
    //获取请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //拼接接口
    NSString * url = (path == nil) ? BASEURL : [NSString stringWithFormat:@"%@/%@",BASEURL,path];
    
    //设置返回的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
    
    if ([defaults valueForKey:@"session"]) {
        
        [manager.requestSerializer setValue:[defaults valueForKey:@"session"] forHTTPHeaderField:@"session_id"];

    }
    
    [manager POST:url parameters:parameter progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}


@end
