//
//  RootTabBarController.m
//  baby
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 zhang da. All rights reserved.
//

#import "RootTabBarController.h"

#import "MyTabBar.h"

@interface RootTabBarController ()<MyTabBarDelegate>

@end

@implementation RootTabBarController



+ (void)initialize{

    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor orangeColor],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义tabBar
    MyTabBar * tabBar = [[MyTabBar alloc] init];
    tabBar.frame = self.tabBar.bounds;
    
    tabBar.delegate = self;
    
    [self.tabBar addSubview:tabBar];
    
    //添加对应的按钮个数
    for (int i = 0; i < self.viewControllers.count; i++) {
        
        //设置图片和选中状态下的图片
        NSString * name = [NSString stringWithFormat:@"TabBar%d.png",i+1];
        NSString * seletTwoName = @"TabBar3";
        NSString * selectName = i == 2 ? seletTwoName :[NSString stringWithFormat:@"TabBarSeleted%d.png",i+1];
        
        [tabBar addTarBarButtonWithImageName:name selectedImage:selectName];
    }
}

#pragma mark- tabBar的代理方法实现
- (void)tabBar:(MyTabBar *)tabBar didSelectedItemFrom:(NSInteger)from to:(NSInteger)to{
    
    self.selectedIndex = to;
}

@end
