//
//  OrginalController.m
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "OrginalController.h"

//#define OrginalURL @"http://m.bbjhart.com/nd.jsp?id=541#module12"
#define OrginalURL @"http://m.v.qq.com/x/vplus/baobeijihua?pt=5&ver=4.8.0.12072&ptag=4_4.8.0.12072_wxf"
@interface OrginalController ()<UIWebViewDelegate>

@property (nonatomic,strong) MBProgressHUD * hud;

@end

@implementation OrginalController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView * webView = [[UIWebView alloc]initWithFrame:self.view.bounds];

    webView.backgroundColor = [UIColor whiteColor];
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:OrginalURL]]];
    
    [self.view addSubview:webView];
    
    self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

#pragma ---mark-----UIWebViewDelegate
- (void)webViewDidFinishLoad:(UIWebView *)webView{

    [self.hud setHidden:YES];
}
@end
