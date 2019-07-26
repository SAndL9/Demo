//
//  SAUploadReasonDataServiceRequest.h
//  SmallAnimal
//
//  Created by lilei on 16/11/16.
//  Copyright © 2016年 浙江网仓科技有限公司. All rights reserved.

#import <SANetwork/SANetwork.h>

/**
 上传资源预测调整原因录音
 */
@interface SAUploadReasonDataServiceRequest : SANetworkRequest<SANetworkRequestConfigProtocol>

/**
 录音文件，NSData类型
 */
@property (nonatomic, strong) NSData *data;

@end
