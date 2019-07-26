//
//  DCDownloadNetWord.m
//  断点下载
//
//  Created by 戴川 on 16/4/28.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import "DCDownloadNetWord.h"
#import "videoTable.h"

@interface DCDownloadNetWord ()<NSURLConnectionDelegate>
@property (nonatomic, assign) unsigned long long   totalLength;      // 文件总大小
@property (nonatomic, assign) unsigned long long   startDataLength;  // 本地存在文件的大小
@property (nonatomic, assign) unsigned long long   expectedLength;   // 从服务器期望文件的大小
@property (nonatomic, assign) unsigned long long   cacheCapacity;    // 缓存文件容量,以k为单位

@property (nonatomic, strong) NSURLConnection     *dataConncetion;   // 网络连接
@property (nonatomic, strong) NSDictionary        *responseHeaders;  // 网络连接头部信息
@property (nonatomic, strong) NSFileHandle        *file;             // 文件操作句柄
@property (nonatomic, strong) NSMutableData       *cacheData;        // 用于缓存的data数据
@property (nonatomic, strong) NSString            *url;              //请求链接
@property(nonatomic,strong)   NSMutableDictionary    *urlDic;
@property(nonatomic,assign)BOOL isStart;

@end

@implementation DCDownloadNetWord

-(NSMutableDictionary *)urlDic
{
    if(_urlDic == nil)
    {
        _urlDic = [[NSMutableDictionary alloc]init];
    }
    return _urlDic;
}
- (instancetype)initWithUrlString:(NSString *)urlString cacheCapacity:(unsigned long long)capacity fileName:(NSString *)fileName
{
    
    self = [super init];
    if (self)
    {
        self.url = urlString;
        
        self.isStart = NO;
        // 获取缓存容量
        if (capacity <= 0)
        {
            _cacheCapacity = 100 * 1024;
        }
        else
        {
            _cacheCapacity = capacity * 1024;
        }
        
        // 获取用于缓存的数据
        _cacheData = [NSMutableData new];
        
        // 获取文件名以及文件路径
        NSString *filePath = fileFromPath([NSString stringWithFormat:@"/Documents/%@", fileName]);
        
        // 记录文件起始位置
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
        {
            // 从文件中读取出已经下载好的文件的长度
            _startDataLength = [[NSData dataWithContentsOfFile:filePath] length];
        }
        else
        {
            // 不存在则创建文件
            _startDataLength = 0;
            [[NSFileManager defaultManager] createFileAtPath:filePath
                                                    contents:nil
                                                  attributes:nil];
        }
        
        // 打开写文件流
        _file = [NSFileHandle fileHandleForWritingAtPath:filePath];
                
    }
    return self;
}
-(double)startProgress
{
    if(_startProgress == 0)
    {
        NSArray *arr = [[videoTable shareVideoTable] selectDataWithurl:self.url];
        if(arr.count != 0)
        {
            urlModel *model = arr[0];
            _startProgress = model.downLoadProgress;
        }
    }
    return _startProgress;
}
- (void)start
{
    if(self.isStart == YES) return;
    //接受app退出通知(只有点过下载按钮才需要本地存储URL的信息)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(appWillExit) name:@"applicationWillTerminate" object:nil];
    
    // 创建一个网络请求
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    
    // 禁止读取本地缓存
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    // 设置断点续传(需要服务器支持)
    [request setValue:[NSString stringWithFormat:@"bytes=%llu-", _startDataLength]
   forHTTPHeaderField:@"Range"];

    // 开始创建连接
    self.dataConncetion = [[NSURLConnection alloc] initWithRequest:request
                                                          delegate:self
                                                  startImmediately:NO];
    
    [self.dataConncetion start];
    self.isStart = YES;
    
}
-(void)cancel
{
    [self.dataConncetion  cancel];
    self.dataConncetion = nil;
    self.isStart = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
        
        // 如果能获取到期望的数据长度就执行括号中的方法
        if ([r expectedContentLength] != NSURLResponseUnknownLength)
        {
            // 获取剩余要下载的
            _expectedLength  = [r expectedContentLength];
            
            // 计算出总共需要下载的
            _totalLength = _expectedLength + _startDataLength;
            
            // 获取头文件
            _responseHeaders = [r allHeaderFields];
        }
        else
        {
            NSLog(@"不支持断点下载");
        }
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    // 追加缓存数据
    [_cacheData appendData:theData];
    
    // 如果该缓存数据的大小超过了指定的缓存大小
    if ([_cacheData length] >= _cacheCapacity)
    {
        // 移动到文件结尾
        [_file seekToEndOfFile];
        
        // 在文件末尾处追加数据
        [_file writeData:_cacheData];
        
        // 清空缓存数据
        [_cacheData setLength:0];
    }
    
    // 当前已经下载的所有数据的总量
    _startDataLength += [theData length];
    
    // 如果指定了block
    if (_downloadProgress)
    {
        _downloadProgress(_startDataLength, _totalLength);
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // 移动到文件结尾
    [_file seekToEndOfFile];
    
    // 在文件末尾处追加最后的一点缓存数据
    [_file writeData:_cacheData];
    
    // 清空缓存
    [_cacheData setLength:0];
    
    //下载完删除该条记录
    [[videoTable shareVideoTable]deleteDataWithDic:self.urlDic];
    
    NSLog(@"下载完成哦");
}

-(void)appWillExit
{
        float progress = (float)_startDataLength / (float)_totalLength;
        [self.urlDic setObject:@(progress) forKey:@"progress"];
        [self.urlDic setObject:self.url forKey:@"url"];

        
        //删除之前的数据
        [[videoTable shareVideoTable] deleteDataWithDic:self.urlDic];
        //保存新数据
        [[videoTable shareVideoTable] saveDataWithDic:self.urlDic];
}
NS_INLINE NSString * fileFromPath(NSString *filePath)
{
    return [NSHomeDirectory() stringByAppendingString:filePath];
}


@end
