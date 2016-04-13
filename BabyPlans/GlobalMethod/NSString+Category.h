//
//  NSString+Category.h
//  BabyPlans
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Category)
/**
 *  去除两端的空格
 */
- (NSString *)trim;
/**
 *  是否是数字
 */
- (BOOL)isValidPhoneNo;

-(BOOL) grep:(NSString*)pattern options:(int)options;
- (NSString *)MD5String;
@end
