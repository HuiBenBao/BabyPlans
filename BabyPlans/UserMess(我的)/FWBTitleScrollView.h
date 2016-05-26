//
//  TCMTitleScrollView.h
//  TCMHealth
//
//  Created by xdtc on 15/8/19.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FWBTitleScrollView;
@protocol FWBTitleScrollDelegate <NSObject>

// 点击标题按钮
- (void)clickTitleButton:(UIButton *)btn;

@end

@interface FWBTitleScrollView : UIView

@property (nonatomic,strong) UIView * scrollBar;
@property (nonatomic,strong,readonly) NSArray * btnArr;

@property (nonatomic,weak) id <FWBTitleScrollDelegate>delegate;

@end
