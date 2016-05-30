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
    _myTabBar = [[MyTabBar alloc] init];
    _myTabBar.frame = self.tabBar.bounds;
    
    _myTabBar.delegate = self;
    
    [self.tabBar addSubview:_myTabBar];
    
    //添加对应的按钮个数
    
//    NSArray * titleArr = @[@"广场",@"分类",@"故事",@"我的"];
    NSArray * titleArr = @[@"广场",@"我的"];
    for (int i = 0; i < self.viewControllers.count; i++) {
        
        //设置图片和选中状态下的图片
        NSString * name = [NSString stringWithFormat:@"TabBar%d.png",i+1];
        
        NSString * seletTwoName = @"TabBar3";
        NSString * otherName = [NSString stringWithFormat:@"TabBarSeleted%d.png",i+1];
        
        if (i==self.viewControllers.count-1) {
            name = [NSString stringWithFormat:@"TabBar%d.png",5];
            otherName = [NSString stringWithFormat:@"TabBarSeleted%d.png",5];
        }
        
        NSString * selectName = i == 1 ? seletTwoName :otherName;
        
        NSString * title;
        if (i!=1) {
            title = i < 1 ? titleArr[i] : titleArr[i-1];
        }
        [_myTabBar addTarBarButtonWithImageName:name selectedImage:selectName btnName:title];
    }
}

#pragma mark- tabBar的代理方法实现
- (void)tabBar:(MyTabBar *)tabBar didSelectedItemFrom:(NSInteger)from to:(NSInteger)to{
    
    self.selectedIndex = to;
    
}

@end
