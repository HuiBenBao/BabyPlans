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
        
    }
    
    return self;

}
@end
