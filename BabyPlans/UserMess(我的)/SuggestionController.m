//
//  TCMSuggestionController.m
//  TCMHealth
//
//  Created by 12344 on 15/9/9.
//  Copyright (c) 2015年 XDTC. All rights reserved.
//

#import "SuggestionController.h"
#import "TCMSuggestionBtn.h"
#import "TCMSuggestionTextView.h"



@interface SuggestionController ()<UITextViewDelegate>

@property (nonatomic , strong) TCMSuggestionTextView * textView;


@end

@implementation SuggestionController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    self.view.backgroundColor = ColorI(0xefeff4);
    
    
    [self createUI];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back_to_mainpage"] style:UIBarButtonItemStylePlain target:self action:@selector(leftDrawerButtonPress:)];

    [self.textView becomeFirstResponder];
}
/**
 *  返回按钮点击方法
 */
-(void)leftDrawerButtonPress:(id)sender
{
    //返回主页
    [self.navigationController popViewControllerAnimated:YES];
    
    
}
/**
 *  界面创建方法
 */
- (void)createUI{
    NSString * str = @"请在此留下您宝贵的意见，您的每一个意见我们都会认真对待";
  
    
    
    //添加输入框
    CGFloat textY = MARGINX;
    CGFloat textH = 630*SCREEN_WIDTH_RATIO55/3;
    CGFloat textX = MARGINX;
    CGFloat textW = KScreenWidth - textX*2;
    
    
    
    _textView = [[TCMSuggestionTextView alloc] initWithFrame:CGRectMake(textX, textY, textW, textH) andText:str];

    _textView.delegate = self;
    
    UIView * bacV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, textY + textH)];
    bacV.backgroundColor = ColorI(0xffffff);
    
    //添加键盘上方按钮
    UIView *keyBoardTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 44*SCREEN_WIDTH_RATIO55)];
    
    keyBoardTopView.backgroundColor = [UIColor colorWithRed:200/255.0 green:203/255.0 blue:210/255.0 alpha:0.8];
    
    UIButton * finishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    finishBtn.frame = CGRectMake(KScreenWidth-50*SCREEN_WIDTH_RATIO55 ,0, 40*SCREEN_WIDTH_RATIO55, 44*SCREEN_WIDTH_RATIO55);
    
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    finishBtn.titleLabel.font = FONTBOLD_ADAPTED_WIDTH(18);
    [finishBtn setTitleColor:[UIColor colorWithRed:17/255.0 green:102/255.0 blue:254/255.0 alpha:1] forState:UIControlStateNormal];
    UIButton * clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(KScreenWidth*4/5, 0, KScreenWidth/5, keyBoardTopView.frame.size.height);
    
    [clickBtn addTarget:self action:@selector(onKeyBoardDown) forControlEvents:UIControlEventTouchUpInside];
    
    [keyBoardTopView addSubview:finishBtn];
    [keyBoardTopView addSubview:clickBtn];
    
    _textView.inputAccessoryView = keyBoardTopView;
    
    [bacV addSubview:_textView];
    [self.view addSubview:bacV];
    
    //添加提交按钮
    CGFloat gobtnY = textY+textH+150*SCREEN_WIDTH_RATIO55/3;
    CGFloat goBthX = MARGINX;
    CGFloat gobtnW = KScreenWidth - goBthX*2;
    CGFloat gobtnH = 147*SCREEN_WIDTH_RATIO55/3;
    
    UIButton * gobtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gobtn setTitle:@"提交" forState:UIControlStateNormal];
    gobtn.backgroundColor = ColorI(0x20afc4);
    
    
    gobtn.frame = CGRectMake(MARGINX, gobtnY, gobtnW, gobtnH);
    gobtn.titleLabel.font = FONT_ADAPTED_WIDTH(54/3);
    gobtn.layer.cornerRadius = 16*SCREEN_WIDTH_RATIO55/3;
    
    [gobtn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gobtn];
    
    
    //添加下方联系方式文字说明
    NSArray * titleArr = @[@"联系电话",@"010-51459381",@"客服QQ",@"5265131"];
    
    for (int i = 0; i < titleArr.count/2; i ++) {
        
        TCMSuggestionBtn * suggestionBtn = [TCMSuggestionBtn buttonWithType:UIButtonTypeCustom];
        
        CGFloat btnW = KScreenWidth/4;
        CGFloat btnH = btnW;
        CGFloat btnY = CGRectGetMaxY(gobtn.frame) + 250*SCREEN_WIDTH_RATIO55/3;
        CGFloat bthX = KScreenWidth/8 + (KScreenWidth/2)*i;
        
        suggestionBtn.frame = CGRectMake(bthX, btnY, btnW, btnH);
        
        suggestionBtn.mainLbl.text = titleArr[(titleArr.count/2)*i];
        suggestionBtn.detailLbl.text = titleArr[(titleArr.count/2)*i +1];
        if (i == 0) {
            [suggestionBtn.imgV setImage:[UIImage imageNamed:@"suggestion_Phone"]];
            [suggestionBtn addTarget:self action:@selector(suggesBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [suggestionBtn.imgV setImage:[UIImage imageNamed:@"suggestion_QQ"]];
        }
        
        [self.view addSubview:suggestionBtn];
    }
}
#pragma -----mark-----UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView{

    self.textView.placeholder.hidden = !([self.textView.text trim].length == 0);

}
#pragma ----mark----点击方法
/**
 *  提交按钮点击方法
 */
- (void)btnClick{

    //上传反馈意见
    NSString * str = [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (str.length==0) {
        
        [self.view poptips:@"提交内容不能为空"];
        
    } else {
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.dimBackground = YES;
        
        [CloudLogin SuggestWithContent:str Success:^(NSDictionary *responseObject) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                [self.view poptips:@"反馈成功"];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
        } failure:^(NSError *errorMessage) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            [self.view poptips:@"网络异常"];
        }];
    }
}
/**
 *  点击完成按钮隐藏键盘
 */
- (void)onKeyBoardDown{
    [_textView resignFirstResponder];
    
    
}
/**
 *  点击空白区域隐藏键盘
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

/**
 *  点击拨打电话
 */
- (void)suggesBtnClick:(TCMSuggestionBtn *)sender{

    UIAlertController *alertCtrl = [UIAlertController alertControllerWithTitle:sender.detailLbl.text message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        [self.textView becomeFirstResponder];
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"呼叫" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",sender.detailLbl.text]]];
    }];
    
    [alertCtrl addAction:cancelAction];
    [alertCtrl addAction:otherAction];
    [self presentViewController:alertCtrl animated:YES completion:nil];
    
}
@end
