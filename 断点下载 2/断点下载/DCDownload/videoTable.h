//
//  videoTable.h
//  断点下载
//
//  Created by 戴川 on 16/4/29.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import "FMDatabase.h"
#import "urlModel.h"

@interface videoTable : FMDatabase
+(instancetype)shareVideoTable;
-(void)saveDataWithDic:(NSDictionary *)videoDict;
-(void)deleteDataWithDic:(NSDictionary *)videoDict;
-(NSArray *)selectDataWithurl:(NSString *)urlStr;

@end
