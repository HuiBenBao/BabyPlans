//
//  JRPlayerView.m
//  JR-Player
//
//  Created by 王潇 on 16/3/9.
//  Copyright © 2016年 王潇. All rights reserved.
//

#import "JRPlayerView.h"
#import "JRControlView.h"
#import <MediaPlayer/MediaPlayer.h>

// 滑动方向
typedef NS_ENUM(NSInteger, CameraMoveDirection) {
	kCameraMoveDirectionNone,
	kCameraMoveDirectionUp,
	kCameraMoveDirectionDown,
	kCameraMoveDirectionRight,
	kCameraMoveDirectionLeft,
};
CGFloat const gestureMinimumTranslation = 5.0 ;

@interface JRPlayerView () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIButton					*playControl;		// 播放控制按钮
@property (nonatomic, strong) UIActivityIndicatorView	*activity;			// 菊花
@property (nonatomic, strong) UIButton					*appearBtn;			// 开始播放按钮
@property (nonatomic, strong) CALayer					*imageLayer;		// 预览图片

@property (nonatomic, assign) BOOL						smallAppear;
@property (nonatomic, assign) BOOL						isAutoScreen;		//
@property (nonatomic, strong) NSTimer					*closeTimer;		//

@property (nonatomic, assign) CGRect					oldFrame;			// 小屏frame
@property (nonatomic, assign) CameraMoveDirection		direction;			// 方向
@property (nonatomic, assign) CGPoint					location;			// 开始位置
@property (nonatomic, assign) float						volume;				// 当前音量
@property (nonatomic, assign) CGFloat					brightness;			// 当前亮度
@property (nonatomic, assign) CGPoint					curretn;			// 实时位置
@end

#define STATUS_KEYPATH	@"status"
#define RATE_KEYPATH	@"rate"
#define LOAD_RANGE		@"loadedTimeRanges"

static const NSString *PlayerItemStatusContext;
static const NSString *PlayerItemRateContext;
@implementation JRPlayerView

- (instancetype)initWithFrame:(CGRect)frame
						image:(NSString *)imageUrl
						asset:(NSURL *)assetUrl {
	
	if (self = [super init]) {
		_imageUrl	= imageUrl;
		_assetUrl	= assetUrl;
		_oldFrame	= frame;
		self.frame	= frame;
		_asset		= [AVAsset assetWithURL:assetUrl];
		self.backgroundColor = [UIColor blackColor];
		[self setImage:imageUrl];
	}
	return self;
}


- (instancetype)initWithFrame:(CGRect)frame
						asset:(NSURL *)assetUrl {
	
	if (self = [super initWithFrame:frame]) {
		_assetUrl = assetUrl;
		_oldFrame = frame;
		_asset	  = [AVAsset assetWithURL:assetUrl];
		self.backgroundColor = [UIColor blackColor];
		[self prepareToPlay];
		[self addControlView];
		[self addPanGesture];
		[self addTapGesture];
	}
	
	return self;
}

- (instancetype)initWithURL:(NSURL *)assetURL {
	
	if (self = [super init]) {
		_asset = [AVAsset assetWithURL:assetURL];
		[self setView];
	}
	return self;
}

- (void)setImage:(NSString *)imageUrl {
	
	// 1. Image
	self.imageLayer = [CALayer layer];
	NSData *data	= [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
	UIImage *image	= [UIImage imageWithData:data];
	self.imageLayer.contents = (__bridge id _Nullable)([image CGImage]);
	[self.layer addSublayer:self.imageLayer];
	
	// 2. playBtn
	self.appearBtn	= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
	[self.appearBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
	[self addSubview:self.appearBtn];
	[self.appearBtn addTarget:self action:@selector(prepareToPlay) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setUrlString:(NSString *)urlString {
	_urlString = urlString;
	_asset = [AVAsset assetWithURL:[NSURL URLWithString:urlString]];
}

- (void)prepareToPlay {
	
	// 1. 获取属性
	NSArray *keys = @[
					  @"tracks",
					  @"duration",
					  @"commonMetadata",
					  @"availableMediaCharacteristicsWithMediaSelectionOptions",
					  @"presentationSize"
					  ];
	
	// 2. 创建 AVPlayerItem
	self.playerItem = [AVPlayerItem playerItemWithAsset:self.asset          // 2
						   automaticallyLoadedAssetKeys:keys];
	
	// 3. 监控播放状态
	[self.playerItem addObserver:self                                       // 3
					  forKeyPath:STATUS_KEYPATH
						 options:0
						 context:&PlayerItemStatusContext];
	
	// 4. 创建播放对象
	self.player		= [AVPlayer playerWithPlayerItem:self.playerItem];      // 4
	
	[self.player addObserver:self
				  forKeyPath:RATE_KEYPATH
					 options:0
					 context:&PlayerItemRateContext];
	
	[self.playerItem addObserver:self
					  forKeyPath:LOAD_RANGE
						 options:NSKeyValueObservingOptionNew context:nil];
	
	// 5. 添加到 View
	[(AVPlayerLayer *) [self layer] setPlayer:self.player];
	
	if (self.appearBtn) {
		[self.appearBtn removeFromSuperview];
	}
	
	
	[self play];
	[self setView];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context {

	if ([change[@"kind"] isEqualToNumber:[NSNumber numberWithInteger:1]]) {
		
		if (self.imageLayer) {
			[self.imageLayer removeFromSuperlayer];
		}
		
		if (self.smallControlView) {
			[self.smallControlView addControlBtn];
		}
	}
	
	if ([keyPath isEqualToString:LOAD_RANGE]) {
		
	}
	
	[self updateControlView];
}

- (void)setView {
	
	// 1. 播放控制
	// 2. 菊花
	self.activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
	[self addSubview:self.activity];
	
	//
	[self updateControlView];
}

- (void)updateControlView {
	
	self.activity.hidden = YES;
	self.playControl.hidden = YES;
	
	if (self.player.status != 1) {
		self.activity.hidden = NO;
		[self.activity startAnimating];
	} else if (self.player.status == 1) {
		
		if (self.player.rate == 0) {
			self.playControl.hidden = NO;
		} else {
			self.playControl.hidden = YES;
		}
	}
}

- (void)layoutSubviews {
	[super layoutSubviews];

	self.playControl.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
	self.activity.center	= CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
	self.appearBtn.center	= CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
	self.imageLayer.frame = self.bounds;
	
	if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait) {
		[self.smallControlView hiddenAllImageBtn];
	}
}

- (void)setFrame:(CGRect)frame {
	[super setFrame:frame];
	self.smallControlView.frame = self.bounds;
}

- (void)setTitle:(NSString *)title {
	_title = title;
	if (self.smallControlView) {
		self.smallControlView.title = title;
	}
}

#pragma mark - addPanGesture

- (void)addPanGesture {
	UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
																		  action:@selector(panAction:)];
	pan.delegate = self;
	[self addGestureRecognizer:pan];
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer {
	
	if (recognizer.state == UIGestureRecognizerStateBegan) {
		self.direction	= kCameraMoveDirectionNone;								// 无方向
		self.location	= [recognizer locationInView:self];						// 开始滑动位置
		self.volume		= self.player.volume;								// 获取当前音量
		self.brightness = [UIScreen mainScreen].brightness;						// 获取当前亮度
	}
	
	CGPoint translation = [recognizer translationInView:self];		// 事实移动位置 增量
	self.direction	= [self determineCameraDirectionIfNeeded:translation];
	self.curretn	= [recognizer locationInView:self];
	
	// 亮度/声音调节
	if (self.direction == 1 || self.direction == 2) {
		
		// 亮度
		if (self.location.x <= KScreenWidth) {
			
			float currentBrightness = self.brightness + ((self.location.y - self.curretn.y) / self.frame.size.height);
			if (currentBrightness <= 0 ) {
				currentBrightness = 0;
			} else if(currentBrightness >= 1) {
				currentBrightness = 1;
			}
			[UIScreen mainScreen].brightness = currentBrightness;
			// 声音
		} else if (self.location.x >= self.frame.size.width - KScreenWidth) {
			
			float currentVolume = self.volume + ((self.location.y - self.curretn.y) / self.frame.size.height);
			if (currentVolume <= 0 ) {
				currentVolume = 0;
			} else if(currentVolume >= 1) {
				currentVolume = 1;
			}
			
			
			
		}
		
		// 进度调节
	} else if(self.direction == 3 || self.direction == 4) {
		//		translation.x	移动偏移量
		//		velocity.x		移动速度
		
		NSLog(@"==== %@", NSStringFromCGPoint(self.curretn));
		if (self.curretn.y >= (self.bounds.size.height - 30)) {
			return;
		}
		
		CGFloat time		= 300;
		CGFloat speed		= time / self.frame.size.width;			// 移动快进速度

		long add			=  (long)(translation.x) *speed;
		
		CMTime currentTime	= self.player.currentTime;
		CMTime addTime		= CMTimeMake(add, 1);
		CMTime newTime		= CMTimeAdd(currentTime, addTime);
		if (recognizer.state == UIGestureRecognizerStateEnded) {

			if (CMTimeRangeContainsTime(CMTimeRangeMake(kCMTimeZero, self.playerItem.duration), newTime)) {
				[self.player seekToTime:newTime completionHandler:^(BOOL finished) {
				}];
			} else if (newTime.value <=0) {
				[self.player seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
				}];
			} else if ((newTime.value / newTime.timescale) >= (self.playerItem.duration.value / self.playerItem.duration.timescale)) {
				[self.player seekToTime:self.playerItem.duration completionHandler:^(BOOL finished) {
				}];
			}
		}
	}
}

// 获取方向
- ( CameraMoveDirection )determineCameraDirectionIfNeeded:( CGPoint )translation {
	
	if (self.direction != kCameraMoveDirectionNone)
		return self.direction;
	
	if (fabs(translation.x) > gestureMinimumTranslation) {
		
		BOOL gestureHorizontal = NO;
		if (translation.y == 0.0 )
			gestureHorizontal = YES;
		else
			gestureHorizontal = (fabs(translation.x / translation.y) > 5.0 );
		if (gestureHorizontal) {
			
			if (translation.x > 0.0 )
				return kCameraMoveDirectionRight;
			else
				return kCameraMoveDirectionLeft;
		}
	}
	else if (fabs(translation.y) > gestureMinimumTranslation)
		
	{
		BOOL gestureVertical = NO;
		if (translation.x == 0.0 )
			gestureVertical = YES;
		else
			gestureVertical = (fabs(translation.y / translation.x) > 5.0 );
		if (gestureVertical)
			
		{
			if (translation.y > 0.0 )
				
				return kCameraMoveDirectionDown;
			else
				return kCameraMoveDirectionUp;
		}
	}
	return self.direction;
}


#pragma maek - Private Methond
- (void)addTapGesture {
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
																		  action:@selector(sreenControl)];
	tap.delegate = self;
	[self addGestureRecognizer:tap];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {

	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UIImageView"]
		|| [NSStringFromClass([touch.view class]) isEqualToString:@"UIView"]
		|| [NSStringFromClass([touch.view class]) isEqualToString:@"UISlider"]) {
		return NO;
	}
	return YES;
}

- (void)sreenControl {
	if (self.isAutoScreen || self.smallControlView.hidden) return;
	if (self.smallAppear) {
		[self smallControlDisAppear];
	} else {
		[self smallControlAppear];
	}
}

- (void)addControlView {
	
	self.smallControlView = ({
		JRControlView *control	= [[JRControlView alloc] initWithFrame:self.bounds];
		control.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.0];
		control.alpha			= 0.0;
		control.player			= self;
		[self addSubview:control];
		control;
	});
}

- (void)smallControlAppear {
	if (self.smallControlView) {
		if (self.smallAppear == NO) {
			[UIView animateWithDuration:0.25 animations:^{
				self.smallControlView.alpha = 1.0;
			} completion:^(BOOL finished) {
				self.smallAppear = YES;
				
				[self addTimer];
			}];
		}
	}
}

- (void)smallControlDisAppear {
	if (self.smallControlView) {
		if (self.smallAppear == YES) {
			[self removeTimer];
			
			if (self.smallControlView.isShow) {
				__weak JRPlayerView *weekSelf = self;
				[self.smallControlView openSlidView:^{
					[UIView animateWithDuration:0.25 animations:^{
						weekSelf.smallControlView.alpha = 0.0;
					} completion:^(BOOL finished) {
						weekSelf.smallAppear = NO;
					}];
				}];
			} else {
				[UIView animateWithDuration:0.25 animations:^{
					self.smallControlView.alpha = 0.0;
				} completion:^(BOOL finished) {
					self.smallAppear = NO;
				}];
			}
			[self.smallControlView closeAllImgArray];
		}
	}
}

- (void)addTimer {
	self.closeTimer = [NSTimer timerWithTimeInterval:5
											  target:self
											selector:@selector(smallControlDisAppear)
											userInfo:nil
											 repeats:NO];
	[[NSRunLoop mainRunLoop] addTimer:self.closeTimer forMode:NSDefaultRunLoopMode];
}

- (void)removeTimer {
	if (self.closeTimer) {
		[self.closeTimer invalidate];
		self.closeTimer = nil;
	}
}

#pragma mark - THTransportDelegate Methods
- (void)playCont {
	
	if (self.player.rate == 0.0) {
		[self.player setRate:1.0];
	} else if (self.player.rate == 1.0) {
		[self.player setRate:0.0];
	}
	[self updateControlView];
}

- (void)play {
	[self.player play];
	NSLog(@"--------------------------------------------------------------------");
}

- (void)pause {
	[self.player pause];
}

- (void)dealloc {
	[self.playerItem removeObserver:self forKeyPath:STATUS_KEYPATH];
	[self.player removeObserver:self forKeyPath:RATE_KEYPATH];
	[self.playerItem removeObserver:self forKeyPath:LOAD_RANGE];
}

+ (Class)layerClass {                                                       // 2
	return [AVPlayerLayer class];
}


@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com