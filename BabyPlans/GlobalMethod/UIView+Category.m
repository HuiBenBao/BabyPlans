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
- (CGFloat)width{
    
    return self.frame.size.width;
}
- (CGFloat)right{

    return self.frame.origin.x + self.frame.size.width;
}

-(UIView*) buildBgView:(UIColor*)color frame:(CGRect)rect
{
    UIView* view=[[UIView alloc] initWithFrame:rect];
    view.backgroundColor=color;
    
    [self addSubview:view];
    return view;
}
-(UILabel*) buildLabel:(NSString*)str frame:(CGRect)frame font:(UIFont*)font color:(UIColor*)color
{
    UILabel* lab=[[UILabel alloc] initWithFrame:frame];
    lab.numberOfLines=0;
    [lab setText:str];
    lab.font=font;
    lab.textColor=color;
    lab.backgroundColor = [UIColor clearColor];
    //    lab.textAlignment=NSTextAlignmentCenter;
    [self addSubview:lab];
    return lab;
}
-(UITapGestureRecognizer*) addTarget:(id)target action:(SEL)action
{
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer* gesture=[[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    [self addGestureRecognizer:gesture];
    return gesture;
}

- (void)poptips:(NSString*)tips {
    [self poptipsAtPos:tips pos:CGPointMake(KScreenWidth/2, (KScreenHeight - 20)/2)];
    
}

- (void)poptipsAtPos:(NSString *)tips pos:(CGPoint)pos {
    [self poptips:tips pos:pos fadeOut:YES];
}

- (void)poptips:(NSString *)tips fadeOut:(BOOL)fadeOut {
    [self poptips:tips pos:CGPointMake(KScreenWidth/2, (KScreenHeight - 20)/2) fadeOut:fadeOut];
}

- (void)poptips:(NSString *)tips pos:(CGPoint)pos fadeOut:(BOOL)fadeOut {
    UIView *subview = [self viewWithTag:VIEW_TIPS_TAG];
    if (subview)	[subview removeFromSuperview];
    
    //	CGSize size=[tips sizeWithFont:Font(15) constrainedToSize:CGSizeMake(266, 100) lineBreakMode:NSLineBreakByWordWrapping];
    CGSize size= textSizeFont(tips, Font(15), 266, 100);
    UIView *bg=[self buildBgView:[UIColor blackColor] frame:CGRectMake(pos.x - size.width/2 - 12, pos.y - size.height/2 - 10, size.width + 29,  size.height+20)];
    [bg.layer setCornerRadius:5.0];
    bg.layer.masksToBounds=YES;
    UILabel *label = [bg buildLabel:tips frame:CGRectMake(15, 10, size.width, size.height) font:Font(15) color:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    
    bg.tag = VIEW_TIPS_TAG;
    
    
    if (fadeOut){

        [self performSelector:@selector(fadetips:) withObject:bg afterDelay:2];        
    }
}
-(void)fadetips:(UIView*)v
{
    if (v) {
        [v removeAllSubViews];
        [v removeFromSuperview];
        v=nil;
    }
}
-(void) removeAllSubViews
{
    for(UIView* view in self.subviews)
    {
        [view removeFromSuperview];
    }
}
#pragma mark --
#pragma mark http request fail methods
- (void)requsetFaild {
    [self poptips:@"网络异常，请稍候再试。"];
}

- (void)requestFaildWithError:(NSDictionary *)error {
    NSString *msg = [error objectForKey:@"message"];
    [self poptips:msg];
}

- (void)requsetFaildWithTips:(NSString *)tips {
    [self poptips:tips];
}
@end
