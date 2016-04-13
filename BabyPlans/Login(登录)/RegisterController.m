//
//  RegisterController.m
//  BabyPlans
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RegisterController.h"

@interface RegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *firstField;

@property (weak, nonatomic) IBOutlet UITextField *secondField;
@property (weak, nonatomic) IBOutlet UIButton *getCode;
@property (weak, nonatomic) IBOutlet UITextField *thirdField;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (strong,nonatomic) NSTimer *timer;
@property (nonatomic,assign) int downTime;

@end

@implementation RegisterController

- (void)viewWillAppear:(BOOL)animated{

    [UIApplication sharedApplication].statusBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.getCode.layer.cornerRadius = 8;
    self.getCode.clipsToBounds = YES;
    
    
}
- (IBAction)getCode:(UIButton *)sender {
    
    if (!ValidStr([self.firstField.text trim])) {
        [self.view poptips:@"请输入手机号"];
        [self.firstField becomeFirstResponder];
    } else if (![[self.firstField.text trim] isValidPhoneNo]) {
        [self.view poptips:@"手机号输入错误"];
        [self.firstField becomeFirstResponder];
    } else {
        // 获取验证码
//        _getCode.userInteractionEnabled = NO;
        _getCode.titleLabel.font = FONT_ADAPTED_WIDTH(30/3);
    
        [CloudLogin getCodeWithPhoneNum:[self.firstField.text trim] success:^(NSDictionary *responseObject) {
            
            NSLog(@"-----%@",responseObject);
            
            int code = [[responseObject objectForKey:@"status"] intValue];
            if (code == 0) {
            
                _getCode.selected = YES;
                
                //添加定时器
                [self addTimer];
                
                [self.secondField becomeFirstResponder];

                [self.view poptips:responseObject[@"code"]];
                
                
            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }

        } failure:^(NSError *errorMessage) {
            NSLog(@"-----%@",errorMessage);
            
            _getCode.userInteractionEnabled = YES;
            _getCode.titleLabel.font = FONT_ADAPTED_WIDTH(36/3);
            [self.view performSelector:@selector(requsetFaild) withObject:nil afterDelay:0.5];
        }];

    }
    

}

- (IBAction)popViewController:(id)sender {

    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  注册
 */
- (IBAction)registerBtnClick {
    
    
}

#pragma ------mark------倒计时实现方法
/**
 *  添加定时器
 */
- (void)addTimer{
    self.downTime = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

/**
 *  移除定时器
 */
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

/**
 *  倒计时方法
 */
- (void)countDown{
    _downTime--;
    if (_downTime <= 0) {
        self.getCode.selected = NO;
        _getCode.userInteractionEnabled = YES;
        [self removeTimer];
        [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
        _getCode.titleLabel.font = FONT_ADAPTED_WIDTH(36/3);
    } else {
        _getCode.userInteractionEnabled = NO;
        [_getCode setTitle:[NSString stringWithFormat:@"%ds后重新发送",_downTime]forState:UIControlStateNormal];
        _getCode.titleLabel.font = FONT_ADAPTED_WIDTH(30/3);
    }
}

@end
