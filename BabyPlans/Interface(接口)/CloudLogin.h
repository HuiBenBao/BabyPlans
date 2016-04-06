//
//  CloudLogin.h
//  TCMHealth
//  
//  Created by 12344 on 15/9/18.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CloudLogin : NSObject

+ (void)getPlazaDataWithType:(NSString *)type page:(NSString *)page count:(NSString *)count success:(void(^)(NSDictionary * responseObject))success failure:(void (^)(NSError * errorMessage))failure;

@end
