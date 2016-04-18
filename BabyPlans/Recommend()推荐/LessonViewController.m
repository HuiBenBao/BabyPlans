//
//  LessonViewController.m
//  BabyPlans
//
//  Created by apple on 16/4/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LessonViewController.h"

#define CountInOnePage 10    //每页显示数据个数

@interface LessonViewController ()

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,assign) int page;

@end


@implementation LessonViewController


- (NSArray *)dataArr{

    if (!_dataArr) {
        
        _page = 1;
        [CloudLogin getLessonCount:[NSString stringWithFormat:@"%d",CountInOnePage] Page:[NSString stringWithFormat:@"%d",_page] Success:^(NSDictionary *responseObject) {
            
            NSLog(@"%@",responseObject);
            
            int status = [responseObject[@"status"] intValue];
            
            if (status==0) {
                NSArray * lessons = responseObject[@"lessons"];
                
                for (NSDictionary * dic in lessons) {
                    
                }
            }
        } failure:^(NSError *errorMessage) {
            [self.view requsetFaild];
        }];
    }
    return _dataArr;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self dataArr];
}
@end
