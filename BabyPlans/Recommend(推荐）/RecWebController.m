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
                    @"http://babyproject.faisco.cn/h-nd-537-112_454.html",
                    @"http://m.ximalaya.com/zhubo/37358491",
                    @"http://babyproject.faisco.cn/h-nd-538-112_454.html",
                    @"http://babyproject.faisco.cn/h-nd-539-112_454.html"];
    }
    
    return _URLArr;
}
- (NSArray *)titleArr{

    if (!_titleArr) {
        _titleArr = @[@"美图绘本",@"嘉庆叔叔说绘本",@"欧洲绘本",@"丽丽老师讲绘本",@"日韩绘本",@"蝴蝶姐姐讲绘本"];
    }
    return _titleArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = Color(255, 253, 234);
    self.title = [self.titleArr objectAtIndex:self.index];
    
    if (_index == SecondBtn) {
        
    }else{
        UIWebView * webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        
        webView.backgroundColor = [UIColor whiteColor];
        self.HUD = [MBProgressHUD showHUDAddedTo:webView animated:YES];
        
        webView.delegate = self;
        
        NSInteger currentI = (_index>1) ? _index-1 : _index;
        
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.URLArr[currentI]]]];
        [self.view addSubview:webView];
        
    }
}

#pragma ----mark-----UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    self.HUD.hidden = YES;
}
@end
