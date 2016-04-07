//
//  GalleryArrView.m
//  BabyPlans
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "GalleryArrView.h"
#import <AVFoundation/AVFoundation.h>

@interface GalleryArrView ()<AVAudioPlayerDelegate,UIScrollViewDelegate>


@property (nonatomic,strong) NSArray * galleryArr;

@property (nonatomic,strong) UIScrollView * imgScrollView;
/**
 *  播放器player
 */
@property (nonatomic,strong) AVAudioPlayer *avAudioPlayer;
/**
 *  播放进度
 */
@property (nonatomic,strong) UIProgressView *progressV;
/**
 *  声音控制
 */
@property (nonatomic,strong) UISlider *volumeSlider;
/**
 *  监控音频播放进度
 */
@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,assign) int currentIndex;

@end

@implementation GalleryArrView

- (void)setGalleryID:(NSString *)galleryID{

    _galleryID = galleryID;
    
    [self galleryArr];
}
- (NSArray *)galleryArr{

    if (!_galleryArr) {
        
        [CloudLogin getPictureArrWithGalleryID:self.galleryID success:^(NSDictionary *responseObject) {
            NSLog(@"图集===%@",responseObject);
            
            if ([responseObject[@"status"] intValue] == 0) {
                
                NSDictionary * galleryDic = responseObject[@"gallery"];
                
                if (ValidArray(galleryDic[@"pictures"])) {
                    NSArray * picArr = galleryDic[@"pictures"];
                    
                    NSMutableArray * dataArr = [NSMutableArray array];
                    for (NSDictionary * dic in picArr) {
                        GalleryImgModel * gallery = [GalleryImgModel valueWithDic:dic];
                        [dataArr addObject:gallery];
                    }
                    
                    _galleryArr = dataArr;
                    
                    [self createUI];
                }
            }
        } failure:^(NSError *errorMessage) {
            [self requsetFaild];
            NSLog(@"%@",errorMessage);
        }];
    }
    return _galleryArr;
}

- (instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {
        
//        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        
        self.imgScrollView = [[UIScrollView alloc] init];
        self.imgScrollView.delegate = self;
        
        [self addSubview:_imgScrollView];
        
    }
    
    return self;
}

- (void)createUI{

    self.imgScrollView.pagingEnabled = YES;
    self.imgScrollView.bounces = NO;
    self.imgScrollView.contentSize = CGSizeMake(self.width*self.galleryArr.count, 0);
    
    for (int i = 0; i < self.galleryArr.count; i++) {
        
        CGFloat imgW = self.width;
        CGFloat imgH = self.height;
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(imgW*i, 0, imgW, imgH)];
        
        GalleryImgModel * model = [self.galleryArr objectAtIndex:i];
        
        [imgView sd_setImageWithURL:[NSURL URLWithString:model.picture.image] placeholderImage:[UIImage imageNamed:@"allowDel"]];
        [self.imgScrollView addSubview:imgView];
    }
    
    //初始化音频类 并且添加播放文件
    self.avAudioPlayer = nil;
    //设置代理
    _avAudioPlayer.delegate = self;
    
    [self play];
}
//播放
- (void)play{
    
    CGFloat currentX = self.imgScrollView.contentOffset.x + self.width/2;
    int index = currentX/self.width;
    

    GalleryImgModel * model = [self.galleryArr objectAtIndex:index];
    
    if (model.picture.voice) {
        self.avAudioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.picture.voice]] error:nil];
        //设置代理
        _avAudioPlayer.delegate = self;
        
        [_avAudioPlayer play];
        
    }else{ //声音是空时,1秒后滑动到下一张
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self nextImage];
        });
    }
    
    
    
    
}
/**
 *  暂停
 */
- (void)pause{

    [_avAudioPlayer pause];
}
/**
 *  停止
 */
- (void)stop{
    
    _avAudioPlayer.currentTime = 0;  //当前播放时间设置为0
    [_avAudioPlayer stop];
}
- (void)layoutSubviews{

    [super layoutSubviews];

    self.imgScrollView.frame = self.bounds;
    
}
- (void)nextImage{

    CGFloat currentX = self.imgScrollView.contentOffset.x + self.width;
    
    CGFloat index = currentX/self.width;
    
    
    if (index>=self.galleryArr.count) {
        currentX = 0;
    }
    self.imgScrollView.contentOffset = CGPointMake(currentX, 0);
    
    if (currentX == 0) {
        [self stop];
        [self poptips:@"播放完成"];
    }else{
        [self play];
    }
}
#pragma ----mark-----UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{

    [self stop];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self play];
}
#pragma ---mark----AVAudioPlayerDelegate
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self nextImage];
    
}
@end
