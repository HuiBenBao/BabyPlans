//
//  PhotoViewController.m
//  照相机demo
//
//  Created by Jason on 11/1/16.
//  Copyright © 2016年 Jason. All rights reserved.
//

enum
{
    ENC_AAC = 1,
    ENC_ALAC = 2,
    ENC_IMA4 = 3,
    ENC_ILBC = 4,
    ENC_ULAW = 5,
    ENC_PCM = 6,
} encodingTypes;


#import "PhotoViewController.h"
#import "UIButton+DJBlock.h"
#import <AVFoundation/AVFoundation.h>
#import "SCListener.h"

#define BottomHeight 100*SCREEN_WIDTH_RATIO55

@interface PhotoViewController ()<AVAudioPlayerDelegate>

@property (nonatomic,weak) UIButton * playBackBtn;


@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) AVAudioPlayer * audioPlayer;

@property (nonatomic,strong) NSData * mp3;

@property (nonatomic,assign) int recordEncoding;
@property (nonatomic,strong) NSTimer * timerForPitch;
@property (nonatomic,strong) NSString * soundPath;
@property (nonatomic,assign) int currentTime;


@property (nonatomic,weak) UIImageView * changeView;

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
    __weak typeof(self) weak = self;
    [backBtn addActionBlock:^(id sender) {
        [weak dismissViewControllerAnimated:YES completion:nil];
    } forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    enterBtn.frame = CGRectMake(KScreenWidth - 20 - 44, 20, 44, 44);
    [enterBtn setTitle:@"确 定" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor yellowColor] forState:UIControlStateNormal];
    
    [enterBtn addTarget:self action:@selector(updateVoice) forControlEvents:UIControlEventTouchUpInside];
    
    [topView addSubview:enterBtn];

}

- (void)updateVoice{

    if (_soundPath == nil) {
        [self.view poptips:@"请添加声音"];
    }else{
    
        if ([self.delegate respondsToSelector:@selector(updateVoice:image:)]) {
            [self.delegate updateVoice:_soundPath image:self.image];
            
            [self dismissViewControllerAnimated:YES completion:^{
                _soundPath = nil;
            }];
        }
    }
}

- (void)createBottom{
    //存放底部三个按钮
    UIView * bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight-BottomHeight, KScreenWidth, BottomHeight)];
    bottomView.backgroundColor = [UIColor blackColor];
    bottomView.alpha = 0.8;
    
    [self.view addSubview:bottomView];
    
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
    
    CGFloat backW = classW;
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
    
    
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] initWithCapacity:10];
    if(_recordEncoding == ENC_PCM)
    {
        [recordSettings setObject:[NSNumber numberWithInt: kAudioFormatLinearPCM] forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
        [recordSettings setObject:[NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
    }else{
        NSNumber *formatObject;
        
        switch (_recordEncoding) {
            case (ENC_AAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatMPEG4AAC];
                break;
            case (ENC_ALAC):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleLossless];
                break;
            case (ENC_IMA4):
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
                break;
            case (ENC_ILBC):
                formatObject = [NSNumber numberWithInt: kAudioFormatiLBC];
                break;
            case (ENC_ULAW):
                formatObject = [NSNumber numberWithInt: kAudioFormatULaw];
                break;
            default:
                formatObject = [NSNumber numberWithInt: kAudioFormatAppleIMA4];
        }
        
        [recordSettings setObject:formatObject forKey: AVFormatIDKey];
        [recordSettings setObject:[NSNumber numberWithFloat:44100.0] forKey: AVSampleRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
        [recordSettings setObject:[NSNumber numberWithInt:12800] forKey:AVEncoderBitRateKey];
        [recordSettings setObject:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
        [recordSettings setObject:[NSNumber numberWithInt: AVAudioQualityHigh] forKey: AVEncoderAudioQualityKey];
    }
    
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"recordTest.caf"];
    
    self.soundPath = soundFilePath;
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    
    NSError *error = nil;
    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:recordSettings error:&error];
    _audioRecorder.meteringEnabled = YES;
    if ([_audioRecorder prepareToRecord] == YES){
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder record];
        
        _currentTime = 0;
        //定时器
        self.timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        //声音监听
        [[SCListener sharedListener] listen];
        
        if (!self.changeView) {
            [self createChangeView];
        }

    }
    
}

/**
 *  时间监听
 */
- (void)levelTimerCallback:(NSTimer *)timer {
    _currentTime++;
    
    Float32 voice = [[SCListener sharedListener] averagePower];
    
    CGRect chanF = self.changeView.frame;
    chanF.origin.y = voice;
    
    [UIView animateWithDuration:0.1 animations:^{
        self.changeView.frame = chanF;
    }];
    
}

/**
 *  停止录音
 */
-(void) stopRecording {
    
    [_audioRecorder stop];
    
    
}

- (void)cancelRecord{

    [_audioPlayer stop];
//    _audioPlayer = nil;
}

- (void)createChangeView{
    
    UIImageView * changeView = [[UIImageView alloc] initWithImage:[UIImage imageAutomaticName:@"voiceChangePic"]];
    
    changeView.center = self.view.center;
    self.changeView = changeView;
    
    [self.view addSubview:changeView];
    [self.view bringSubviewToFront:changeView];
}

@end
