//
//  ViewController.h
//  AudioRecorder
//
//  Created by 淘饭饭 on 13-6-7.
//  Copyright (c) 2013年 淘饭饭. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface ViewController : UIViewController<AVAudioRecorderDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSURL *urlPlay;
    
}
@property (retain, nonatomic) IBOutlet UIButton *btn;
@property (retain, nonatomic) IBOutlet UIImageView *imageView;
@property (retain, nonatomic) IBOutlet UIButton *playBtn;
@property (retain, nonatomic) AVAudioPlayer *avPlay;
@end
