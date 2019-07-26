//
//  SAUploadReasonDataServiceRequest.m
//  SmallAnimal
//
//  Created by lilei on 16/11/16.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.
//

#import "SAUploadReasonDataServiceRequest.h"

@implementation SAUploadReasonDataServiceRequest
- (NSString *)requestMethodName{
#ifdef UAT
    return @"https://w3u.wwwarehouse.com/api/base/file/upload";
#elif UATRELEASE
    return @"https://w3u.wwwarehouse.com/api/base/file/upload";
#elif RELEASE
    return @"https://w3p.wwwarehouse.com/api/base/file/upload";
#else
    return @"http://192.168.6.78:8888/file/upload";
#endif
}

- (BOOL)isCorrectWithResponseData:(id)responseData{
    
    return [responseData[@"code"] integerValue] == 0 ? YES : NO;
}

- (AFConstructingBlock)constructingBodyBlock{
    
    return  ^(id<AFMultipartFormData> formData){
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.mp3", str];
        
        [formData appendPartWithFileData:_data name:@"file" fileName:fileName mimeType:@"mp3"];
    };
    
}

@end
