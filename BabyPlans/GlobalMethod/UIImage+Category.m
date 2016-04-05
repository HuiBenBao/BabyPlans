//
//  UIImage+Category.m
//  baby
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 zhang da. All rights reserved.
//

#import "UIImage+Category.h"

@implementation UIImage (Category)


+ (UIImage *)imageAutomaticName:(NSString *)name {
    UIImage *image = [UIImage imageNamed:name];
    // 计算缩放率 - 3.0f是5.5寸屏的屏密度
    double scale = 3.0f / (SCREEN_WIDTH_RATIO55);
    return [UIImage imageWithCGImage:image.CGImage scale:scale orientation:UIImageOrientationUp];
}

//通过颜色来生成一个纯色图片
+ (UIImage *)imageWithColor:(UIColor *)color ImgSize:(CGRect)rect{
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end
