//
//  RecWebController.m
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "RecWebController.h"

#define SecondBtn 1

@interface RecWebController ()<UIWebViewDelegate>

@property (nonatomic,assign) NSInteger index;

@property (nonatomic, strong) MBProgressHUD * HUD;
@property (nonatomic,strong) NSArray * URLArr;
@property (nonatomic,strong) NSArray * titleArr;


@end

@implementation RecWebController

+ (instancetype)RecWebWithIndex:(NSInteger)index{

    return [[self alloc] initWithIndex:index];
}
- (instancetype)initWithIndex:(NSInteger)index{

    if (self = [self init]) {
        self.index = index;
    }
    return self;
}

- (NSArray *)URLArr{

    if (!_URLArr) {
        
        _URLArr = @[@"http://babyproject.faisco.cn/h-nd-536-112_454.html",
                    @"http://m.bbjhart.com/nd.jsp?id=545&from=groupmessage&isappinstalled=0",
                    @"http://babyproject.faisco.cn/h-nd-537-112_454.html",
                    @"http://m.bbjhart.com/nd.jsp?id=543&from=groupmessage&isappinstalled=0",
                    @"http://babyproject.faisco.cn/h-nd-538-112_454.html",
                    @"http://m.bbjhart.com/nd.jsp?id=541#module12"];
    }
    
    return _URLArr;
}
- (NSArray *)titleArr{

    if (!_titleArr) {
        _titleArr = @[@"父母",@"成长",@"情感",@"友情",@"自信",@"原创"];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color(255, 253, 234);
    self.title = [self.titleArr objectAtIndex:self.index];
    
   
    UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    webView.backgroundColor = [UIColor whiteColor];
    self.HUD = [MBProgressHUD showHUDAddedTo:webView animated:YES];
    
    webView.delegate = self;

    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLArr[_index]]]];
    [self.view addSubview:webView];
}

#pragma ----mark-----UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.HUD.hidden = YES;
}
@end
