//
//  SAAudioRecordViewController.m
//  SAComponentKitDemo
//
//  Created by 李磊 on 20/7/17.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import "SAAudioRecordViewController.h"
#import "SAAudioManager.h"
#import <SAKit/SAKit.h>
#import <AVFoundation/AVFoundation.h>
#import "lame.h"
#import <Masonry/Masonry.h>
#import "SAComponentKitPrivate.h"
#import <SALocalizable.h>
#import "SADeviceJurisdictionView.h"

#define kScreenWidthScale   (kScreen_width / 375.0)
#define kScreenHeightScale  (kScreen_height / 667.0)


@interface SAAudioRecordInfo : NSObject <SAAudioInfoProtocol>

@property (nonatomic, strong) NSURL *audioFileURL;

@property (nonatomic, strong) NSString *audioTimeInterval;

- (instancetype)initWithAudioFileURL:(NSURL *)audioFileURL audioTimeIntervale:(NSString *)audioTimeInterval;

@end

@implementation SAAudioRecordInfo

- (instancetype)initWithAudioFileURL:(NSURL *)audioFileURL audioTimeIntervale:(NSString *)audioTimeInterval {
    if (self = [super init]) {
        _audioFileURL = audioFileURL;
        _audioTimeInterval= audioTimeInterval;
    }
    return self;
}

@end



@interface SAAudioRecordViewController () <SAAudioRecordViewControllerDelegate>


/** 录音按钮 */
@property (nonatomic, strong) UIImageView *imgIconView;

/** 进度条 */
@property (nonatomic, strong) SAProgressCircleBar *progressBar;

/** 倒计时时间显示 */
@property (nonatomic, strong) UILabel *timeLabel;

/** 取消按钮 */
@property (nonatomic, strong) SAButton *cancleButton;

/** 完成按钮 */
@property (nonatomic, strong) SAButton *finishButton;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 动效 */
@property (nonatomic, strong) UIView *recordAnimationView;

/** 动效数组 */
@property (nonatomic, strong) NSMutableArray *animationPlayArray;

/** 记录录音时间 */
@property (nonatomic, assign) NSInteger recordTimer;

/** 录音 */
@property (nonatomic, strong) AVAudioRecorder *recorder;

/** caf文件路径 */
@property (nonatomic, copy) NSString *cafPath;

/** MP3文件路径 */
@property (nonatomic, copy) NSString *mpa3path;

/** 录音属性设置 */
@property (nonatomic, strong) NSDictionary *recorderSettingsDictionary;

/** 用于接受外面的录音时间 */
@property (nonatomic, assign) NSTimeInterval maxRecordTime;

/** caf文件名字 */
@property (nonatomic, strong) NSString *kRecordAudioFile;

/** MP3文件名字 */
@property (nonatomic, strong) NSString *kRecordAudioFileMP3;

@end

@implementation SAAudioRecordViewController



#pragma mark-
#pragma mark- View Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviewsContraints];
    [self configureDefaultSetting];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [self removeTimer];
    _recordTimer = 0;
}

#pragma mark-
#pragma mark- Event response

/** 配置默认设置 */
- (void)configureDefaultSetting{
    _recordTimer = 0;
    _kRecordAudioFile = [NSString stringWithFormat:@"%ld.caf",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000000];
    _kRecordAudioFileMP3 =  [NSString stringWithFormat:@"%ld.MP3",(NSInteger)[[NSDate date] timeIntervalSince1970] * 1000000];
    _recorder = [[AVAudioRecorder alloc]initWithURL:[self getSavePath] settings:self.recorderSettingsDictionary error:nil];
    [self activeAudioSession];
    __weak typeof(self) (weakSelf) = self;
    SADeviceJurisdictionView *viewSelf = [[SADeviceJurisdictionView alloc]init];
    [viewSelf checkDeviceJurisdictionWithType:SAMicrophoneJurisdictionType showFromController:self allowBlock:^{
        [weakSelf addTimer];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf playRecordImgViewAnimation];
        });
        [_recorder prepareToRecord];
        [_recorder peakPowerForChannel:0.0];
        [_recorder record];
    }];
    
}


/** 点击取消按钮 */
- (void)pressCancleButtonAction:(UIButton *)sender{
    if (!self.mpa3path && !self.timeLabel.text ) {
        if ([self.delegate respondsToSelector:@selector(audioRecordViewController:didFinishRecord:)]) {
            [self.delegate audioRecordViewController:self didFinishRecord:[[SAAudioRecordInfo alloc]initWithAudioFileURL:nil audioTimeIntervale:nil]];
        }

        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        __weak typeof(self) (weakSelf) = self;
        SAAlert *alert = [[SAAlert alloc]initWithTitle:[SALocalizable sa_localizedStringForKey:@"提示"] message:[SALocalizable sa_localizedStringForKey:@"是否结束本次录音呢？"]
                                           cancelTitle:[SALocalizable sa_localizedStringForKey:@"否"]
                                           cancelBlock:nil otherTitle:[SALocalizable sa_localizedStringForKey:@"是"] otherBlock:^{
                                               [weakSelf.recordAnimationView  removeFromSuperview];
                                               [weakSelf removeTimer];
                                               [weakSelf deleteAudioRecordPath:weakSelf.cafPath];
                                               [weakSelf deleteAudioRecordPath:weakSelf.mpa3path];
                                               if ([self.delegate respondsToSelector:@selector(audioRecordViewController:didFinishRecord:)]) {
                                                   [self.delegate audioRecordViewController:self didFinishRecord:[[SAAudioRecordInfo alloc]initWithAudioFileURL:nil audioTimeIntervale:nil]];
                                               }
                                               [weakSelf dismissViewControllerAnimated:YES completion:nil];
                                           } alertStyle:SAAlertStyleAlert fromViewController:self];
        [alert showAlert];
    }
}

/** 点击确定按钮 */
- (void)pressFinishButtonAction:(UIButton *)sender{
    
    self.progressBar.percent += (100.00 / _maxRecordTime) / 100.00;
    [self.recordAnimationView removeFromSuperview];
    [self removeTimer];
    [self.imgIconView setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"finish-1"]];
    self.timeLabel.textColor = [UIColor sa_colorC12];
    self.timeLabel.text = [self getMMSSFromSS:_recordTimer];
    [self deleteAudioRecordPath:self.cafPath];
    
 
        if ([self.delegate respondsToSelector:@selector(audioRecordViewController:didFinishRecord:)]) {
            [self.delegate audioRecordViewController:self didFinishRecord:[[SAAudioRecordInfo alloc]initWithAudioFileURL:[NSURL URLWithString:self.mpa3path] audioTimeIntervale:self.timeLabel.text]];
        }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
}

/** 添加定时器 */
- (void)addTimer{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(pressTimerAction) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

/**定时器事件*/
- (void)pressTimerAction{
    _recordTimer += 1;
    self.progressBar.percent += (100.00 / _maxRecordTime) / 100.00;
    if (self.progressBar.percent >= 1.0) {
        self.progressBar.percent = 1.0;
        [self.imgIconView setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"finish-1"]];
        self.timeLabel.textColor = [UIColor sa_colorC12];
        self.timeLabel.text = [self getMMSSFromSS:_recordTimer];
        [self deleteAudioRecordPath:self.cafPath];
        [self.recordAnimationView removeFromSuperview];
        [self removeTimer];
    }else{
        self.timeLabel.text = [self getMMSSFromSS:_recordTimer];
    }
}


/** 秒转换成分钟和秒 */
- (NSString *)getMMSSFromSS:(NSInteger )totalTime{
    totalTime = totalTime == _maxRecordTime + 1 ? _maxRecordTime : totalTime;
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",totalTime/60];
    NSString *str_second = [NSString stringWithFormat:@"%02ld",totalTime%60];
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    return format_time;
    
}

/** 移除定时器 */
- (void)removeTimer{
    [self.timer invalidate];
    self.timer = nil;
}

/** 录音动效 */
- (void)playRecordImgViewAnimation{
    self.recordAnimationView.layer.backgroundColor = [UIColor clearColor].CGColor;
    CAShapeLayer *pulseLayer = [CAShapeLayer layer];
    pulseLayer.frame = _recordAnimationView.layer.bounds;
    pulseLayer.path = [UIBezierPath bezierPathWithOvalInRect:pulseLayer.bounds].CGPath;
    pulseLayer.fillColor =[UIColor colorWithRed:9/255.0 green:113/255.0 blue:206/255.0 alpha:1].CGColor;
    pulseLayer.opacity = 0.0;
    
    //可以复制layer
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = _recordAnimationView.bounds;
    replicatorLayer.instanceCount = 8;//创建副本的数量,包括源对象。
    replicatorLayer.instanceDelay = 0.5;//复制副本之间的延迟
    [replicatorLayer addSublayer:pulseLayer];
    [_recordAnimationView.layer addSublayer:replicatorLayer];
    
    CABasicAnimation *opacityAnima = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnima.fromValue = @(0.3);
    opacityAnima.toValue = @(0.0);
    
    CABasicAnimation *scaleAnima = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnima.fromValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 0.0, 0.0, 0.0)];
    scaleAnima.toValue = [NSValue valueWithCATransform3D:CATransform3DScale(CATransform3DIdentity, 1.0, 1.0, 0.0)];
    
    CAAnimationGroup *groupAnima = [CAAnimationGroup animation];
    groupAnima.animations = @[opacityAnima, scaleAnima];
    groupAnima.duration = 4;
    groupAnima.autoreverses = NO;
    groupAnima.repeatCount = HUGE;
    [pulseLayer addAnimation:groupAnima forKey:@"groupAnimation"];
}

/** 获取temp存储 */
- (NSURL *)getSavePath{
    NSString *urlStr =[NSTemporaryDirectory() stringByAppendingPathComponent:_kRecordAudioFile];
    self.cafPath = urlStr;
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    return url;
}



/** 配置音频会话 */
- (void)activeAudioSession{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //设置播放器为扬声器模式
    [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    [session setActive:YES error:nil];
}

/**
 将 caf 格式的录音转为 mp3 格式
 
 @return 是否转换成功
 */
- (BOOL)cafConvertMp3Format{
    
    NSString *urlStrMP=[NSTemporaryDirectory() stringByAppendingPathComponent:_kRecordAudioFileMP3];
    @try {
        int read, write;
        FILE *pcm = fopen([self.cafPath cStringUsingEncoding:1], "rb");
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
        self.mpa3path = urlStrMP;
    }
}

/** 删除取消录音的文件 */
- (void)deleteAudioRecordPath:(NSString *)path{
    if ([self cafConvertMp3Format]) {
        [[SAAudioManager shareInstance] removeAudioByFileURL:[NSURL URLWithString:path]];
    }
    
}
/** 设置最大录音时间 */
- (void)setMaxTimeInterval:(NSTimeInterval)timeInterval {
    _maxRecordTime = timeInterval > 0 ? timeInterval : 180;
}


#pragma mark-
#pragma mark- Private Methods

#pragma mark-
#pragma mark- Getters && Setters

- (UIImageView *)imgIconView{
    if (!_imgIconView) {
        _imgIconView = [[UIImageView alloc]init];
        _imgIconView.image = [SAComponentKitPrivate sa_componentKitImageByName:@"Voice-2"];
    }
    return _imgIconView;
}

- (SAProgressCircleBar *)progressBar{
    if (!_progressBar) {
        _progressBar = [[SAProgressCircleBar alloc]initWithType:SAProgressCircleBarSoundRecordType];
        _progressBar.percent = 0.0f;
        
    }
    return _progressBar;
}

- (UIView *)recordAnimationView{
    if (!_recordAnimationView) {
        _recordAnimationView = [[UIView alloc]init];
    }
    return _recordAnimationView;
}


- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc]init];
        _timeLabel.font = [UIFont sa_fontS1:SAFontBoldTypeB3];
        _timeLabel.textColor = [UIColor sa_colorC1];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (SAButton *)cancleButton{
    if (!_cancleButton) {
        _cancleButton = [[SAButton alloc]initWithTitle:[SALocalizable sa_localizedStringForKey:@"取消"]  buttonStyle:SAButtonStyleCornerNone buttonHeightType:SAButtonHeightTypeH03];
        [_cancleButton addTarget:self action:@selector(pressCancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancleButton;
}

- (SAButton *)finishButton{
    if (!_finishButton) {
        _finishButton = [[SAButton alloc]initWithTitle:[SALocalizable sa_localizedStringForKey:@"完成"]  buttonStyle:SAButtonStyleCornerFill buttonHeightType:SAButtonHeightTypeH03];
        [_finishButton addTarget:self action:@selector(pressFinishButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _finishButton;
}

/** 录音设置 */
- (NSDictionary *)recorderSettingsDictionary{
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

#pragma mark-
#pragma mark- SetupConstraints

- (void)setupSubviewsContraints {
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.recordAnimationView];
    [self.view addSubview:self.imgIconView];
    [self.view addSubview:self.progressBar];
    
    [self.view addSubview:self.timeLabel];
    [self.view addSubview:self.cancleButton];
    [self.view addSubview:self.finishButton];
    [self.imgIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(125 * kScreenWidthScale, 125 * kScreenHeightScale));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(210 * kScreenHeightScale);
    }];
    
    [self.progressBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(128 * kScreenWidthScale, 128 * kScreenHeightScale));
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view.mas_top).offset(210 * kScreenHeightScale );
    }];
    
    [self.recordAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imgIconView.mas_centerX);
        make.centerY.equalTo(self.imgIconView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(280 * kScreenWidthScale, 280 * kScreenHeightScale));
        
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imgIconView.mas_bottom).offset(95 * kScreenHeightScale);
        make.centerX.equalTo(self.view.mas_centerX);
        make.height.mas_equalTo(27 * kScreenHeightScale);
    }];
    [self.cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(35 * kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(130 * kScreenWidthScale, 40 * kScreenHeightScale));
        make.top.equalTo(self.timeLabel.mas_bottom).offset(77 * kScreenHeightScale);
    }];
    
    [self.finishButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-35 * kScreenWidthScale);
        make.size.mas_equalTo(CGSizeMake(130 * kScreenWidthScale, 40 * kScreenHeightScale));
        make.top.equalTo(self.timeLabel.mas_bottom).offset(77 * kScreenHeightScale);
    }];
    
    
}

@end
