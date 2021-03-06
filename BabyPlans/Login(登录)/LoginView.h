//
//  LoginView.h
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString * const  kLoginSuccessNotification = @"loginSuccessNotification";

@class LoginView;

@protocol LoginViewDelegate <NSObject>

@optional
- (void)loginSuccess;
- (void)signUp;
- (void)cancleLogin;
/**
 *  注册或忘记密码
 */
- (void)forgetOrRegisterWithTag:(NSInteger)btnTag;
@end

@interface LoginView : UIView

@property (nonatomic,weak) id <LoginViewDelegate>delegate;

/**
 *  外部登录
 */
- (void)loginWithPhoneNum:(NSString *)phonenum passWord:(NSString *)password;
@end
