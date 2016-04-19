//
//  SlideCollectionViewCell.h
//  JR-Player
//
//  Created by 王潇 on 16/3/10.
//  Copyright © 2016年 王潇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SlideModel : NSObject

@property (nonatomic, strong) UIImage	*image;
@property (nonatomic, assign) CMTime	time;
- (instancetype)initWithImage:(UIImage *)image time:(CMTime)time;

@end


@interface SlideCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) SlideModel	*model;
@property (nonatomic, strong) NSString		*timeString;
@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com