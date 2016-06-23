//
//  PhotoViewController.m
//  照相机demo
//
//  Created by Jason on 11/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//


#import "PhotoViewController.h"
#import <AVFoundation/AVFoundation.h>


#define BottomHeight 100*SCREEN_WIDTH_RATIO55

@interface PhotoViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,weak) UIButton * playBackBtn;


@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) AVAudioPlayer * audioPlayer;

@property (nonatomic,assign) int recordEncoding;
@property (nonatomic,strong) NSTimer * timerForPitch;
@property (nonatomic,strong) NSString * soundPath;
@property (nonatomic,assign) int currentTime;


@property (nonatomic,weak) UIImageView * changeView;
@property (nonatomic,weak) UIImageView * chageLittleView;

@end

@implementation PhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.image];
    imageView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    
    
    [self createBackBtn];
    [self createBottom];
    


}
- (void)createBackBtn{
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 64)];
    
    topView.backgroundColor = [UIColor blackColor];
    topView.alpha = 0.8;
    
    [self.view addSubview:topView];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(20, 20, 44, 44);
    [backBtn setTitle:@"返 回" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    [topView addSubview:backBtn];
    
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame = CGRectMake(KScreenWidth - 20 - 44, 20, 44, 44);
    [enterBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    [enterBtn addTarget:self action:@selector(updateVoice) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:enterBtn];

}
/**
 *  返回上一页
 */
- (void)backBtnClick{
    
    [self stop];
    [self stopRecording];
    [self dismissViewControllerAnimated:YES completion:nil];

}
/**
 *  点击确定按钮
 */
- (void)updateVoice{

    if (_soundPath == nil) {
        [self.view poptips:@"请添加声音"];
    }if (_currentTime < 3) {
        [self.view poptips:@"录音时间不能小于3秒"];
    }else{
    
        MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        hud.dimBackground = YES;
        
        [CloudLogin updatePictureWithImage:_image voiceLength:[NSString stringWithFormat:@"%d",_currentTime] uccess:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            int status = [responseObject[@"staus"] intValue];
            if (status == 0) {
                
                int imgID = [responseObject[@"pictureId"] intValue];
                
                if ([self.delegate respondsToSelector:@selector(updateImgID:image:)]) {
                    [self.delegate updateImgID:[NSString stringWithFormat:@"%d",imgID] image:self.image];
                    
                    [self dismissViewControllerAnimated:YES completion:^{
                        _soundPath = nil;
                        _currentTime = 0;
                    }];
                }

                
            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
        } failure:^(NSError *errorMessage) {
            
            hud.hidden = YES;
            [hud removeFromSuperview];
            UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"网络异常，请检查您的网络" message:nil preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction * enter = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self dismissViewControllerAnimated:YES completion:^{
                    _soundPath = nil;
                    _currentTime = 0;
                }];
            }];
            
            [alertVC addAction:enter];
            [self presentViewController:alertVC animated:YES completion:nil];
        }];
        
    }
}

- (void)createBottom{
    //存放底部三个按钮
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-BottomHeight, KScreenWidth, BottomHeight)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.8;
    
    [self.view addSubview:bottomView];
    
    /*  按钮取消，暂时隐藏
     *
    //分类按钮
    UIButton * classBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat classW = 60*SCREEN_WIDTH_RATIO55;
    CGFloat classH = classW;
    CGFloat classX = (KScreenWidth/3 - classW)/2;
    CGFloat classY = (BottomHeight - classH)/2;
    
    [classBtn setTitle:@"分类" forState:UIControlStateNormal];
    [classBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    classBtn.layer.cornerRadius = 8*SCREEN_WIDTH_RATIO55;
    classBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    classBtn.layer.borderWidth = 1;
    classBtn.clipsToBounds = YES;
    
    classBtn.frame = CGRectMake(classX, classY, classW, classH);
    [bottomView addSubview:classBtn];
    */
    
    //录音按钮
    UIButton * recordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat recordY = 10*SCREEN_WIDTH_RATIO55;
    CGFloat recordH = BottomHeight-recordY*2;
    CGFloat recordW = recordH;
    CGFloat recordX = (KScreenWidth-recordW)/2;
    
    recordBtn.frame = CGRectMake(recordX, recordY, recordW, recordH);
    
    [recordBtn setBackgroundImage:[UIImage imageNamed:@"addImg_playBtn"] forState:UIControlStateNormal];
    
    [recordBtn addTarget:self action:@selector(startRecord)
       forControlEvents:UIControlEventTouchDown];
    [recordBtn addTarget:self action:@selector(stopRecording)
       forControlEvents: UIControlEventTouchUpInside|UIControlEventTouchCancel];
    [recordBtn addTarget:self action:@selector(cancelRecord)
       forControlEvents:UIControlEventTouchUpOutside];

    
    [bottomView addSubview:recordBtn];
    
    //回放按钮
    UIButton * playBackBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat backW = 60*SCREEN_WIDTH_RATIO55;
    CGFloat backH = backW;
    CGFloat backY = (BottomHeight - backW)/2;
    CGFloat backX = KScreenWidth*2/3 + (KScreenWidth/3 -backW)/2;
    
    playBackBtn.frame = CGRectMake(backX, backY, backW, backH);
    [playBackBtn setTitle:@"回放" forState:UIControlStateNormal];
    [playBackBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    playBackBtn.layer.cornerRadius = 8*SCREEN_WIDTH_RATIO55;
    playBackBtn.layer.borderColor = [UIColor orangeColor].CGColor;
    playBackBtn.layer.borderWidth = 1;
    playBackBtn.clipsToBounds = YES;
    
    [playBackBtn addTarget:self action:@selector(playVoice:) forControlEvents:UIControlEventTouchUpInside];
    
    playBackBtn.frame = CGRectMake(backX, backY, backW, backH);
    
    self.playBackBtn = playBackBtn;
    [bottomView addSubview:playBackBtn];

}
#pragma ----mark-----播放

- (void)playVoice:(UIButton *)sender{

    sender.selected = !sender.selected;
    
    if (sender.selected) {
        [self play];
    }else{
        
        [self stop];
    }
    
}
/**
 *  播放
 */
- (void)play{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    NSError * error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:_soundPath] error:&error];
    
    self.audioPlayer.delegate = self;
    
    if (!error) {
        self.audioPlayer.numberOfLoops = 0;
        self.audioPlayer.volume = 1.0;
        [self.audioPlayer play];
    }else{
    
        [self.view poptips:@"未找到录音"];
        self.playBackBtn.selected = NO;
        
    }
}
/**
 *  暂停
 */
- (void)pause{
    
    [_audioPlayer pause];
}
/**
 *  停止
 */
- (void)stop{
    
    _audioPlayer.currentTime = 0;  //当前播放时间设置为0
    [_audioPlayer stop];
}

#pragma ----mark-----AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    NSLog(@"播放完成");
    self.playBackBtn.selected = NO;
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{

    self.playBackBtn.selected = NO;
    NSLog(@"播放出错");
}
#pragma ----mark-----录音
/**
 *  开始录音
 */
- (void)startRecord{
    
    self.audioRecorder = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"recordTest.caf"];
    
    self.soundPath = soundFilePath;
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    
    NSError *error = nil;
    
    //录音设置
    NSMutableDictionary *settings = [[NSMutableDictionary alloc] init];
    //录音格式 无法使用
    [settings setValue :[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey: AVFormatIDKey];
    //采样率
    [settings setValue :[NSNumber numberWithFloat:11025.0] forKey: AVSampleRateKey];//44100.0
    //通道数
    [settings setValue :[NSNumber numberWithInt:2] forKey: AVNumberOfChannelsKey];
    //线性采样位数
    //[recordSettings setValue :[NSNumber numberWithInt:16] forKey: AVLinearPCMBitDepthKey];
    //音频质量,采样质量
    [settings setValue:[NSNumber numberWithInt:AVAudioQualityMin] forKey:AVEncoderAudioQualityKey];

    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    _audioRecorder.meteringEnabled = YES;
    if ([_audioRecorder prepareToRecord] == YES){
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder record];
        
        _currentTime = 0;
        
        [self createChangeView];
        //定时器
        self.timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
        if (!self.changeView) {
            [self createChangeView];
        }

    }
    
}

/**
 *  时间监听
 */
- (void)levelTimerCallback:(NSTimer *)timer {
//    _currentTime++;

    [_audioRecorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [_audioRecorder averagePowerForChannel:0];
    
    if (decibels < minDecibels){
        level = 0.0f;
    }else if (decibels >= 0.0f){
        level = 1.0f;
    }else{
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    

    [UIView animateWithDuration:0.5 animations:^{
        
        CGRect littleF = self.chageLittleView.frame;
        littleF.size.height = (_changeView.height/2)*level+10*SCREEN_WIDTH_RATIO55;
        littleF.origin.y = _changeView.height/2 + 10 - littleF.size.height;
        
        self.chageLittleView.frame = littleF;
    }];
    
}

/**
 *  停止录音
 */
-(void) stopRecording {

    _currentTime = (int)_audioRecorder.currentTime;
    [_audioRecorder stop];
    
    self.changeView.hidden = YES;
    [self.changeView removeFromSuperview];
    self.changeView = nil;
}

- (void)cancelRecord{

    [_audioPlayer stop];
//    _audioPlayer = nil;
}

- (void)createChangeView{
    
    UIImageView * changeView = [[UIImageView alloc] initWithImage:[UIImage imageAutomaticName:@"voiceChangePic"]];
    
    changeView.center = self.view.center;
    self.changeView = changeView;
    
    UIImageView * littleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slider_left"]];
    CGFloat littleW = _changeView.frame.size.width/8;
    littleView.frame = CGRectMake((_changeView.width - littleW)/2, _changeView.height/2, littleW, 10);
    
    self.chageLittleView = littleView;
    
    [_changeView addSubview:littleView];
    [self.view addSubview:changeView];
    [self.view bringSubviewToFront:changeView];
}

@end
