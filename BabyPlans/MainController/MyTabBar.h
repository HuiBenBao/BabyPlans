//
//  MyTabView.h
//  baby
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTabBar;

@protocol MyTabBarDelegate <NSObject>

@optional

- (void)tabBar:(MyTabBar *)tabBar didSelectedItemFrom:(NSInteger) from to:(NSInteger) to;

@end

@interface MyTabBar : UIView


@property (nonatomic,assign) id <MyTabBarDelegate>delegate;

- (void)addTarBarButtonWithImageName:(NSString *) name selectedImage:(NSString *) selectedName;


@end