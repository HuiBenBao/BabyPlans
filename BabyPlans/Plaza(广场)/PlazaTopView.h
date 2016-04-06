//
//  PlazaTopView.h
//  BabyPlans
//
//  Created by apple on 16/4/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlazaTopView;

@protocol PlazaTopDelegate <NSObject>

@optional
/**
 *  滑动到第 index 页
 */
- (void)scrollToIndex:(NSInteger)index;

@end

@interface PlazaTopView : UIView

- (void)selectAtIndex:(NSInteger)index;

@property (nonatomic,weak) id <PlazaTopDelegate> delegate;

@end
