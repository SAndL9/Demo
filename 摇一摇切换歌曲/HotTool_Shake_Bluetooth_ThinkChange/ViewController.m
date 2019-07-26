//
//  ViewController.m
//  HotTool_Shake_Bluetooth_ThinkChange
//
//  Created by 小超人 on 16/9/7.
//  Copyright © 2016年 云之君兮鹏. All rights reserved.
//
/*
 摇一摇：
   先在targets -> Build Phases -> Link Binary With Libraries里面添加AudioToolbox.framework；
   在模拟器中运行时，可以通过「Hardware」-「Shake Gesture」来测试「摇一摇」功能
 */

/*
 AudioservicesPlaySystemSound函数来播放简单的声音
 1.音频长度小于30秒
 2.格式只能是PCM或者IMA4
 3.文件必须被存储为.caf、.aif、或者.wav格式
 4.简单音频不能从内存播放，而只能是磁盘文件
 
 注意点： 无法循环播放声音，也无法控制立体声效果。可以设置一个回调函数，在音频播放结束时被调用，可以对音频对象做清理工作，以及通知你的程序播放结束。 
 */

#import "ViewController.h"

// 导入头文件
#import <AudioToolbox/AudioToolbox.h>

@interface ViewController ()

@end

// 当音频播放完毕会调用这个函数
// 在完成处理程序标签存储在 data 。需要到 __bridge 。
static void SoundFinished(SystemSoundID soundID, void *data){
    /*播放全部结束，因此释放所有资源 */
    AudioServicesDisposeSystemSoundID(soundID);
    NSLog(@"%s--->%@",__func__,(__bridge UIViewController *)data);
}

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 设置第一响应者
    [self becomeFirstResponder];
    
}

- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    // 注册系统音频ID
    SystemSoundID soundID;
    
    // 获取声音的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"59" ofType:@"m4a"];
    NSURL *soundUrl = [NSURL fileURLWithPath:path];
    
    // 根据路径创建
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundUrl, &soundID);
    /*
     
     *参数说明:
     * 1、刚刚播放完成自定义系统声音的ID
     * 2、回调函数（playFinished）执行的run Loop，NULL表示main run loop
     * 3、回调函数执行所在run loop的模式，NULL表示默认的run loop mode
     * 4、需要回调的函数
     * 5、传入的参数， 此参数会被传入回调函数里
     */
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, SoundFinished, (__bridge void *)self);
    
    // 开始播放
    AudioServicesPlaySystemSound (soundID);
    
   

    return;
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
    return;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        // 判断是否是摇动结束
        NSLog(@"摇动结束");
    }  
    return;  
}









@end
