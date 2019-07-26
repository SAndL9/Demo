//
//  ViewController.m
//  断点下载
//
//  Created by 戴川 on 16/4/28.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import "ViewController.h"
#import "DCDownloadNetWord.h"

#define appStart @"appStart"
#define url @"http://data.vod.itc.cn/?rb=1&prot=1&key=jbZhEJhlqlUN-Wj_HEI8BjaVqKNFvDrn&prod=flash&pt=1&new=/42/154/nuLVh3RpRGqzMNmX9WiWAA.mp4"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *text;
@property(nonatomic,strong)DCDownloadNetWord *download;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建下载工作
    DCDownloadNetWord *download = [[DCDownloadNetWord alloc]initWithUrlString:url cacheCapacity:100 fileName:@"download1"];
    self.download = download;
    //设置初始进度值（创建之后startProgress属性就有值）
    self.progress.progress = self.download.startProgress;
    self.text.text = [NSString stringWithFormat:@"%.0f%%",self.download.startProgress * 100];

    download.downloadProgress = ^(long long currentBytes , long long totalBytes)
    {
      float pro =  (float)currentBytes / (float)totalBytes;
        self.progress.progress = pro;
        self.text.text = [NSString stringWithFormat:@"%.0f%%",pro * 100];
    };
}


- (IBAction)start:(id)sender {
    [self.download start];
}
- (IBAction)cancel:(id)sender {
    [self.download cancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
