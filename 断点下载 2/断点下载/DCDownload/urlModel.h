//
//  urlModel.h
//  断点下载
//
//  Created by 戴川 on 16/4/29.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface urlModel : NSObject

@property(nonatomic,copy)NSString *url;
@property(nonatomic,assign)double downLoadProgress;

@end
