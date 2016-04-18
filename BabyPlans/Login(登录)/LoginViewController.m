//
//  LoginViewController.m
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginView.h"
#import "RegisterController.h"

@interface LoginViewController ()<LoginViewDelegate, RegisterControllerDelegate>

@property (nonatomic,strong) LoginView * loginView;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginView = [[LoginView alloc] initWithFrame:self.view.bounds];
    self.loginView.delegate = self;
    [self.view addSubview:_loginView];
    
    
    //添加监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

/**
 *  手机号，密码
 */
- (void)getInfoPhoneNum:(NSString *)phonenum passWord:(NSString *)password{
   
    if (self.loginView) {
        [self.loginView loginWithPhoneNum:phonenum passWord:password];
    }
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示

- (void)keyBoardWillShow:(NSNotification *)note{
    
//    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    CGFloat ty = - rect.size.height;
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
//    }];
    
    
    
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
//    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
//        self.view.transform = CGAffineTransformIdentity;
//    }];
    
    
}

#pragma -----mark------LoginViewDelegate

- (void)cancleLogin{

    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)forgetOrRegisterWithTag:(NSInteger)btnTag{

    RegisterController * VC = [[RegisterController alloc] init];
    
    VC.delegate = self;
    
    [self presentViewController:VC animated:YES completion:nil];
}
/**
 *  登录成功
 */
- (void)loginSuccess{

    [self dismissViewControllerAnimated:YES completion:^{
        if ([self.delegate respondsToSelector:@selector(reloadData)]) {
            [self.delegate reloadData];
        }
    }];
}
@end
