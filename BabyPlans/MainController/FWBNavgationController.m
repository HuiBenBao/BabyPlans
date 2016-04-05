//
//  FWBNavgationController.m
//  BabyPlans
//
//  Created by apple on 16/4/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "FWBNavgationController.h"

@interface FWBNavgationController ()

@end

@implementation FWBNavgationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 *  系统在第一次使用这个类的时候调用(1个类只会调用一次)
 */
+ (void)initialize
{
    // 1.设置导航栏主题
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    // 设置背景图片
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor orangeColor] ImgSize:CGRectMake(0, 0, KScreenWidth, 64)] forBarMetrics:UIBarMetricsDefault];
    
    // 设置标题文字颜色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:16];
    [navBar setTitleTextAttributes:attrs];
    
    
    
    // 2.设置BarButtonItem的主题
//    UIBarButtonItem *item = [UIBarButtonItem appearance];
//    // 设置文字颜色
//    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
//    itemAttrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
//    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
//    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    
//    if (!iOS7) {
//        // 设置按钮背景
//        [item setBackgroundImage:[UIImage imageNamed:@"NavButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackgroundImage:[UIImage imageNamed:@"NavButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//        
//        // 设置返回按钮背景
//        [item setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//        [item setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBackButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
//    }
}

@end
