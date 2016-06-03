//
//  UIImage+Category.h
//  baby
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 zhang da. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Category)

/**
 *  图片自适应
 *
 *  @param name 图片名字
 */
+ (UIImage *)imageAutomaticName:(NSString *)name;
/**
 *  根据颜色和尺寸来生成图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color ImgSize:(CGRect)rect;
/**
 *  根据URL获取图片
 */
+ (UIImage *)imageWithURLString:(NSString *)urlString;
/**
 *  将任意图片转化成小于10k的图
 */
+(NSData *)imageData:(UIImage *)myimage;
/**
 *  裁剪图片
 *
 *  @param rect 要裁剪的距形区域
 */
- (UIImage *)cutImageWithRect:(CGRect)rect;
@end
