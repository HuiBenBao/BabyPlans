//
//  PictureModel.h
//  BabyPlans
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject
@property (nonatomic,strong) NSString * pictureID;
@property (nonatomic,strong) NSString * image;
@property (nonatomic,strong) NSString * imageSmall;
@property (nonatomic,strong) NSString * voice;
@property (nonatomic,strong) NSString * voiceLength;
@property (nonatomic,strong) NSString * date;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;

@end
