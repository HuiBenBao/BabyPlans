//
//  CommentController.h
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol CommentControllerDelegate <NSObject>

- (void)reloadPlazaDataWithGalleryID:(NSString *)galleryID tabTag:(NSInteger)tabTag indexPath:(NSIndexPath*)indexPath;

@end

@interface CommentController : UIViewController{

    int recordEncoding;
    NSTimer *timerForPitch;

}

+ (instancetype)commentWithGalleryID:(NSString *)galleryID tabTag:(NSInteger)tabTag;

@property (nonatomic,weak) id <CommentControllerDelegate>delegate;
@property (nonatomic,strong) NSIndexPath * indexPath;



@end
