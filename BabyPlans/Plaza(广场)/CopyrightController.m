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


@end

@implementation CopyrightController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"版权声明";
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _webView.backgroundColor = [UIColor whiteColor];
    
    NSURLRequest * request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.huibenyuanchuang.com/bbweb/copyright.html"]];
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}









@end
