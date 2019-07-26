//
//  DCDownloadNetWord.h
//  断点下载
//
//  Created by 戴川 on 16/4/28.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import <Foundation/Foundation.h>

// block的相关定义
typedef void (^downloadProgress_t)(long long currentBytes, long long totalBytes);
typedef void (^completion_t)(NSDictionary *headers, NSData *body);

@interface DCDownloadNetWord : NSObject
// 将block定义成属性
@property (nonatomic, copy) downloadProgress_t       downloadProgress;
@property (nonatomic, copy) completion_t             completion;
/**创建完对象后，该属性就有值*/
@property(nonatomic,assign)double startProgress;


// 初始化方法
- (instancetype)initWithUrlString:(NSString *)urlString cacheCapacity:(unsigned long long)capacity fileName:(NSString *)fileName;
- (void)start;
- (void)cancel;
@end
