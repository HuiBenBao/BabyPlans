//
//  UIView+Category.h
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//
#define VIEW_TIPS_TAG		10000099


#import <UIKit/UIKit.h>

@interface UIView (Category)

- (CGFloat)bottom;

- (CGFloat)height;
- (CGFloat)width;
- (CGFloat)right;
-(UIView*) buildBgView:(UIColor*)color frame:(CGRect)rect;
-(UILabel*) buildLabel:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color;
/**
 *  图片添加手势
 */
-(UITapGestureRecognizer*) addTarget:(id)target action:(SEL)action;
/**
 *  弹提示框
 */
- (void)poptips:(NSString *)tips;
- (void)poptipsAtPos:(NSString *)tips pos:(CGPoint)pos;
- (void)poptips:(NSString *)tips fadeOut:(BOOL)fadeOut;
- (void)poptips:(NSString *)tips pos:(CGPoint)pos fadeOut:(BOOL)fadeOut;
/**
 *  http请求失败
 */
- (void)requsetFaild;
- (void)requestFaildWithError:(NSDictionary *)error;
- (void)requsetFaildWithTips:(NSString *)tips;

@end
