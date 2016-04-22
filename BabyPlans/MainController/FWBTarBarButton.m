//
//  FWBTarBarButton.m
//  彩票
//
//  Created by User on 15/7/31.
//  Copyright (c) 2015年 User. All rights reserved.
//

#import "FWBTarBarButton.h"

@implementation FWBTarBarButton

- (id)initWithFrame:(CGRect)frame{
 
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}
/**
 *  只要覆盖这个方法，按钮高亮状态就不存在
 */
- (void)setHighlighted:(BOOL)highlighted{

}
- (void)drawRect:(CGRect)rect{

    [super drawRect:rect];
    
    if (self.currentTitle != nil) {
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        self.imageEdgeInsets = UIEdgeInsetsMake(-18*SCREEN_WIDTH_RATIO55,0, 0, -19*SCREEN_WIDTH_RATIO55);
        self.titleEdgeInsets = UIEdgeInsetsMake(32*SCREEN_WIDTH_RATIO55, -rect.size.width/2, 0, 0);

    }
    
}
@end
