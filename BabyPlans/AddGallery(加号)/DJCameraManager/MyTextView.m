//
//  MyTextView.m
//  BabyPlans
//
//  Created by apple on 16/4/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "MyTextView.h"

@implementation MyTextView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.placeholderLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        self.placeholderLabel.frame = CGRectMake(0, 0, self.frame.size.width, 50);
        if (self.text != nil) {
            self.placeholderLabel.hidden = YES;
        }else{
            self.placeholderLabel.hidden = NO;
        }
        
    }
    
    return self;
}
/**
 *  添加自定义placeholder,并实现点击隐藏
 */
- (void)setPlaceholderLabel:(UIButton *)placeholderLabel{
    
    _placeholderLabel = placeholderLabel;
    NSString * text = @"   请简单描述您本次发布的内容";
    [placeholderLabel setTitle:text forState:UIControlStateNormal];
    placeholderLabel.titleLabel.font = FONT_ADAPTED_WIDTH(48/3);
    
    placeholderLabel.titleLabel.numberOfLines = 2;
    
    placeholderLabel.alpha = 0.7;
    
    [placeholderLabel setTitleColor:ColorI(0x8b8b8b) forState:UIControlStateNormal];
    //设置行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:placeholderLabel.titleLabel.text];;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:2];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, placeholderLabel.titleLabel.text.length)];
    
    placeholderLabel.titleLabel.attributedText = attributedString;
    placeholderLabel.titleLabel.textAlignment = NSTextAlignmentNatural;
    [placeholderLabel setEnabled:YES];
    [placeholderLabel addTarget:self action:@selector(placeholderLabelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:placeholderLabel];
}

/**
 *  placeholderLabel点击方法
 */
- (void)placeholderLabelClick:(UIButton *)sender{
    
    if (sender.hidden == NO) {
        sender.hidden = YES;
    }
    //显示焦点光标
    [self becomeFirstResponder];
}


@end
