//
//  LoginView.m
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoginView.h"
#import <ShareSDK/ShareSDK.h>
@interface LoginView ()

@property (nonatomic,strong) UIImageView * logoView;

@property (nonatomic,weak) UITextField * phoneField;
@property (nonatomic,weak) UITextField * passwordField;

@property (nonatomic,strong) UIButton * signBtn;

@end

@implementation LoginView

- (UIImageView *)logoView{

    if (!_logoView) {
        _logoView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appLogo"]];
        
        CGFloat imgW = self.width/3;
        CGFloat imgH = imgW;
        CGFloat imgY = 50*SCREEN_WIDTH_RATIO55;
        CGFloat imgX = (self.width-imgW)/2;
        
        _logoView.frame = CGRectMake(imgX, imgY, imgW, imgH);
    }
    
    return _logoView;
}

- (UIButton *)signBtn{

    if (!_signBtn) {
        _signBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _signBtn.layer.cornerRadius = 10*SCREEN_WIDTH_RATIO55;
        _signBtn.clipsToBounds = YES;
        [_signBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_signBtn addTarget:self action:@selector(signClick:) forControlEvents:UIControlEventTouchUpInside];
        _signBtn.backgroundColor = ColorI(0x23dead);
    }
    
    return _signBtn;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = ViewBackColor;
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LoginBackView"]];
        
        
        //添加logo
        [self addSubview:self.logoView];
        
        //添加输入框
        [self addTextField];
        
        [self addTapGesture];
    }
    
    return self;
}
/**
 *  添加输入框
 */
- (void)addTextField{

    //输入框
    CGFloat txtBackH = 80*SCREEN_WIDTH_RATIO55;
    CGFloat txtBackW = 300*SCREEN_WIDTH_RATIO55;
    CGFloat txtBackY = self.logoView.bottom + 50*SCREEN_WIDTH_RATIO55;
    CGFloat txtBackX = (self.width - txtBackW)/2;
    
    UIView * txtBackV = [[UIView alloc] initWithFrame:CGRectMake(txtBackX, txtBackY, txtBackW, txtBackH)];
    
    txtBackV.backgroundColor = [UIColor whiteColor];
    txtBackV.layer.cornerRadius = 10*SCREEN_WIDTH_RATIO55;
    txtBackV.clipsToBounds = YES;
    txtBackV.layer.borderWidth = 1*SCREEN_WIDTH_RATIO55;
    txtBackV.layer.borderColor = ColorI(0xdddddd).CGColor;
    
    
    [self addSubview:txtBackV];
    
    int count = 2;
    for (int i = 0; i < count; i ++) {
        
        CGFloat textH = (txtBackH-1)/2;
        CGFloat textY = (textH+1)*i;
        CGFloat textX = 10*SCREEN_WIDTH_RATIO55;
        CGFloat textW = txtBackW-textX;
        
        UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(textX, textY, textW, textH)];
        
        //            textField.borderStyle = UITextBorderStyleNone;
        
        textField.textColor = ColorI(0x3b3b3b);
        textField.font = FONT_ADAPTED_NUM(14);
        
        
        textField.tag = i;
        if (i==0) {
            self.phoneField = textField;
            textField.placeholder = @"手机号";
            textField.keyboardType = UIKeyboardTypePhonePad;
        }else{
            textField.placeholder = @"密码";
            textField.secureTextEntry = YES;
            self.passwordField = textField;
        }
        
        [txtBackV addSubview:textField];
    }
    
    //中间分割线
    [txtBackV buildBgView:ColorI(0xdddddd) frame:CGRectMake(0, txtBackH/2-0.5, txtBackW, 1)];
    
    //登录按钮
    CGFloat signW = txtBackW;
    CGFloat signH = txtBackH/2;
    CGFloat signY = txtBackV.bottom + 30*SCREEN_WIDTH_RATIO55;
    
    self.signBtn.frame = CGRectMake(txtBackX, signY, signW, signH);
    
    [self addSubview:_signBtn];
    
    //忘记密码和注册按钮
    CGFloat maxY = self.signBtn.bottom;
    
    NSArray * titleArr = @[@"忘记密码",@"注册"];
    for (int i = 0; i < titleArr.count; i++) {
        UIButton * littleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        littleBtn.tag = i;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:titleArr[i]];
        NSRange strRange = {0,[str length]};
        [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
        [str addAttribute:NSFontAttributeName value:FONT_ADAPTED_NUM(12) range:strRange];
        [str addAttribute:NSForegroundColorAttributeName value:ColorI(0x3b3b3b) range:strRange];
        
        [littleBtn setAttributedTitle:str forState:UIControlStateNormal];
        
        CGSize btnSize = textSizeFont(titleArr[i], FONT_ADAPTED_NUM(14), MAXFLOAT, MAXFLOAT);
        CGFloat btnW = btnSize.width;
        CGFloat btnX = (i == 0) ? _signBtn.frame.origin.x : CGRectGetMaxX(_signBtn.frame)-btnW-5;
        CGFloat btnY = _signBtn.bottom + 10*SCREEN_WIDTH_RATIO55;
        CGFloat btnH = btnSize.height+15;
        
        littleBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
        [littleBtn addTarget:self action:@selector(littleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:littleBtn];
        
        maxY = littleBtn.bottom;
    }
    
    //第三方登录
    NSArray * loginTypeArr = @[@"新浪登录",@"微信登录",@"QQ登录"];
    
    for (int i = 0; i < loginTypeArr.count; i++) {
        
        UIButton * customBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGFloat margic = 20*SCREEN_WIDTH_RATIO55;
        CGFloat btnW = (txtBackW - (loginTypeArr.count-1)*margic)/loginTypeArr.count;
        CGFloat btnX = txtBackX + (btnW + margic)*i;
        CGFloat btnY = maxY + 40*SCREEN_WIDTH_RATIO55;
        CGFloat btnH = btnW;
        
        customBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
     
        customBtn.titleLabel.font = FONT_ADAPTED_NUM(11);
        [customBtn setTitleColor:ColorI(0x5b5b5b) forState:UIControlStateNormal];
        [customBtn setTitle:loginTypeArr[i] forState:UIControlStateNormal];
        [customBtn addTarget:self action:@selector(customBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        customBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, -btnH/2, 0);
        [customBtn setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"signUpImg%d",i]] forState:UIControlStateNormal];
        
        [self addSubview:customBtn];
        
        if (i==loginTypeArr.count-1) {
            maxY = customBtn.bottom;
        }
        

    }
    
    //取消登录
    UIButton * cancle = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat cancleW = txtBackW/2;
    CGFloat cancleH = signH;
    CGFloat cancleY = (KScreenHeight - maxY - cancleH)/2 + maxY;
    CGFloat cancleX = txtBackX + (txtBackW - cancleW)/2;
    
    cancle.frame = CGRectMake(cancleX, cancleY, cancleW, cancleH);
    
    cancle.backgroundColor = Color(246, 252, 254);
    
    [cancle setTitle:@"取 消 登 录" forState:UIControlStateNormal];
    
    cancle.layer.cornerRadius = 8;
    cancle.clipsToBounds = YES;
    cancle.titleLabel.font = FONT_ADAPTED_NUM(14);
    [cancle setTitleColor:ColorI(0x4b4b4b) forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:cancle];
    
    
}

- (void)customBtnClick:(UIButton *)sender{
    if (sender.tag == 0) {
        [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
            if (state == SSDKResponseStateSuccess) {
                NSLog(@"uid=%@",user.uid);
                NSLog(@"%@",user.credential);
                NSLog(@"token=%@",user.credential.token);
                NSLog(@"nickname=%@",user.nickname);
            } else
            {
                NSLog(@"%@",error);
            }

        }];
    }
    if (sender.tag == 1) {
        
        [ShareSDK getUserInfo:SSDKPlatformTypeWechat
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
             }
             else
             {
                 NSLog(@"%@",error);
             }
         }];
        
    }


    if (sender.tag == 2) {
        
        [ShareSDK getUserInfo:SSDKPlatformTypeQQ
               onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
         {
             if (state == SSDKResponseStateSuccess)
             {
                 NSLog(@"uid=%@",user.uid);
                 NSLog(@"%@",user.credential);
                 NSLog(@"token=%@",user.credential.token);
                 NSLog(@"nickname=%@",user.nickname);
             }
             else
             {
                 NSLog(@"%@",error);
             }
         }];

    }
    
}




/**
 *  添加手势
 */
- (void)addTapGesture{

    //设置手势点击空白区域隐藏键盘
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self addGestureRecognizer:tapGestureRecognizer];

}
- (void)keyboardHide:(UITapGestureRecognizer *)tap{

    [self.phoneField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}
/**
 *  登录
 */
- (void)signClick:(UIButton *)button{
    
    [CloudLogin loginWithPhoneNum:[self.phoneField.text trim] password:[self.passwordField.text trim] success:^(NSDictionary *responseObject) {
        NSLog(@"%@",responseObject);
        
        int status = [responseObject[@"status"] intValue];
        if (status==0) {
            [self poptips:@"登录成功"];
            
            //存入本地
            NSDictionary * sessionDic = responseObject[@"session"];
            Session * session = [Session shareSession];
            [session setValueWithDic:sessionDic];
            
            [defaults setObject:session.userId forKey:@"token"];
            [defaults setObject:session.sessionID forKey:@"session"];
            if ([self.delegate respondsToSelector:@selector(loginSuccess)]) {
                [self.delegate loginSuccess];
            }
        }else{
        
            [self poptips:responseObject[@"error"]];
            
        }
    } failure:^(NSError *errorMessage) {
        NSLog(@"%@",errorMessage);
    }];
    
}
/**
 *  注册或忘记密码
 */
- (void)littleBtnClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(forgetOrRegisterWithTag:)]) {
        [self.delegate forgetOrRegisterWithTag:button.tag];
    }
}
/**
 *  取消登录
 */
- (void)cancleBtnClick{

    if ([self.delegate respondsToSelector:@selector(cancleLogin)]) {
        [self.delegate cancleLogin];
    }
}

@end
