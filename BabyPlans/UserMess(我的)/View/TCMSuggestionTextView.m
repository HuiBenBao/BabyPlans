//
//  TCMSuggestionTextView.m
//  TCMHealth
//
//  Created by 12344 on 16/1/9.
//  Copyright © 2016年 XDTC. All rights reserved.
//

#import "TCMSuggestionTextView.h"

@implementation TCMSuggestionTextView
- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text{
    
    if (self = [super initWithFrame:frame]) {
        CGSize size = textSizeFont(text, FONT_ADAPTED_WIDTH(44/3), KScreenWidth-30*SCREEN_WIDTH_RATIO55, MAXFLOAT);
        
        [self.placeholder setTitle:text forState:UIControlStateNormal];
        [self.placeholder setTitle:text forState:UIControlStateHighlighted];
        self.placeholder.frame = CGRectMake(0, 3*SCREEN_WIDTH_RATIO55, frame.size.width, size.height+2);
        [self setBtn:self.placeholder];
        
    }
    
    return self;
}
- (UIButton *)placeholder{

    if (!_placeholder) {
        _placeholder = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    
    return _placeholder;
}
/**
 *  添加自定义placeholder,并实现点击隐藏
 */
- (void)setBtn:(UIButton *)placeholder{
    
    _placeholder = placeholder;
    NSString * text = placeholder.currentTitle;
    [placeholder setTitle:text forState:UIControlStateNormal];
    placeholder.titleLabel.font = FONT_ADAPTED_WIDTH(44/3);
    
    
    placeholder.titleLabel.numberOfLines = 2;
    
    placeholder.alpha = 0.7;
    
    [placeholder setTitleColor:ColorI(0x8b8b8b) forState:UIControlStateNormal];
    
    
    if (!IOS9) {
        //设置行间距
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:placeholder.titleLabel.text];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
        [paragraphStyle setLineSpacing:2];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, placeholder.titleLabel.text.length)];
        
        placeholder.titleLabel.attributedText = attributedString;
    }
    
    placeholder.titleLabel.textAlignment = NSTextAlignmentNatural;
    [placeholder setEnabled:YES];
    [placeholder addTarget:self action:@selector(placeholderLabelClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:placeholder];
}

/**
 *  placeholderLabel点击方法
 */
- (void)placeholderLabelClick:(UIButton *)sender{
    
    //显示焦点光标
    [self becomeFirstResponder];
//    _placeholder.hidden = YES;
}

@end
