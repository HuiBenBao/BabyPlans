//
//  CommentController.h
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentController : UIViewController{

    int recordEncoding;
    NSTimer *timerForPitch;

}

+ (instancetype)commentWithGalleryID:(NSString *)galleryID;
@end
