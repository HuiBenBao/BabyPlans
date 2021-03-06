//
//  CommentController.m
//  BabyPlans
//
//  Created by apple on 16/4/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "CommentController.h"
#import "CommentCell.h"
#import <AVFoundation/AVFoundation.h>



#define TEXTVIEW_HEIGHT (60*SCREEN_WIDTH_RATIO55)


@interface CommentController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,AVAudioPlayerDelegate,CommentCellDelegate>

@property (nonatomic,strong) NSString * galleryID;
@property (nonatomic,assign) NSInteger tabTag;

@property (nonatomic,strong) NSArray * dataArr;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) UITextField * messageField;
//说话按钮
@property (nonatomic,strong) UIButton * voiceBtn;

@property (nonatomic,strong) NSString * documentsPath;

@property (nonatomic,strong) AVAudioRecorder *audioRecorder;
@property (nonatomic,strong) AVAudioPlayer * audioPlayer;

@property (nonatomic,strong) NSData * mp3;


@property (nonatomic,assign) int currentTime;
@property (nonatomic,assign) int totleTime;

@property (nonatomic,weak) UIImageView * changeView;
@property (nonatomic,weak) UIImageView * chageLittleView;

@end

@implementation CommentController

+ (instancetype)commentWithGalleryID:(NSString *)galleryID tabTag:(NSInteger)tabTag{

    CommentController * commentVC = [[self alloc] init];
    
    commentVC.galleryID = galleryID;
    commentVC.tabTag = tabTag;
    commentVC.page = 1;
    
    return commentVC;
}

- (void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [self stop];
    [self stopRecording];
}
- (NSArray *)dataArr{

    
    if (!_dataArr) {
        
        NSMutableArray * dataMuArr = [NSMutableArray array];
        
        [CloudLogin getCommentArrWithGalleryID:_galleryID Page:[NSString stringWithFormat:@"%d",_page] Count:@"20" success:^(NSDictionary *responseObject) {
            
            NSLog(@"%@",responseObject);
            
            int status = [responseObject[@"status"] intValue];
            if (status==0) {
                
                NSArray * dataArr = responseObject[@"comments"];
                for (NSDictionary * dic in dataArr) {
                    
                    CommentFrame * dataFrame = [[CommentFrame alloc] init];
                    dataFrame.model = [CommentModel valueWithDic:dic];
                    [dataMuArr addObject:dataFrame];
                }
                
                _dataArr = dataMuArr;
                [self.tableView reloadData];
                
            }else{
            
                [self.view poptips:responseObject[@"error"]];
            }
            
            
          
        } failure:^(NSError *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self dataArr];
    
    CGRect tabRect = self.view.bounds;
    tabRect.size.height = KScreenHeight - TEXTVIEW_HEIGHT;
    
    self.tableView = [[UITableView alloc] initWithFrame:tabRect style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.tableView];
    
    self.title = @"评论列表";
    self.view.backgroundColor = ViewBackColor;
    
    [self createTextField];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{

     NSLog(@"------开始");
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    NSLog(@"开始");
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
/**
 *  添加输入框
 */
- (void)createTextField{
    
    //底部view
    UIView * endView = [[UIView alloc] initWithFrame:CGRectMake(0, KScreenHeight - TEXTVIEW_HEIGHT, KScreenWidth, TEXTVIEW_HEIGHT)];
    endView.backgroundColor = Color(216, 216, 233);
    
    [self.view addSubview:endView];
    
    UIButton * changeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    CGFloat btnY = 10*SCREEN_WIDTH_RATIO55;
    CGFloat btnH = endView.height - btnY*2;
    CGFloat btnW = btnH;
    CGFloat btnX = 10*SCREEN_WIDTH_RATIO55;
    
    changeBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
    
    [changeBtn setImage:[UIImage imageNamed:@"comtentSend"] forState:UIControlStateNormal];

    [changeBtn setImage:[UIImage imageNamed:@"touchSay"] forState:UIControlStateSelected];
    [changeBtn addTarget:self action:@selector(changeType:) forControlEvents:UIControlEventTouchUpInside];
    
    [endView addSubview:changeBtn];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //设置textField输入起始位置
    CGFloat textX = CGRectGetMaxX(changeBtn.frame) + 46*SCREEN_WIDTH_RATIO55/3;
    CGFloat textY = 24*SCREEN_WIDTH_RATIO55/3;
    CGFloat textH = TEXTVIEW_HEIGHT - textY*2;
    CGFloat textW = KScreenWidth - textX - 20*SCREEN_WIDTH_RATIO55;
    
    _messageField = [[UITextField alloc] initWithFrame:CGRectMake(textX, textY, textW, textH)];
    
    
    _messageField.borderStyle = UITextBorderStyleRoundedRect;
    _messageField.backgroundColor = ColorI(0xffffff);
    _messageField.delegate = self;
    
    
    [endView addSubview:_messageField];
    
    //添加按钮
    self.voiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _voiceBtn.frame = _messageField.frame;
    [_voiceBtn setTitle:@"按住说话" forState:UIControlStateNormal];
    
   
    [_voiceBtn addTarget:self action:@selector(shortTouch)
       forControlEvents:UIControlEventTouchUpInside];

    //长按事件
    UILongPressGestureRecognizer *longPress =[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(LongPressed:)];
    
    [_voiceBtn addGestureRecognizer:longPress];

    
    _voiceBtn.backgroundColor = Color(206, 216, 233);
    [_voiceBtn setTitleColor:ColorI(0x5b5b5b) forState:UIControlStateNormal];
    _voiceBtn.layer.borderColor = ColorI(0x201fc3).CGColor;
    _voiceBtn.layer.borderWidth = 0.5;
    _voiceBtn.layer.cornerRadius = 10*SCREEN_WIDTH_RATIO55;
    _voiceBtn.clipsToBounds = YES;
    
    [endView addSubview:_voiceBtn];
    
    //设置显示方法
    _messageField.hidden =!changeBtn.selected;
    _voiceBtn.hidden = changeBtn.selected;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    
    [self.tableView addGestureRecognizer:singleTap];
    
}
/**
 *  长按事件处理
 */
- (void)LongPressed:(UILongPressGestureRecognizer *)longGesture{

    if (longGesture.state==UIGestureRecognizerStateBegan) {
        
        _currentTime = 0;
        [_voiceBtn setTitle:@"请讲话" forState:UIControlStateHighlighted];
        [_voiceBtn setTitle:@"请讲话" forState:UIControlStateNormal];
        [self startRecord];
        timerForPitch =[NSTimer scheduledTimerWithTimeInterval: 1.0f target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
        
    }else if(longGesture.state == UIGestureRecognizerStateEnded){//长按结束 录音也结束
        
        [self stopRecording];

        [_voiceBtn setTitle:@"按住说话" forState:UIControlStateNormal];
        
        [timerForPitch invalidate];
        timerForPitch = nil;
        
        [self replyMessWithType:YES content:nil];
    }
}
/**
 *  短按事件
 */
- (void)shortTouch{

    [self.view poptips:@"时间太短"];
}
/**
 *  开始录音
 */
- (void)startRecord{

    self.audioRecorder = nil;
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryRecord error:nil];
    
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
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"recordTest.caf"];
    
    NSURL *url = [NSURL fileURLWithPath:soundFilePath];
    
    NSError *error = nil;
    
    
    self.audioRecorder = [[ AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
    [self createChangeView];
    _audioRecorder.meteringEnabled = YES;
    if ([_audioRecorder prepareToRecord] == YES){
        _audioRecorder.meteringEnabled = YES;
        [_audioRecorder record];
        
    }

}
/**
 *  时间监听
 */
- (void)levelTimerCallback:(NSTimer *)timer {
    _currentTime++;
    
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
-(void) pauseRecording {
    [_audioRecorder pause];
}
/**
 *  停止录音
 */
-(void) stopRecording {
    [_audioRecorder stop];
    self.totleTime = _currentTime;
    _currentTime=0;
    
    self.changeView.hidden = YES;
    [self.changeView removeFromSuperview];
    self.changeView = nil;
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

/**
 *  更改输入方式
 */
- (void)changeType:(UIButton *)sender{
   
    //变更按钮标题
    sender.selected = !sender.selected;
    
    //变换显示按钮
    _messageField.hidden = !_messageField.hidden;
    _voiceBtn.hidden = !_voiceBtn.hidden;
    
    if (_messageField.hidden) {//根据情况隐藏键盘
        [_messageField resignFirstResponder];
    }else{
        [_messageField becomeFirstResponder];
    }
}
/**
 *  发送信息
 */
- (void)replyMessWithType:(BOOL)isVoice content:(NSString *)content{
    
    if (!content && _totleTime<3) {
        [self.view poptips:@"请评论大于3秒的语音"];
    }else{
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [CloudLogin pushCommentWithWithGalleryID:self.galleryID replyTo:nil voice:nil voiceLen:[NSString stringWithFormat:@"%d",_totleTime] content:content success:^(NSDictionary *responseObject) {
            NSLog(@"%@",responseObject);
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            int status = [responseObject[@"status"] intValue];
            if (status == 0) {
                //重置数据
                self.dataArr = nil;
                [self dataArr];
                
                
                //修改广场页评论数
                if ([self.delegate respondsToSelector:@selector(reloadPlazaDataWithGalleryID:tabTag:indexPath:)]) {
                    [self.delegate reloadPlazaDataWithGalleryID:self.galleryID tabTag:self.tabTag indexPath:self.indexPath];
                }
            }
        } failure:^(NSError *errorMessage) {
            NSLog(@"%@",errorMessage);
        }];

    }
    
    
}


#pragma -----mark------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return (_dataArr) ? _dataArr.count : 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentFrame * dataFrame = [_dataArr objectAtIndex:indexPath.row];
    return dataFrame.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    CommentCell * cell = [CommentCell cellWithTableView:tableView indexPath:indexPath];
    
    CommentFrame * dataFrame = [_dataArr objectAtIndex:indexPath.row];
    cell.delegate = self;
    
    cell.dataFrame = dataFrame;
    
    return cell;
}

#pragma mark - 键盘处理
#pragma mark 键盘即将显示

- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-ty, 0, 0, 0);
    
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    
    NSString * content = textField.text;
    [self replyMessWithType:NO content:content];
    
    textField.text = nil;
    return YES;
}
/**
 *  点击空白区域隐藏键盘
 */
-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    
    [self.messageField resignFirstResponder];
    
}


#pragma ----mark----CommentCellDelegate

- (void)playVoiceWithModel:(CommentModel *)model{

    NSError * error = nil;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.voice]]error:&error];
    
    if (!error) {
        self.audioPlayer.numberOfLoops = 0;
        [self.audioPlayer play];
    }
}

@end
