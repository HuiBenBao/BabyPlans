//
//  UploadViewController.m
//  baby
//
//  Created by zhang da on 14-3-9.
//  Copyright (c) 2014年 zhang da. All rights reserved.
//

#import "UploadViewController.h"
#import "CreateMyPictureController.h"
#import "LoginViewController.h"

@interface UploadViewController ()

@property (nonatomic,strong) NSArray * BtnArr;

@end

@implementation UploadViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    if ([self isViewLoaded]) {
        [self animationIn];
    }
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
    
    NSMutableArray * tempArr = [NSMutableArray array];
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
        
        paintBtn.alpha = 0;
        [self.view addSubview:paintBtn];
        
        [tempArr addObject:paintBtn];
    }
    
    self.BtnArr = tempArr;
    


}
- (void)animationIn{

    [_BtnArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * btn = obj;
        CGFloat x = btn.frame.origin.x;
        CGFloat y = btn.frame.origin.y;
        CGFloat width = btn.frame.size.width;
        CGFloat height = btn.frame.size.height;
        btn.frame = CGRectMake(x, 0, width, height);
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(idx * 0.03 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.75 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:20 options:UIViewAnimationOptionCurveEaseOut animations:^{
                btn.alpha = 1;
                btn.frame = CGRectMake(x, y, width, height);
            } completion:^(BOOL finished) {
            }];
        });
    }];
}

#pragma mark uievent
- (void)paintClick:(UIButton *)sender{

    if ([self isLogin]) {
        
        CreateMyPictureController *ngVC = [[CreateMyPictureController alloc] init];
        ngVC.type = [NSString stringWithFormat:@"%ld",(long)sender.tag];
        [self.navigationController pushViewController:ngVC animated:YES];
    }else{
    
        [self goLogin];
    }
    

}
- (void)goLogin{
    

    LoginViewController * loginVC = [[LoginViewController alloc] init];
//        loginVC.delegate = self;
    
    [self presentViewController:loginVC animated:YES completion:nil];
    
}

#pragma ---mark-----判断是否登录
- (BOOL)isLogin{
    
    if (!(ValidStr([defaults objectForKey:@"session"]))) {//未登录
        
//        [self goLogin];
        return NO;
    }else{
        
        return YES;
    }
}

@end
