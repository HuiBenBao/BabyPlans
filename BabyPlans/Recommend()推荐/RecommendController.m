//
//  RecommendController.m
//  BabyPlans
//
//  Created by apple on 16/4/8.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RecommendController.h"
#import "RecWebController.h"
#import "LessonViewController.h"

#define bigBtnCount 6
@interface RecommendController ()

@end

@implementation RecommendController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI{

    CGFloat txtW = 304*SCREEN_WIDTH_RATIO55;
    CGFloat txtH = 51*SCREEN_WIDTH_RATIO55;
    CGFloat txtX = (KScreenWidth - txtW)/2;
    CGFloat txtY = 100*SCREEN_WIDTH_RATIO55;
    
    UIImageView * txtView = [[UIImageView alloc] initWithFrame:CGRectMake(txtX, txtY, txtW, txtH)];
    
    txtView.image = [UIImage imageNamed:@"RecommednTxt"];
    
    [self.view addSubview:txtView];
    
    int count = 2;  //每行显示按钮个数
    for (int i = 0; i < bigBtnCount; i ++) {
        
        UIButton * bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat btnH = 100*SCREEN_WIDTH_RATIO55;
        CGFloat btnW = btnH;
        CGFloat margic = (KScreenWidth-btnW*count) / (count*2);
        CGFloat btnX = margic + (btnW+margic*2) * (i%2);
        CGFloat btnY = txtView.bottom + 50*SCREEN_WIDTH_RATIO55 + (btnW+margic) * (i/2);
        
        bigBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        NSString * imgStr = [NSString stringWithFormat:@"Recommend_btn%d",i];
        
        [bigBtn setBackgroundImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
        
        bigBtn.tag = i;
        [bigBtn addTarget:self action:@selector(bigBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:bigBtn];
    }
    
    
}
/**
 *  点击跳转界面
 */
- (void)bigBtnClick:(UIButton *)sender{
    
    if (sender.tag==1) {
        [self.navigationController pushViewController:[[LessonViewController alloc] init] animated:YES];
    }else
        [self.navigationController pushViewController:[RecWebController RecWebWithIndex:sender.tag] animated:YES];
}
@end
