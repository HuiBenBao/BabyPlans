//
//  AddPicScrollView.h
//  BabyPlans
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol AddPicScrollViewDelegate <NSObject>

@optional
- (void)addPictureBtnClick;

@end

@interface AddPicScrollView : UIScrollView

- (void)addPicture:(UIImage *)img voice:(NSString *)voice;

@property (nonatomic,weak) id <AddPicScrollViewDelegate>picDelegate;

@end
