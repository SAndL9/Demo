//
//  SARecordingView.m
//  WKWebViewDemo
//
//  Created by 李磊 on 16/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SARecordingView.h"
#import "lame.h"
#import <AVFoundation/AVFoundation.h>

static NSString * const kRecordAudioFile = @"myRecord.caf";
static NSString * const kRecordAudioFileMP3 = @"myRecord.MP3";

@interface SARecordingView ()
@property (nonatomic, strong) UIImageView *recordImgView;
/** 播放 */
@property (nonatomic, strong)AVAudioPlayer *player;

@property (nonatomic, assign) NSInteger  recorderTime;
/** 录音button */
@property (nonatomic, strong) UIButton *voiceButton;
/** 录音 */
@property (nonatomic, strong)AVAudioRecorder *recorder;
/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;
/** caf文件路径 */
@property (nonatomic, copy) NSString *cafPath;
/** MP3文件路径 */
@property (nonatomic, copy) NSString *mpa3path;
/** 音量图片数组 */
@property (nonatomic, strong) NSMutableArray *volumeArray;
/** 音频时长 */
@property (nonatomic, assign) NSInteger timeNumber;
/** 播放按钮并显示播放时间 */
@property (nonatomic, strong) UIButton *playButton;
/** 重置按钮 */
@property (strong, nonatomic) UIButton *resetButton;

@property (nonatomic, strong) NSDictionary *recorderSettingsDictionary;
/** 转换后的数据 */
@property (nonatomic, strong) NSData *MPdata;
@end

@implementation SARecordingView


#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupSubviewsContraints];
    }
    return self;
}


#pragma mark-
#pragma mark- 代理类名 delegate

/** 按下录音 */
- (void)downRecordBtnClieckedAction:(UIButton*)sender{
    if (!sender.selected) {
        if ([self canRecord]) {
            _recordImgView.hidden = NO;
            _playButton.hidden = YES;
            _resetButton.hidden = YES;
            [self addTimer];
            _recorder.meteringEnabled = YES;
            [_recorder prepareToRecord];
            [_recorder peakPowerForChannel:0.0];
            [_recorder record];
            sender.selected = YES;
            [self playRecordImgViewAnimating];
        }
    }else{
        [self stopRecorderSetting];
        sender.selected = NO;
        _recordImgView.hidden = YES;
        [self cafConvertMp3Format];
    }
}

/** 松手 停止录音 */
- (void)upRecordBtnClieckedAction:(UIButton*)sender{
//    self.isClick = NO;
    [self stopRecorderSetting];
    sender.selected = NO;
    _recordImgView.hidden = YES;
    [self cafConvertMp3Format];
    [_voiceButton setBackgroundImage:[UIImage imageNamed:@"btn_bg"] forState:UIControlStateNormal];
    [_voiceButton removeTarget:self
                        action:@selector(downRecordBtnClieckedAction:)
              forControlEvents:UIControlEventTouchDown];
    [_voiceButton removeTarget:self
                        action:@selector(upRecordBtnClieckedAction:)
              forControlEvents:UIControlEventTouchUpInside];
    [_voiceButton addTarget:self
                     action:@selector(upLoadServiceRecordBtnClieckedAction:)
           forControlEvents:UIControlEventTouchUpInside];
}

/** 播放 */
- (void)playBtnClickedAction:(UIButton *)sender{
    _player = nil;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self getSavePath] error:nil];
    _player.volume = 1.0;
    [_player play];
}

/**
 配置音频会话
 */
- (void)judgeSystemVersion{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //设置播放器为扬声器模式
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [session setActive:YES error:nil];
}

/**
 开启录音动画
 */
- (void)playRecordImgViewAnimating{
    _volumeArray = [[NSMutableArray alloc] init];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"record-%d", i]];
        [_volumeArray addObject:image];
    }
    [self.recordImgView setAnimationImages:_volumeArray];
    [self.recordImgView setAnimationRepeatCount:0];
    [self.recordImgView setAnimationDuration:0.7];
    [self.recordImgView startAnimating];
}

/**
 获取沙盒存储路径
 
 @return 存储路径，URL格式
 */
- (NSURL *)getSavePath{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    self.cafPath=urlStr;
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}

/**
 停止录音
 */
- (void)stopRecorderSetting{
    [self.recordImgView stopAnimating];
    _recorderTime = _timeNumber/10;
    if (_recorderTime == 0) {
        _recorderTime = 1;
    }
    if (_recorderTime == 61) {
        _recorderTime = 60;
    }
    _playButton.hidden = NO;
    _resetButton.hidden = NO;
    [_voiceButton setTitle:NSLocalizedString(@"确定", nil) forState:0];
    [_playButton setTitle:[NSString stringWithFormat:@"%ld''%@",(long)_recorderTime, NSLocalizedString(@"语音", nil)] forState:0];
    [self removeTimer];
    if ([_recorder isRecording]) {
        [_recorder stop];
    }
}

/**
 移除定时器
 */
- (void)removeTimer{
    _timeNumber = 0;
    [_timer invalidate];
    _timer = nil;
}

/**
 加载的定时器
 */
- (void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f
                                              target:self
                                            selector:@selector(refreshButtonTimeText)
                                            userInfo:nil
                                             repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
}

/**
 记录录音时长，并限制最长时长为1分钟
 */
- (void)refreshButtonTimeText{
    _timeNumber = _timeNumber + 1;
    if (_timeNumber > 600) {
        [self stopRecorderSetting];
        _voiceButton.selected = NO;
        _resetButton.selected = NO;
        _recordImgView.hidden = YES;
        [_recorder stop];
        _recorder = nil;
        [self removeTimer];
        [self cafConvertMp3Format];
        return;
    }
    
}

/**
 判断是否允许使用麦克风,7.0新增的方法requestRecordPermission
 
 @return YES：允许访问   NO：不允许访问
 */
- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                if (granted) {
                    bCanRecord = YES;
                }
                else {
                    bCanRecord = NO;
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [ [[SAAlert alloc]initWithTitle: nil
//                                                message:NSLocalizedString(@"app需要访问您的麦克风。\n请启用麦克风-设置/隐私/麦克风", nil)
//                                            cancelTitle:NSLocalizedString(@"是的", nil)
//                                            cancelBlock:nil
//                                             otherTitle:NSLocalizedString(@"关闭", nil)
//                                             otherBlock:nil
//                                             alertStyle:SAAlertStyleAlert
//                                     fromViewController:nil] showAlert];
//                    });
                }
            }];
        }
    }else{
    }
    return bCanRecord;
}

/**
 将 caf 格式的录音转为 mp3 格式
 
 @return 是否转换成功
 */
- (BOOL)cafConvertMp3Format
{
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStr=[urlStr stringByAppendingPathComponent:kRecordAudioFile];
    NSString *urlStrMP=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlStrMP=[urlStrMP stringByAppendingPathComponent:kRecordAudioFileMP3];
    
    //    删除MP3文件
    [self deleteFileWithPath:[self mpa3path]];
    
    @try {
        int read, write;
        FILE *pcm = fopen([urlStr cStringUsingEncoding:1], "rb");
        if(pcm == NULL)
        {
            NSLog(@"file not found");
        }
        else
        {
            fseek(pcm,4*1024,SEEK_CUR);
            FILE *mp3 = fopen([urlStrMP cStringUsingEncoding:1], "wb");
            const int PCM_SIZE = 8192;
            const int MP3_SIZE = 8192;
            short int pcm_buffer[PCM_SIZE*2];
            unsigned char mp3_buffer[MP3_SIZE];
            lame_t lame = lame_init();
            lame_set_in_samplerate(lame, 11025.0);//11025.0
            lame_set_VBR(lame, vbr_default);
            lame_init_params(lame);
            do {
                read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
                if (read == 0)
                    write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
                else
                    write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
                fwrite(mp3_buffer, write, 1, mp3);
            } while (read != 0);
            lame_close(lame);
            fclose(mp3);
            fclose(pcm);
            return YES;
        }
        return NO;
    }
    @catch (NSException *exception) {
        return NO;
    }
    @finally {
        NSData *data= [NSData dataWithContentsOfFile:urlStrMP];
        self.MPdata=data;
        self.mpa3path = urlStrMP;
    }
}

/** 删除所有的录音文件 */
- (void)deleteFileWithPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:nil];
}


#pragma mark-
#pragma mark- Event response


#pragma mark-
#pragma mark- Private Methods


#pragma mark-
#pragma mark- Getters && Setters
- (UIImageView *)recordImgView{
    if (!_recordImgView) {
        _recordImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"microphone"]];
        _recordImgView.contentMode = UIViewContentModeCenter;
    }
    return _recordImgView;
}

/** 录音设置 */
-(NSDictionary *)recorderSettingsDictionary{
    if (!_recorderSettingsDictionary) {
        _recorderSettingsDictionary =[[NSDictionary alloc] initWithObjectsAndKeys:
                                      [NSNumber numberWithFloat: 11025],AVSampleRateKey,
                                      [NSNumber numberWithInt: kAudioFormatLinearPCM],AVFormatIDKey,
                                      [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
                                      [NSNumber numberWithInt:AVAudioQualityHigh],AVEncoderAudioQualityKey,
                                      [NSNumber numberWithInt:16],AVLinearPCMBitDepthKey,nil];
    }
    return _recorderSettingsDictionary;
}

- (UIButton *)resetButton{
    if (!_resetButton) {
        _resetButton  = [UIButton buttonWithType:UIButtonTypeCustom];
        _resetButton.layer.cornerRadius = 3.f;
        _resetButton.layer.masksToBounds = YES;
        _resetButton.hidden = YES;
        [_resetButton setTitle:NSLocalizedString(@"重录", nil) forState:UIControlStateNormal];
        _resetButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_resetButton setBackgroundImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
        [_resetButton setBackgroundImage:[UIImage imageNamed:@"box"] forState:UIControlStateDisabled];
        [_resetButton addTarget:self
                         action:@selector(goToRecorderClickedActionBySender:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetButton;
}

-(UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _playButton.layer.cornerRadius = 1.5f;
        _playButton.layer.masksToBounds = YES;
        [_playButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0  blue:255.0/255.0  alpha:1.0] forState:UIControlStateNormal];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"blackview"] forState:UIControlStateNormal];
        _playButton.hidden = YES;
        [_playButton addTarget:self action:@selector(playBtnClickedAction:) forControlEvents:UIControlEventTouchUpInside];
        [_playButton setTitle:@"22″语音" forState:UIControlStateNormal];
        _playButton.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    return _playButton;
}

-(UIButton *)voiceButton{
    if (!_voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _voiceButton.layer.cornerRadius = 1.5f;
        _voiceButton.layer.masksToBounds = YES;
        [_voiceButton setTitle:NSLocalizedString(@"按住录入语音", nil) forState:UIControlStateNormal];
        [_voiceButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"box"] forState:UIControlStateNormal];
        [_voiceButton setBackgroundImage:[UIImage imageNamed:@"box"] forState:UIControlStateDisabled];
        [_voiceButton addTarget:self action:@selector(downRecordBtnClieckedAction:) forControlEvents:UIControlEventTouchDown];
        [_voiceButton addTarget:self action:@selector(upRecordBtnClieckedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

//- (UIImageView *)recordImgView{
//    if (!_recordImgView) {
//        _recordImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"microphone"]];
//        _recordImgView.contentMode = UIViewContentModeCenter;
//    }
//    return _recordImgView;
//}

#pragma mark-
#pragma mark- SetupConstraints 

- (void)setupSubviewsContraints {
     _recorder = [[AVAudioRecorder alloc] initWithURL:[self getSavePath] settings:self.recorderSettingsDictionary error:nil];
}

@end
