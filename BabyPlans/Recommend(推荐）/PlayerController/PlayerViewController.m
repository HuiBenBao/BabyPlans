//
//  PlayerViewController.m
//  JR-Player
//
//  Created by 王潇 on 16/3/9.
//  Copyright © 2016年 王潇. All rights reserved.
//

#import "PlayerViewController.h"
#import "JRPlayerView.h"
#import "JRControlView.h"

#define CELL_H (KScreenWidth / 16 * 9 + 10)

@interface PlayerViewController () <JRControlViewDelegate>
@property (nonatomic, strong)JRPlayerView		*player;
@end

@implementation PlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	self.view.backgroundColor = [UIColor whiteColor];
	
	// status
	UIView *statusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
	statusView.backgroundColor = [UIColor blackColor];
	[self.view addSubview:statusView];
	
    self.player = [[JRPlayerView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, CELL_H)asset:[NSURL URLWithString:_videoModel.videoMain]];
	self.player.title = self.videoModel.title;
	[self.view addSubview:self.player];
	self.player.smallControlView.delegate = self;
	
	// 设置屏幕方向
	[self interfaceOrientation:UIInterfaceOrientationPortrait];
    //添加屏幕方向通知
    [self addNotification];
}

#pragma mark - JRControlViewDelegate, JRFullControlViewDelegate
- (void)fullScreenDidSelected {
	if (self.player.smallControlView) {
		if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
			[self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
		} else {
			[self interfaceOrientation:UIInterfaceOrientationPortrait];
		}
	}
}

- (void)closeFullScreen {
	if (self.player.fullControlView) {
//		[self.player getPortraitScreen];
		[self changeStatusOrientation:UIInterfaceOrientationPortrait];
		self.navigationController.navigationBar.hidden = NO;
	}
}

#pragma mark - Controller Methond
- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	//开启ios右滑返回
	if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
		self.navigationController.interactivePopGestureRecognizer.delegate = nil;
	}
	if (self.player) {
		[self.player play];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[self.player pause];
}

- (void)viewWillLayoutSubviews {
	[super viewWillLayoutSubviews];

	CGFloat playerH = self.view.bounds.size.width * 9 / 16;

	if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
		self.player.frame = CGRectMake(0, 64, self.view.bounds.size.width, playerH);
        self.navigationController.navigationBar.hidden = NO;
	} else {
		self.player.frame = CGRectMake(0, 0, self.view.bounds.size.width, playerH);
        self.navigationController.navigationBar.hidden = YES;

	}
	
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
}

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma - 屏幕屏幕方向

- (void)interfaceOrientation:(UIInterfaceOrientation)orientation {
	// arc下
	if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
		
		SEL selector = NSSelectorFromString(@"setOrientation:");
		NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
		[invocation setSelector:selector];
		[invocation setTarget:[UIDevice currentDevice]];
		int val = orientation;
		[invocation setArgument:&val atIndex:2];
		[invocation invoke];
	}
}

// 是否支持屏幕旋转
- (BOOL)shouldAutorotate {
	
	return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
	return UIInterfaceOrientationPortrait;
}

// 状态栏方向
- (void)changeStatusOrientation:(UIInterfaceOrientation)statusOrientation {
//	[[UIApplication sharedApplication] setStatusBarOrientation:statusOrientation];
}
// 添加屏幕方向通知
- (void)addNotification {
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(statusBarOrientationChange:)
												 name:UIDeviceOrientationDidChangeNotification
											   object:nil];
}

- (void)statusBarOrientationChange:(NSNotification *)notification {

	// 设备方向
	UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
	
	if (orientation == UIDeviceOrientationLandscapeRight) {						// 右全屏
//		[self.player getRightScreen];
		[self changeStatusOrientation:UIInterfaceOrientationLandscapeLeft];
//		[self interfaceOrientation:UIInterfaceOrientationLandscapeLeft];
		self.navigationController.navigationBar.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;

	}
	if (orientation == UIDeviceOrientationLandscapeLeft) {						// 左全屏
//		[self.player getLeftScreen];
		[self changeStatusOrientation:UIInterfaceOrientationLandscapeRight];
//		[self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
		self.navigationController.navigationBar.hidden = YES;
        [UIApplication sharedApplication].statusBarHidden = YES;

	}
	if (orientation == UIDeviceOrientationPortrait){							// 竖屏
//		[self.player getPortraitScreen];
		[self changeStatusOrientation:UIInterfaceOrientationPortrait];
		self.navigationController.navigationBar.hidden = NO;
//		[self interfaceOrientation:UIInterfaceOrientationPortrait];
        [UIApplication sharedApplication].statusBarHidden = NO;

	}
	if (orientation == UIDeviceOrientationFaceDown) {
	}
}

@end

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com