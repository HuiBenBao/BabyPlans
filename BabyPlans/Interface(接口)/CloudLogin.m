//
//  CloudLogin.m
//  TCMHealth
//
//  Created by 12344 on 15/9/18.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import "CloudLogin.h"
#import <AVFoundation/AVFoundation.h>
#import "CafToMp3.h"

@interface CloudLogin()

@property (nonatomic,strong) id data;

@end


@implementation CloudLogin

+ (void)loginWithPhoneNum:(NSString *)phoneNum password:(NSString *)password success:(Success)success failure:(Failure)failure{
    
    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:@"user_Login" forKey:@"action"];
    
    [parma setValue:phoneNum forKey:@"mobile"];
    if (password) {
        [parma setValue:[password MD5String] forKey:@"password"];
    }else{
        
        [parma setValue:@"d41d8cd98f00b204e9800998ecf8427e" forKey:@"password"];
    }
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
    
}
+ (void)shareLoginWithPhoneNum:(NSString *)phoneNum openid:(NSString *)openid success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:@"user_Register1" forKey:@"action"];
    
    [parma setValue:phoneNum forKey:@"mobile"];
 
        
    [parma setValue:@"d41d8cd98f00b204e9800998ecf8427e" forKey:@"password"];
    [parma setValue:openid forKey:@"openid"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}

+ (void)registerWithPhoneNum:(NSString *)phoneNum password:(NSString *)password code:(NSString *)code type:(NSInteger)type success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    NSString * action = (type==0) ? @"user_Reset" : @"user_Register";
    [parma setValue:action forKey:@"action"];
    
    [parma setValue:phoneNum forKey:@"mobile"];
    [parma setValue:code  forKey:@"verifi_code"];

    [parma setValue:[password MD5String] forKey:@"password"];
    
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}

+ (void)getCodeWithPhoneNum:(NSString *)phoneNum type:(NSString *)type success:(Success)success failure:(Failure)failure{
    
    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:@"verificode_Query" forKey:@"action"];
    [parma setObject:type forKey:@"verifi_type"];
    [parma setValue:phoneNum forKey:@"mobile"];
    
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

    
}

+ (void)getPlazaDataWithType:(NSString *)type page:(NSString *)page count:(NSString *)count userID:(NSString *)userID status:(NSInteger)status success:(Success)success failure:(Failure)failure{
    
    NSMutableDictionary * parma = [NSMutableDictionary dictionary];

    if (type) {
        [parma setValue:type forKey:@"type"];

    }
    
    if (userID) {
        [parma setValue:userID forKey:@"user_id"];
    }
    [parma setValue:@"gallery_query" forKey:@"action"];

    NSString * statusStr = [NSString stringWithFormat:@"%ld",(long)status];
    [parma setValue:statusStr forKey:@"status"];

    [parma setValue:page forKey:@"page"];
    [parma setValue:count forKey:@"count"];


    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}

+ (void)searchPalzaDataWithWord:(NSString *)word page:(NSNumber *)page count:(NSString *)count success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:@"gallery_find" forKey:@"action"];
    
    
    [parma setValue:word forKey:@"keyword"];
    [parma setValue:page forKey:@"page"];
    [parma setValue:count forKey:@"count"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}
+ (void)getPictureArrWithGalleryID:(NSString *)galleryID success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    [parma setValue:@"gallery_Query" forKey:@"action"];
    
    
    [parma setValue:galleryID forKey:@"gallery_id"];
    
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
+ (void)getCommentArrWithGalleryID:(NSString *)galleryID Page:(NSString *)page Count:(NSString *)count success:(Success)success failure:(Failure)failure{

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

+ (void)pushCommentWithWithGalleryID:(NSString *)galleryID replyTo:(NSString *)replyTo voice:(NSString *)voice voiceLen:(NSString *)voiceLen content:(NSString *)content success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"gcomment_Add" forKey:@"action"];
    [parma setValue:galleryID forKey:@"gallery_id"];
    ;
    
    
    if (replyTo){
        [parma setValue:replyTo forKey:@"reply_to"];
    }
    
    
    //语音长度
    [parma setValue:voiceLen forKey:@"voice_length"];
        

    //内容
    if (content){
        [parma setValue:content forKey:@"content"];
    }
    
    
    
    
    //获取请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置返回的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
    
    if ([defaults valueForKey:@"session"]) {
        
        [manager.requestSerializer setValue:[defaults valueForKey:@"session"] forHTTPHeaderField:@"session_id"];
    }
    [manager POST:BASEURL parameters:parma constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (!content) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docsDir = [dirPaths objectAtIndex:0];
            NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"recordTest.caf"];
            
            NSString *mp3FilePath = [docsDir stringByAppendingPathComponent:@"recordTest.mp3"];;//存储mp3文件的路径
            
            [CafToMp3 audio_PCMtoMP3:soundFilePath andMP3FilePath:mp3FilePath];
            
            NSData * myData = [NSData dataWithContentsOfFile:soundFilePath];
            
            [formData appendPartWithFileData:myData name:@"voice" fileName:soundFilePath mimeType:@"audio/mp3"];
        }
        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

+ (void)changeIcon:(UIImage *)icon nikeName:(NSString *)name birthday:(NSString *)birthday sex:(NSString *)sex Success:(Success)success failure:(Failure)failure{
    
    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"user_Edit" forKey:@"action"];
    
    if (name){
        [parma setValue:name forKey:@"nick_name"];
    }
    
    if (birthday){
        [parma setValue:birthday forKey:@"birthday"];
    }
    
    if (sex){
        [parma setValue:sex forKey:@"gender"];
    }
    
    //获取请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置返回的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
    
    if ([defaults valueForKey:@"session"]) {
        
        [manager.requestSerializer setValue:[defaults valueForKey:@"session"] forHTTPHeaderField:@"session_id"];
    }
    [manager POST:BASEURL parameters:parma constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (icon) {
            
            //这里将图片放在沙盒的documents文件夹中
            NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            
            //文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.jpg
            [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            //    图片压缩
            NSData *imageDate = UIImageJPEGRepresentation(icon, 0.5);
            
            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:imageDate attributes:nil];
            
            //得到选择后沙盒中图片的完整路径
            NSString * filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
            
            [formData appendPartWithFileData:imageDate name:@"avatar" fileName:filePath mimeType:@"image/png"];
        }

        
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

+ (void)SuggestWithContent:(NSString *)content Success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"feedback_Add" forKey:@"action"];
    [parma setValue:content forKey:@"content"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

    
}
+ (void)updatePictureWithImage:(UIImage *)image voiceLength:(NSString *)voiceLen uccess:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"picture_Add" forKey:@"action"];
    [parma setValue:voiceLen forKey:@"voice_length"];
    ;
    
    //获取请求管理对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //设置返回的数据格式
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json",@"text/html", nil]];
    
    if ([defaults valueForKey:@"session"]) {
        
        [manager.requestSerializer setValue:[defaults valueForKey:@"session"] forHTTPHeaderField:@"session_id"];
    }
    [manager POST:BASEURL parameters:parma constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if ([voiceLen intValue]>0) {
            AVAudioSession *audioSession = [AVAudioSession sharedInstance];
            [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *docsDir = [dirPaths objectAtIndex:0];
            NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"recordTest.caf"];
            
            NSString *mp3FilePath = [docsDir stringByAppendingPathComponent:@"recordTest.mp3"];;//存储mp3文件的路径
            
            [CafToMp3 audio_PCMtoMP3:soundFilePath andMP3FilePath:mp3FilePath];
            
            NSData * myData = [NSData dataWithContentsOfFile:mp3FilePath];
            
            [formData appendPartWithFileData:myData name:@"voice" fileName:soundFilePath mimeType:@"audio/mp3"];
        }
        
        if (image) {
            
            //这里将图片放在沙盒的documents文件夹中
            NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
            
            //文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.jpg
            [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
            
            //    图片压缩
            NSData *imageDate = UIImageJPEGRepresentation(image, 1.0);

            [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:@"/image.png"] contents:imageDate attributes:nil];
            
            //得到选择后沙盒中图片的完整路径
            NSString * filePath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  @"/image.png"];
            
            [formData appendPartWithFileData:imageDate name:@"image" fileName:filePath mimeType:@"image/png"];
        }
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        success(dic);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];

}

+ (void)publishContent:(NSString *)content title:(NSString *)title type:(NSString *)type ImgIDArr:(NSArray *)imgIDArr Success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"gallery_Add" forKey:@"action"];
    
    NSMutableDictionary *galleryJson = [[NSMutableDictionary alloc] init];
    
    [galleryJson setObject:type forKey:@"type"];
    [galleryJson setObject:title forKey:@"title"];
    [galleryJson setObject:content forKey:@"content"];
    
    [galleryJson setValue:imgIDArr forKey:@"pictures"];
    
    
    NSString *json = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:galleryJson
                                                       options:(NSJSONWritingOptions)0
                                                         error:&error];
    json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [parma setValue:json forKey:@"gallery_json"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}

+ (void)likeWithGalleryID:(NSString *)galleryID type:(NSString *)type success:(Success)success failure:(Failure)failure{

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

+ (void)attentionToUserID:(NSString *)userID type:(NSString *)type success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"user_Relation" forKey:@"action"];
    [parma setValue:userID forKey:@"user_id"];
    [parma setValue:type forKey:@"relation"];
    
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}


+ (void)getUserCollectAndAttentionWithUserID:(NSString *)userID success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"user_list" forKey:@"action"];
    [parma setValue:userID forKey:@"user_id"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}
+ (void)getUserMessageWithID:(NSString *)userID success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"user_Query" forKey:@"action"];
    [parma setValue:userID forKey:@"user_id"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}
+ (void)getLessonCount:(NSString *)count Page:(NSString *)page Success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"lesson_Query" forKey:@"action"];
    [parma setValue:@"2" forKey:@"type"];// 2 ：绘本宝
    [parma setValue:count forKey:@"count"];
    [parma setValue:page forKey:@"page"];

    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];

}

+ (void)SystemMessSuccess:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"msgsend_query" forKey:@"action"];
    [parma setValue:[defaults valueForKey:@"token"] forKey:@"userId"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}
+ (void)UserCollectWihtPage:(NSString *)page count:(NSString *)count Success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"gallery_Like" forKey:@"action"];
    [parma setValue:page forKey:@"page"];
    [parma setValue:count forKey:@"count"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}
+ (void)UserAttentionWihtPage:(NSString *)page count:(NSString *)count Success:(Success)success failure:(Failure)failure{
    
    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"user_Friends" forKey:@"action"];
    [parma setValue:page forKey:@"page"];
    [parma setValue:count forKey:@"count"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}

+ (void)UserFansWihtPage:(NSString *)page count:(NSString *)count Success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"user_Fans" forKey:@"action"];
    [parma setValue:page forKey:@"page"];
    [parma setValue:count forKey:@"count"];
    [parma setValue:[defaults valueForKey:@"token"] forKey:@"user_id"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
    
}

+ (void)GetUnreadMessCountSuccess:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"msgSend_count" forKey:@"action"];
    [parma setValue:[defaults valueForKey:@"token"] forKey:@"userId"];
    
    [CloudLogin getDataWithURL:nil parameter:parma success:^(id data) {
        success(data);
    } failure:^(NSError *errorMessage) {
        failure(errorMessage);
    }];
}
+ (void)deleteGalleryWithGalleryID:(NSString *)galleryID Success:(Success)success failure:(Failure)failure{

    NSMutableDictionary * parma = [NSMutableDictionary dictionary];
    
    [parma setValue:@"gallery_del" forKey:@"action"];
    [parma setValue:galleryID forKey:@"gallery_id"];
    
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
