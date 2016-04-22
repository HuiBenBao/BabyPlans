//
//  GuideViewController.m
//  TCMHealth
//
//  Created by 12344 on 15/10/18.
//  Copyright © 2015年 XDTC. All rights reserved.
//

#import "GuideViewController.h"
#import "ABCIntroView.h"
#import "AppDelegate.h"
#import "RootTabBarController.h"

@interface GuideViewController ()<ABCIntroViewDelegate>

@property (strong ,nonatomic) ABCIntroView * introView;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.introView = [[ABCIntroView alloc] initWithFrame:self.view.frame];
    self.introView.delegate = self;
    self.introView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.introView];

    
    
}
#pragma mark - ABCIntroViewDelegate Methods

-(void)onDoneButtonPressed{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.introView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self.introView removeFromSuperview];
        
        [defaults setValue:@"1" forKey:@"isFirstComeIn"];
        
        UIStoryboard *storyboard=[UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        //2.下面这个方法代表着创建storyboard中箭头指向的控制器（初始控制器）
        RootTabBarController *controller=[storyboard instantiateInitialViewController];
        
        
        
        //时间栏样式
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UIApplication sharedApplication].statusBarHidden = NO;
        
        //3.设置控制器为Window的根控制器

        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        delegate.window.rootViewController=controller;
        

    }];
}

@end
