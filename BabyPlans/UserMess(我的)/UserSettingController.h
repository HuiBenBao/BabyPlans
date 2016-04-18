//
//  UserSettingController.h
//  BabyPlans
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^Reload)(BOOL isReload);

@protocol UserSettingDelegate <NSObject>

@optional
- (void)loginOutAndReloadSuccess:(Reload)success;

@end

@interface UserSettingController : UIViewController

@property (nonatomic,weak) id <UserSettingDelegate>delegate;


@end
