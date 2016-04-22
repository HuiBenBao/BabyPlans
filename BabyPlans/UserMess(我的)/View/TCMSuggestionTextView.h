//
//  TCMSuggestionTextView.h
//  TCMHealth
//
//  Created by 12344 on 16/1/9.
//  Copyright © 2016年 XDTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCMSuggestionTextView : UITextView

- (instancetype)initWithFrame:(CGRect)frame andText:(NSString *)text;
@property (nonatomic,strong) UIButton * placeholder;

@end
