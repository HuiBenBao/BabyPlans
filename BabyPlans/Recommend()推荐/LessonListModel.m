//
//  LessonListModel.m
//  BabyPlans
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LessonListModel.h"

@implementation LessonListModel
+ (instancetype)valueWithDic:(NSDictionary *)dic{

    return [[self alloc] initWithDic:dic];
}
- (instancetype)initWithDic:(NSDictionary *)dic{
    
    if (self == [super init]) {
        if (ValidNum(dic[@"commentCnt"])) {
            
            int count = [dic[@"commentCnt"] intValue];
            self.commentCnt = [NSString stringWithFormat:@"%d",count];
        }
        
        if (ValidStr(dic[@"cover"])) {
            self.coverImg = dic[@"cover"];
        }
        
        if (ValidNum(dic[@"videoLength"])) {
            
            int count = [dic[@"videoLength"] intValue];
            self.videoLength = [NSString stringWithFormat:@"%d",count];
        }
        if (ValidNum(dic[@"id"])) {
            
            int count = [dic[@"id"] intValue];
            self.messID = [NSString stringWithFormat:@"%d",count];
        }
        if (ValidStr(dic[@"videoMain"])) {
            self.videoMain = dic[@"videoMain"];
        }
        if (ValidStr(dic[@"videoPreview"])) {
            self.videoPreview = dic[@"videoPreview"];
        }
        if (ValidStr(dic[@"title"])) {
            self.title = dic[@"title"];
        }
        
        if (ValidNum(dic[@"id"])) {
            
            int count = [dic[@"id"] intValue];
            self.messID = [NSString stringWithFormat:@"%d",count];
        }
        
        if (ValidNum(dic[@"createTime"])) {
            long long time = [dic[@"createTime"] longLongValue];
            
            self.createTime = [PersonalMethod stringFromUnixTime:time];
            
        }
        
    }
    
    return self;

}
@end
