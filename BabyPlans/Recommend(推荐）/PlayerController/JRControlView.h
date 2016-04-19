//
//  JRControlView.h
//  JR-Player
//
//  Created by 王潇 on 16/3/9.
//  Copyright © 2016年 王潇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JRPlayerView;
@protocol JRControlViewDelegate <NSObject>
- (void)fullScreenDidSelected;
@end

@interface JRControlView : UIView
@property (nonatomic, weak)		JRPlayerView					*player;
@property (nonatomic, weak)		id<JRControlViewDelegate>		delegate;
@property (nonatomic, strong)	NSString						*title;
@property (nonatomic, assign)	BOOL							isShow;

// ---
- (void)openSlidView:(void(^)())action;

- (void)closeAllImgArray;

- (void)addControlBtn;

- (void)hiddenAllImageBtn;

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com