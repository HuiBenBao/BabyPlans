//
//  PhotoViewController.h
//  照相机demo
//
//  Created by Jason on 11/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoViewControllerDelegate <NSObject>

@optional
- (void)updateVoice:(NSString *)voiceStr image:(UIImage *)image;

@end

@interface PhotoViewController : UIViewController
@property (nonatomic,strong) UIImage *image;

@property (nonatomic,weak) id <PhotoViewControllerDelegate>delegate;

@end
