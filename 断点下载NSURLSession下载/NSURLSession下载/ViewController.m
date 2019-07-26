//
//  ViewController.m
//  NSURLSession下载
//
//  Created by 张正 on 15/12/21.
//  Copyright © 2015年 歪哥. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVAssetImageGenerator.h>


@interface ViewController ()<NSURLSessionDownloadDelegate>
{
    NSURLSessionDownloadTask *_task; //  url会话下载任务, NSURLSessionTask的子类. 可恢复的下载任务
    NSURLSession *_session;          // 当前会话
    NSData *_data;                   // 已完成下载的量
    NSURLRequest *_request;
    UIProgressView *_progressView;
    UIImageView *_imageView;
    UIButton *_startButton;   // 开始按钮
    UIButton *_pauseButton;   // 暂停按钮
    UIButton *_recoverButton; // 恢复按钮
    
}

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSLog(@"%@", NSHomeDirectory());
    
    // 布局
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 30, 300, 300)];
    _imageView.backgroundColor = [UIColor colorWithRed:0.30 green:0.5 blue:0.5 alpha:0.7];
    [self.view addSubview:_imageView];
    _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(_imageView.frame.origin.x, _imageView.frame.origin.y + 400, 300, 40)];
    [self.view addSubview:_progressView];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _startButton.frame = CGRectMake(50, _imageView.frame.origin.y + 400 + 20, 50, 40);
    [_startButton setTitle:@"开始" forState:UIControlStateNormal];
    [_startButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _startButton.layer.borderWidth = 1;
    _startButton.layer.borderColor = [UIColor redColor].CGColor;
    _startButton.layer.cornerRadius = 5;
    [self.view addSubview:_startButton];
    
    _pauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _pauseButton.frame = CGRectMake(CGRectGetMaxX(_startButton.frame) + 10, CGRectGetMinY(_startButton.frame), 50, 40);
    [_pauseButton setTitle:@"暂停" forState:UIControlStateNormal];
    [_pauseButton addTarget:self action:@selector(pauseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _pauseButton.layer.borderWidth = 1;
    _pauseButton.layer.borderColor = [UIColor redColor].CGColor;
    _pauseButton.layer.cornerRadius = 5;
    _pauseButton.enabled = NO;
    [self.view addSubview:_pauseButton];
    
    _recoverButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _recoverButton.frame = CGRectMake(CGRectGetMaxX(_pauseButton.frame) + 10, CGRectGetMinY(_pauseButton.frame), 50, 40);
    [_recoverButton setTitle:@"恢复" forState:UIControlStateNormal];
    [_recoverButton addTarget:self action:@selector(recoverButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    _recoverButton.layer.borderWidth = 1;
    _recoverButton.layer.borderColor = [UIColor redColor].CGColor;
    _recoverButton.layer.cornerRadius = 5;
    _recoverButton.enabled = NO;
    [self.view addSubview:_recoverButton];
    
    
}

// 开始button事件
- (void)buttonAction:(UIButton *)button
{
    button.enabled = NO;
    _pauseButton.enabled = YES;
    
    
    // 创建会话对象之前需要创建一个会话配置器对象
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:@"http://video.szzhangchu.com/1442395443772_5176326090.mp4"];
    _request = [NSURLRequest requestWithURL:url];
    _task = [_session downloadTaskWithRequest:_request];
    
    // 重新开启下载
    [_task resume];
    NSLog(@"开始下载!");
}

// 暂停button事件
- (void)pauseButtonAction:(UIButton *)sender
{
    sender.enabled = NO;
    _recoverButton.enabled = YES;
    
    
    NSLog(@"暂停下载!");
    // * Cancels a download and calls a callback with resume data for later use.
    [_task cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        _data = resumeData; // 将数据赋给全局变量, 供下次重启判断使用
        
    }];
    _task = nil;
}

// 恢复button事件
- (void)recoverButtonAction:(UIButton *)sender
{
    sender.enabled = NO;
    _pauseButton.enabled = YES;
    
    
    NSLog(@"恢复下载!!");
    if (!_data) {
        NSURL *url = [NSURL URLWithString:@"http://video.szzhangchu.com/1442395443772_5176326090.mp4"];
        _request = [NSURLRequest requestWithURL:url];
        _task = [_session downloadTaskWithRequest:_request];
        
    } else {
        // * Creates a download task to resume a previously canceled or failed download.
        _task = [_session downloadTaskWithResumeData:_data];
    }
    // 重新开启下载
    [_task resume];
}



#pragma mark - NSURLSessionDownloadDelegate -
/* Sent periodically to notify the delegate of download progress. */
// 周期性地发送通知给代理对象(在下载过程中)
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"**********************************");
    NSLog(@"本次写入大小 ==== %lld", bytesWritten); // 本次写入大小
    NSLog(@" 已写入大小  === %lld", totalBytesWritten); // 已写入大小
    NSLog(@"  文件大小   == %lld", totalBytesExpectedToWrite); // 文件大小(需要写入的大小)
    CGFloat progress = totalBytesWritten * 1.0 / totalBytesExpectedToWrite;
    NSLog(@"    进程: %.3f     ", progress);
    // 进入主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        _progressView.progress = progress;
    });
}


/* Sent when a download task that has completed a download.  The delegate should
 * copy or move the file at the given location to a new location as it will be
 * removed when the delegate message returns. URLSession:task:didCompleteWithError: will
 * still be called.
 */
// 当下载任务完成的时候发送消息给代理对象 
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    NSLog(@"***************** 下载完成 *****************");
    NSLog(@"%@", location);
    
    // 将下载完成的文件移到Cache路径下.
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    NSString *filePath = [cachePath stringByAppendingPathComponent:@"waige.mp4"];
    NSURL *fileUrl = [NSURL fileURLWithPath:filePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // *^* //
    [fileManager moveItemAtURL:location toURL:fileUrl error:nil];
    
    // 进入主线程刷新UI
    dispatch_async(dispatch_get_main_queue(), ^{
        _pauseButton.enabled = NO;
        _imageView.image = [UIImage imageNamed:@"shot"];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"下载完成" preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        
        [alertController addAction:action];
        [self presentViewController:alertController animated:YES completion:nil];
    });
    
}


/* Sent as the last message related to a specific task.  Error may be
 * nil, which implies that no error occurred and this task is complete.
 */
// 无论下载成功或失败都会调用的方法，类似于try-catch-finally中的finally语句块的执行。如果下载成功，那么error参数的值为nil，否则下载失败，可以通过该参数查看出错信息：
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error{
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
