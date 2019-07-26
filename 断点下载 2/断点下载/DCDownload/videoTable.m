//
//  videoTable.m
//  断点下载
//
//  Created by 戴川 on 16/4/29.
//  Copyright © 2016年 戴川. All rights reserved.
//

#import "videoTable.h"
#import "FMDB.h"
@implementation videoTable
+(instancetype)shareVideoTable
{
    static videoTable *video = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 1.获得数据库文件的路径
        NSString *doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filename = [doc stringByAppendingPathComponent:@"url.sqlite"];
        NSLog(@"------%@",filename);
        // 2.得到数据库
        video = [videoTable databaseWithPath:filename];
        
        // 3.打开数据库
        if ([video open]) {
            // 4.创表
            BOOL result = [video executeUpdate:@"CREATE TABLE IF NOT EXISTS t_url (id integer PRIMARY KEY AUTOINCREMENT, url TEXT,progress REAL );"];
            if (result) {
                NSLog(@"成功创表");
            } else {
                NSLog(@"创表失败");
            }
        }
    });
    return video;
}

-(void)saveDataWithDic:(NSDictionary *)videoDict
{
   BOOL yes = [self executeUpdate:@"INSERT INTO t_url (url,progress) VALUES (?,?);",videoDict[@"url"],videoDict[@"progress"]];
    if(yes)
    {
        NSLog(@"存储成功");
    }
}
-(NSArray *)selectDataWithurl:(NSString *)urlStr
{
    NSMutableArray *marr = [[NSMutableArray alloc]init];
    FMResultSet *resultSet = nil;
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM t_url WHERE url = '%@';",urlStr];
    resultSet = [self executeQuery:sql];
    while(resultSet.next){
        //获取数据
        double progress = [resultSet doubleForColumn:@"progress"];
        NSString *url = [resultSet objectForColumnName:@"url"];
        
        //转模型
        urlModel *model = [[urlModel alloc]init];
        model.downLoadProgress = progress;
        model.url = url;
        
        //添加到模型数组中
        [marr addObject:model];
    }
    return  marr;
}
//删除
-(void)deleteDataWithDic:(NSDictionary *)videoDict
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_url WHERE url = '%@';",videoDict[@"url"]];
    BOOL yes = [self executeUpdate:sql];
    if(yes)
    {
        NSLog(@"删除成功");
    }

}
@end
