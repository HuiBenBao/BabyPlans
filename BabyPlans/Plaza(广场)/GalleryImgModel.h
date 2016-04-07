//
//  GalleryImgModel.h
//  BabyPlans
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureModel.h"

@interface GalleryImgModel : NSObject

@property (nonatomic,strong) PictureModel * picture;
@property (nonatomic,strong) NSString * messID;
@property (nonatomic,strong) NSString * index;

- (instancetype)initWithDic:(NSDictionary *)dic;
+ (instancetype)valueWithDic:(NSDictionary *)dic;
@end
