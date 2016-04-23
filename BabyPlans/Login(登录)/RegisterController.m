//
//  RegisterController.m
//  BabyPlans
//
//  Created by apple on 16/4/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RegisterController.h"

#define GetCodeFont 18

@interface RegisterController ()

@property (weak, nonatomic)  UITextField *firstField;
@property (weak, nonatomic) UITextField *secondField;
@property (weak, nonatomic) UIButton *getCode;
@property (weak, nonatomic) UITextField *thirdField;
@property (weak, nonatomic) UIButton *registerBtn;

@property (strong,nonatomic) NSTimer *timer;
@property (nonatomic,assign) int downTime;



@end

@implementation RegisterController

- (void)viewWillAppear:(BOOL)animated{

    [UIApplication sharedApplication].statusBarHidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addTarget:self action:@selector(lostFirstResponse)];
    
    [self createView];
    
}

- (void)createView{

    
    UILabel * topLbl = [[UILabel alloc] init];
    
    CGFloat LblH = 64;
    topLbl.frame = CGRectMake(0, 0, KScreenWidth, LblH);
    topLbl.backgroundColor = ColorI(0xf26522);
    
    topLbl.text = (_type==0) ? @"找回密码" : @"注册";
    topLbl.textColor = ColorI(0xffffff);
    topLbl.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:topLbl];
    
    //返回按钮
    UIButton * backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    backBtn.frame = CGRectMake(0, 0, LblH, LblH);
    [backBtn setImage:[UIImage imageNamed:@"Back_to_mainpage@3x"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(popViewController:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    CGFloat textX = 40*SCREEN_WIDTH_RATIO55;
    CGFloat textW = KScreenWidth - textX*2;
    for (int i = 0; i < 3; i++) {
        
        CGFloat margic = 20*SCREEN_WIDTH_RATIO55;
        CGFloat textH = 50*SCREEN_WIDTH_RATIO55;
        CGFloat textY = CGRectGetMaxY(topLbl.frame) + 50*SCREEN_WIDTH_RATIO55 + (margic+textH)*i;
        
        if (i==1) {
            textW = (KScreenWidth-textX*2)/2;
            
            UIButton * getCode = [UIButton buttonWithType:UIButtonTypeCustom];
            
            CGFloat btnX = textX+textW+10*SCREEN_WIDTH_RATIO55;
            CGFloat btnW = KScreenWidth-textX - btnX;
            
            getCode.frame =CGRectMake(btnX, textY, btnW, textH);
            getCode.layer.cornerRadius = 10*SCREEN_WIDTH_RATIO55;
            getCode.layer.borderColor = ColorI(0xf26522).CGColor;
            getCode.layer.borderWidth = 1*SCREEN_WIDTH_RATIO55;
            getCode.clipsToBounds = YES;
            
            [getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
            [getCode setTitleColor:ColorI(0x8b8b8b) forState:UIControlStateNormal];
            [getCode addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
            getCode.backgroundColor = ColorI(0xeeeeee);
            
            getCode.titleLabel.font = FONT_ADAPTED_WIDTH(GetCodeFont);

            self.getCode = getCode;
            
            [self.view addSubview:getCode];
        }else{
            textW = KScreenWidth - textX*2;
        }
        
        UITextField * textField = [[UITextField alloc] init];
        textField.frame = CGRectMake(textX, textY,textW, textH);
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.textColor = ColorI(0x3b3b3b);
        textField.font = FONT_ADAPTED_WIDTH(18);
        
        if (i==0) {
            textField.placeholder = @"请输入手机号";
            textField.keyboardType = UIKeyboardTypePhonePad;
            self.firstField = textField;
        }else if (i==1){
            textField.placeholder = @"验证码";
            textField.keyboardType = UIKeyboardTypePhonePad;
            self.secondField = textField;
        }else if (i==2){
            textField.placeholder = (_type==0) ? @"新密码" : @"密码";
            self.thirdField = textField;
        }
        
        [self.view addSubview:textField];
    }
    
    UIButton * registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat reBtnH = 50*SCREEN_WIDTH_RATIO55;
    CGFloat reBtnY = CGRectGetMaxY(self.thirdField.frame) + 40*SCREEN_WIDTH_RATIO55;
    CGFloat reBtnW = textW;
    CGFloat reBtnX = textX;
    
    registerBtn.layer.cornerRadius = 10*SCREEN_WIDTH_RATIO55;
    registerBtn.clipsToBounds = YES;
    
    registerBtn.frame = CGRectMake(reBtnX, reBtnY, reBtnW, reBtnH);
    [registerBtn setTitleColor:ColorI(0xffffff) forState:UIControlStateNormal];
    
    NSString * title = (_type==0) ? @"确定" : @"注册";
    [registerBtn setTitle:title forState:UIControlStateNormal];
    registerBtn.backgroundColor = ColorI(0x20afc4);
    
    [registerBtn addTarget:self action:@selector(registerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:registerBtn];
}

- (void)getCode:(UIButton *)sender {
    
    if (!ValidStr([self.firstField.text trim])) {
        [self.view poptips:@"请输入手机号"];
        [self.firstField becomeFirstResponder];
    } else if (![[self.firstField.text trim] isValidPhoneNo]) {
        [self.view poptips:@"手机号输入错误"];
        [self.firstField becomeFirstResponder];
    } else {
        // 获取验证码
//        _getCode.userInteractionEnabled = NO;
        _getCode.titleLabel.font = FONT_ADAPTED_WIDTH(GetCodeFont);
    
        NSString * type = (_type==0) ? @"1" : @"0";
        [CloudLogin getCodeWithPhoneNum:[self.firstField.text trim] type:type success:^(NSDictionary *responseObject) {
            
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
            _getCode.titleLabel.font = FONT_ADAPTED_WIDTH(GetCodeFont);
            [self.view performSelector:@selector(requsetFaild) withObject:nil afterDelay:0.5];
        }];

    }
    

}

- (void)popViewController:(id)sender {

    [self lostFirstResponse];
    [self dismissViewControllerAnimated:YES completion:nil];
}
/**
 *  注册
 */
- (void)registerBtnClick {
    
    if (!ValidStr([self.firstField.text trim])) {
        [self.view poptips:@"请输入手机号"];
        [self.firstField becomeFirstResponder];
    } else if (![[self.firstField.text trim] isValidPhoneNo]) {
        [self.view poptips:@"手机号输入错误"];
        [self.firstField becomeFirstResponder];
    } else if (!ValidStr([self.secondField.text trim])) {
        [self.view poptips:@"请输入验证码"];
        [self.secondField becomeFirstResponder];
    } else if (![self loginTest]) {
        [self.view poptips:@"验证码格式错误"];
        [self.secondField becomeFirstResponder];
    } else if (!ValidStr([self.thirdField.text trim])) {
        [self.view poptips:@"请输入密码"];
        [self.thirdField becomeFirstResponder];
    } else{
        
        [CloudLogin registerWithPhoneNum:[self.firstField.text trim]
                                password:[self.thirdField.text trim]
                                    code:[self.secondField.text trim]
                                type:_type
                                 success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
            
            int status = [responseObject[@"status"] intValue];
            if (status==0) {
                
                if (_type==0) {
                    [self.view poptips:@"修改成功"];
                }else
                    [self.view poptips:@"注册成功"];
                
                if ([self.delegate respondsToSelector:@selector(getInfoPhoneNum:passWord:)]) {
                    [self.delegate getInfoPhoneNum:_firstField.text passWord:_thirdField.text];
                    [self popViewController:nil];
                }
                
            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
        } failure:^(NSError *errorMessage) {
            [self.view requsetFaild];
        }];
    }
    
}
/**
 *  对验证码内容进行检测
 */
- (BOOL)loginTest {
    BOOL isValid = NO;
    
    NSString *code = [self.secondField.text trim];
    if (ValidStr(code) && code.length == 6 && [code isNumber]) {
        isValid = YES;
    }
    
    return isValid;
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
        _getCode.titleLabel.font = FONT_ADAPTED_WIDTH(GetCodeFont);
    } else {
        _getCode.userInteractionEnabled = NO;
        [_getCode setTitle:[NSString stringWithFormat:@"%ds后重新发送",_downTime]forState:UIControlStateNormal];
        _getCode.titleLabel.font = FONT_ADAPTED_WIDTH(GetCodeFont);
    }
}
/**
 *  键盘消失
 */
- (void)lostFirstResponse{

    [self.firstField resignFirstResponder];
    [self.secondField resignFirstResponder];
    [self.thirdField resignFirstResponder];
}


@end
