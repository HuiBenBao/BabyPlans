//
//  CustomSearchBar.m
//  BabyPlans
//
//  Created by apple on 16/6/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CustomSearchBar.h"

@implementation CustomSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.font = FONT_ADAPTED_WIDTH(42/3);
        self.placeholder = @"请输入关键字";
        [self setValue:ColorI(0x666666) forKeyPath:@"_placeholderLabel.textColor"];
        
        self.tintColor = ColorI(0x666666);
        self.background = [UIImage imageNamed:@"searBarTextBack"];
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self setBorderStyle:UITextBorderStyleNone];
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"main_search"];
        
        //        searchIcon.contentMode = UIViewContentModeScaleAspectFit;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.returnKeyType = UIReturnKeySearch;
        self.enablesReturnKeyAutomatically = YES;
    }
    return self;
}

+ (instancetype)searchBar
{
    return [[self alloc] init];
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += 13 + 62*SCREEN_WIDTH_RATIO55/3;
    
    return bounds;
}


- (CGRect)leftViewRectForBounds:(CGRect)bounds{
    
    bounds.origin.x = 10;
    bounds.size.width = 62.0*SCREEN_WIDTH_RATIO55/3;
    bounds.size.height = 62*SCREEN_WIDTH_RATIO55/3;
    bounds.origin.y = 6*SCREEN_WIDTH_RATIO55;
    
    return bounds;
}

@end
