//
//  UIView+Category.m
//  BabyPlans
//
//  Created by apple on 16/4/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIView+Category.h"

@implementation UIView (Category)

- (CGFloat)bottom{

    return self.frame.origin.y + self.frame.size.height;
}
- (CGFloat)height{

    return self.frame.size.height;
}
@end
