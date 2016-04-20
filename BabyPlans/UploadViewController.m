//
//  UploadViewController.m
//  baby
//
//  Created by zhang da on 14-3-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UploadViewController.h"
#import "CreateMyPictureController.h"

@interface UploadViewController ()


@end

@implementation UploadViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
}

- (void)createUI {
    
    self.navigationItem.title = @"绘本宝";
    self.view.backgroundColor = ViewBackColor;
    
    
    NSArray * titleArr = @[@"原创绘本",@"经典绘本"];
    
    CGFloat btnW = 100*SCREEN_WIDTH_RATIO55;
    CGFloat btnH = btnW;
    CGFloat margic = 40*SCREEN_WIDTH_RATIO55;
    CGFloat btnX = (KScreenWidth - btnW)/2;
    
    CGFloat tempY = (KScreenHeight - KTabBarHeight - btnH*titleArr.count - margic)/2;
    for (int i = 0; i < titleArr.count; i++) {
        
        CGFloat btnY = tempY + (btnH+margic)*i;
        
        UIButton * paintBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        paintBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        paintBtn.layer.borderWidth = 1;
        paintBtn.layer.borderColor = [UIColor orangeColor].CGColor;
        paintBtn.layer.cornerRadius = btnH/2;
        paintBtn.clipsToBounds = YES;
        
        paintBtn.titleLabel.font = FONT_ADAPTED_NUM(18);
        [paintBtn setTitle:titleArr[i] forState:UIControlStateNormal];
        
        UIColor * titleColor = (i==0) ? [UIColor orangeColor] : ColorI(0xffffff);
        [paintBtn setTitleColor:titleColor forState:UIControlStateNormal];
        [paintBtn setBackgroundColor:(i==1) ? [UIColor orangeColor] : ColorI(0xffffff)];
        
        paintBtn.tag = i;
        [paintBtn addTarget:self action:@selector(paintClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:paintBtn];
    }

}


#pragma mark uievent
- (void)paintClick:(UIButton *)sender{

    CreateMyPictureController *ngVC = [[CreateMyPictureController alloc] init];
    [self.navigationController pushViewController:ngVC animated:YES];

}


@end
