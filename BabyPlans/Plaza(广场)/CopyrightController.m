//
//  CopyrightController.m
//  BabyPlans
//
//  Created by 宝贝计画 on 16/6/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CopyrightController.h"

@interface CopyrightController ()

@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) NSString * type;


@end

@implementation CopyrightController

+ (instancetype)copyControllerWithType:(NSString *)type{

    CopyrightController * VC = [[CopyrightController alloc] init];
    VC.type = type;
    return VC;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString * title;
    NSString * webUrl;
    switch ([self.type intValue]) {
        case 0:
            title = @"使用说明";
            webUrl = @"http://www.huibenyuanchuang.com/bbweb/process.html";
            break;
        case 1:
            title = @"审核标准";
            webUrl = @"http://www.huibenyuanchuang.com/bbweb/standard.html";
            break;
        case 2:
            title = @"版权声明";
            webUrl = @"http://www.huibenyuanchuang.com/bbweb/copyright.html";
            break;
        default:
            break;
    }
    self.title = title;
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _webView.backgroundColor = [UIColor whiteColor];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:webUrl]];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}









@end
