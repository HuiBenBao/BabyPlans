//
//  MyTabBar.m
//  baby
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 zhang da. All rights reserved.
//

#import "MyTabBar.h"
#import "FWBTarBarButton.h"

@interface MyTabBar ()

@property (nonatomic,strong) UIButton * selectedButton;

@end
@implementation MyTabBar



- (void)addTarBarButtonWithImageName:(NSString *)name selectedImage:(NSString *)selectedName{
    //创建button
    FWBTarBarButton * button = [FWBTarBarButton buttonWithType:UIButtonTypeCustom];
    
    //设置tag
    button.tag = self.subviews.count;
    
    //设置图片
    [button setImage:[UIImage imageAutomaticName:name] forState:UIControlStateNormal];
    [button setImage:[UIImage imageAutomaticName:selectedName] forState:UIControlStateSelected];
    
    //设置点击响应
    [button addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchDown];
    
    //设置默认选中按钮
    if (button.tag == 0) {
        [self tabBarButtonClick:button];
    }
    
    //添加到tabBar
    [self addSubview:button];
    
}

/**
 *  当界面加载完成后，自动调用此方法设置按钮尺寸
 */
- (void)layoutSubviews{
    
    for (int i = 0; i < self.subviews.count; i++) {
        //取出按钮
        FWBTarBarButton * button = self.subviews[i];
        
        //设置尺寸
        CGFloat buttonW = self.frame.size.width/self.subviews.count;
        CGFloat buttonH = self.frame.size.height;
        CGFloat buttonY = 0;
        CGFloat buttonX = buttonW * i;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
    }
}
/**
 *  设置tabBar的按钮点击事件
 */
- (void)tabBarButtonClick:(FWBTarBarButton *)button{
    
    //通知代理（控制器）
    if ([self.delegate respondsToSelector:@selector(tabBar:didSelectedItemFrom:to:)]) {
        [self.delegate tabBar:self didSelectedItemFrom:_selectedButton.tag to:button.tag];
    }
    
    //将上一个选中的按钮selected状态设置为NO
    _selectedButton.selected = NO;
    
    //将本次点击按钮选中状态设为YES
    button.selected = YES;
    
    //将本次点击按钮存储在selectedButton
    _selectedButton = button;
    
}

@end
