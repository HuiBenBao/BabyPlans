//
//  GalleryImgModel.m
//  BabyPlans
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GalleryImgModel.h"

@implementation GalleryImgModel
+ (instancetype)valueWithDic:(NSDictionary *)dic{
    
    return [[self alloc] initWithDic:dic];
}

- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self = [super init]) {
        
        if (ValidNum(dic[@"id"])) {
            self.messID = dic[@"id"];
        }
        if (ValidNum(dic[@"index"])) {
            self.index = dic[@"index"];
        }
        if (ValidDict(dic[@"picture"])) {
            self.picture = [PictureModel valueWithDic:dic[@"picture"]];
        }
        
        
    }
    
    return self;
}
@end
