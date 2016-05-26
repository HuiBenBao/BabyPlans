//
//  LoginViewController.h
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginView.h"

@protocol LoginDelegate <NSObject>

@optional
- (void)reloadData;

@end

@interface LoginViewController : UIViewController

@property (nonatomic,weak) id <LoginDelegate>delegate;


@end
