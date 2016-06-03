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
// 根据url获取UIImage
+ (UIImage *)imageWithURLString:(NSString *)urlString{

    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [NSData dataWithContentsOfURL:url];
    // 这里并没有自动释放UIImage对象
    return [[UIImage alloc] initWithData:data];
}

+(NSData *)imageData:(UIImage *)myimage
{
    NSData *data=UIImageJPEGRepresentation(myimage, 1.0);
    if (data.length>=10*1024) {
        if (data.length>100*1024) {//100k以及以上
            data=UIImageJPEGRepresentation(myimage, 0.1);
        }else if (data.length>50*1024) {//50-100k
            data=UIImageJPEGRepresentation(myimage, 0.2);
        }else if (data.length>20*1024) {//20-50k
            data=UIImageJPEGRepresentation(myimage, 0.5);
        }else if (data.length>10*1024) {//10-20k
            data=UIImageJPEGRepresentation(myimage, 0.8);
        }
    }
    return data;
}
/**
 *  裁剪图片
 */
- (UIImage *)cutImageWithRect:(CGRect)rect{

    CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
    
    UIGraphicsBeginImageContext(smallBounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, smallBounds, subImageRef);
    UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    
    return smallImage;
}

@end
