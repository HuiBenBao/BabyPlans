//
//  EditImageController.h
//  BabyPlans
//
//  Created by apple on 16/5/23.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditImageController;
@protocol EditImageDelegate <NSObject>

- (void)reloadImageWithArr:(NSArray *)imageArr;

@end

@interface EditImageController : UIViewController

@property (nonatomic,strong) NSArray * imageArr;
@property (nonatomic,weak) id <EditImageDelegate>delegate;


@end
