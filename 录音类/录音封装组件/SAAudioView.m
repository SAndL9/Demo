//
//  SAAudioView.m
//  SAComponentKitDemo
//
//  Created by 李磊 on 20/7/17.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import "SAAudioView.h"
#import <Masonry/Masonry.h>
#import <AVFoundation/AVFoundation.h>
#import <SAKit/SAKit.h>
#import "SAComponentKitPrivate.h"
#import "SAAudioManager.h"

@interface SAAudioView () <AVAudioPlayerDelegate,SAAudioRecordViewControllerDelegate>

/** 录音按钮 */
@property (nonatomic, strong) UIButton *recordButton;

/** 播放按钮 */
@property (nonatomic, strong) UIButton *playButton;

/** 删除按钮 */
@property (nonatomic, strong) UIButton *deleteButton;

/** 播放 */
@property (nonatomic, strong) AVAudioPlayer *player;

/** 文件路径 */
@property (nonatomic, copy) NSString *filePath;

/** 那个控制器模态 */
@property (nonatomic, weak) UIViewController *fromViewController;

/** 是否有暂停状态 */
@property (nonatomic, assign) BOOL isStopAction;

/** 传入的录音时间 */
@property (nonatomic, assign) NSTimeInterval passTimer;

@end

@implementation SAAudioView

#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithFromViewController:(UIViewController *)viewController{
    if (self = [super init]) {
        [self sizeToFit];
        _isStopAction = NO;
        self.fromViewController = viewController;
        [self setupAudioRecordSubviewsContraints];
    }
    return self;
}

#pragma mark-
#pragma mark- Event response

/** 点击录音按钮事件 */
- (void)pressRecordButtonAction:(UIButton *)sender{
    SAAudioRecordViewController *vc = [[SAAudioRecordViewController alloc]init];
    [vc setMaxTimeInterval:_passTimer];
    vc.delegate = self;
    [self.fromViewController  presentViewController:vc animated:YES completion:nil];
}

- (void)audioRecordViewController:(SAAudioRecordViewController *)audioRecordViewController didFinishRecord:(id<SAAudioInfoProtocol>)audioInfo{
    if (recordInfo.audioFileURL.absoluteString > 0 && recordInfo.audioTimeInterval > 0 ) {
        
        if ([weakSelf.delegate respondsToSelector:@selector(audioView:didFinishRecord:)]) {
            [weakSelf.delegate audioView:weakSelf didFinishRecord:recordInfo];
        }
        
        self.playButton.hidden = NO;
        self.deleteButton.hidden = NO;
        self.recordButton.hidden = YES;
        self.filePath = recordInfo.audioFileURL.absoluteString;
        [self.playButton setTitle:recordInfo.audioTimeInterval forState:UIControlStateNormal];
        _playButton.titleEdgeInsets = UIEdgeInsetsMake(0,  0, 0, 0);
        _playButton.imageEdgeInsets = UIEdgeInsetsMake(0,  15, 0, _playButton.bounds.size.width - 58);
        [_playButton setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"play"] forState:UIControlStateNormal];
    }else{
        self.playButton.hidden = YES;
        self.deleteButton.hidden = YES;
        self.recordButton.hidden = NO;
    }

}

/** 外界传入的录音时间 */
- (void)setMaxTimeInterval:(NSTimeInterval)timeInterval{
    _passTimer = timeInterval;
}

/** 播放按钮点击事件 */
- (void)pressPlayButtonAction:(UIButton *)sender{
    if (_isStopAction == YES) {
        
        [_player stop];
        [_playButton setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"play"] forState:UIControlStateNormal];
        _isStopAction = NO;
        
    }else{
        _player = nil;
        _player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.filePath] error:nil];
        _player.delegate = self;
        [_playButton setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"stop"] forState:UIControlStateNormal];
        _player.volume = 1.0;
        [_player play];
        _isStopAction = YES;
    }
}
/** 播放完成的代理方法 */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [_playButton setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"play"] forState:UIControlStateNormal];
}

/** 删除按钮点击事件 */
- (void)pressDeleteButtonAction:(UIButton *)sender{
    [self.player stop];
    [self deleteFileWithPath:self.filePath];
    self.playButton.hidden = YES;
    self.deleteButton.hidden = YES;
    self.recordButton.hidden = NO;
}

/** 删除所有的录音文件 */
- (void)deleteFileWithPath:(NSString *)path{
    [[SAAudioManager shareInstance] removeAudioByFileURL:[NSURL URLWithString:path]];
}


#pragma mark-
#pragma mark- SetupConstraints
- (void)setupAudioRecordSubviewsContraints {
    [self addSubview:self.recordButton];
    [self addSubview:self.deleteButton];
    [self addSubview:self.playButton];
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(28 , 28));
        make.right.equalTo(self.mas_right).offset(-13);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.deleteButton.mas_left).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
}



#pragma mark-
#pragma mark- Private Methods


#pragma mark-
#pragma mark- Getters && Setters

- (UIButton *)recordButton{
    if (!_recordButton) {
        _recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_recordButton setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"Voice"] forState:UIControlStateNormal];
        [_recordButton setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"Voice-Cur"] forState:UIControlStateHighlighted];
        [_recordButton setTitleColor:[UIColor sa_colorC7] forState:UIControlStateNormal];
        _recordButton.titleLabel.font = [UIFont sa_fontS8:SAFontBoldTypeB2];
        [_recordButton addTarget:self action:@selector(pressRecordButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _recordButton;
}


- (UIButton *)playButton{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(pressPlayButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.titleLabel.font = [UIFont sa_fontS6:SAFontBoldTypeB1];
        _playButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _playButton.backgroundColor = [UIColor sa_colorC13];
        _playButton.layer.masksToBounds = YES;
        _playButton.layer.cornerRadius = 20;
        [_playButton setTitleColor:[UIColor sa_colorC7] forState:UIControlStateNormal];
        _playButton.hidden = YES;
    }
    return _playButton;
}

- (UIButton *)deleteButton{
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[SAComponentKitPrivate sa_componentKitImageByName:@"Delete"] forState:UIControlStateNormal];
        _deleteButton.hidden = YES;
        [_deleteButton addTarget:self action:@selector(pressDeleteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}


@end
