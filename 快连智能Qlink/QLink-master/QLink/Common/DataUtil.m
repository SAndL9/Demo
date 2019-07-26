//
//  DataUtil.m
//  QLink
//
//  Created by SANSAN on 14-9-20.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "DataUtil.h"
#import "FMDatabase.h"
#include <arpa/inet.h>
#include <netdb.h>

#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import "Reachability.h"

@implementation DataUtil

//获取沙盒地址
+(NSString *)getDirectoriesInDomains
{
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [dirPaths objectAtIndex:0];
    return docsDir;
}

//检测是否为空
+(BOOL)checkNullOrEmpty:(NSString *)str
{
    if (!str || [str isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

//判断节点类型并且转换为数组
+(NSArray *)changeDicToArray:(NSObject *)obj
{
    if ([obj isKindOfClass:[NSDictionary class]]) {
        return [NSArray arrayWithObject:(NSDictionary *)obj];
    }else
    {
        return (NSArray *)obj;
    }
}

//判断是否为nil,nil则返回空
+(NSString *)getDefaultValue:(NSString *)value
{
    if ([DataUtil checkNullOrEmpty:value]) {
        return  @"";
    }else{
        return value;
    }
}

//全局变量
+(GlobalAttr *)shareInstanceToRoom
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *globalAttrDic = [ud objectForKey:Global_Room_Attr];
    
    GlobalAttr *obj = [[GlobalAttr alloc] init];
    obj.LayerId = [globalAttrDic objectForKey:@"LayerId"];
    obj.RoomId = [globalAttrDic objectForKey:@"RoomId"];
    obj.HouseId = [globalAttrDic objectForKey:@"HouseId"];
    
    return obj;
}

//更新房间号
+(void)setGlobalAttrRoom:(NSString *)roomId
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *globalAttrDic = [ud objectForKey:Global_Room_Attr];
    NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:globalAttrDic];
    [newDic setObject:roomId forKey:@"RoomId"];
    [ud setObject:newDic forKey:Global_Room_Attr];
    [ud synchronize];
}

//设置全局模式
+(void)setGlobalModel:(NSString *)global
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:global forKey:Global_Model_Attr];
    [ud synchronize];
}

//获取全局模式类型
+(NSString *)getGlobalModel
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *model = [ud objectForKey:Global_Model_Attr];
    return model;
}

//设置是否添加场景
+(void)setGlobalIsAddSence:(BOOL)isAdd
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:isAdd forKey:Global_Model_IsAddSence];
    [ud synchronize];
}

//获取是否添加场景模式
+(BOOL)getGlobalIsAddSence
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL bResult = [[ud objectForKey:Global_Model_IsAddSence] boolValue];
    return bResult;
}

+(NSStringEncoding)getGB2312Code
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    return enc;
}

//设置编辑的场景id
+(void)setUpdateInsertSenceInfo:(NSString *)senceId
                   andSenceName:(NSString *)senceName
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:senceId forKey:@"SenceId"];
    [ud setObject:senceName forKey:@"SenceName"];
    [ud synchronize];
}

//设置udp端口
+(void)setUdpPort:(NSString *)port
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:port forKey:@"port"];
    [ud synchronize];
}

//获取udp端口
+(NSString *)getUdpPort
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *model = [ud objectForKey:@"port"];
    return model;
}

+ (NSString *)hexStringFromString:(NSString *)string
{
    NSData *myD = [string dataUsingEncoding:NSUTF8StringEncoding];
    Byte *bytes = (Byte *)[myD bytes];
    //下面是Byte 转换为16进制。
    NSString *hexStr=@"";
    for(int i=0;i<[myD length];i++)
        
    {
        NSString *newHexStr = [NSString stringWithFormat:@"%x",bytes[i]&0xff];///16进制数
        
        if([newHexStr length]==1)
            
            hexStr = [NSString stringWithFormat:@"%@0%@",hexStr,newHexStr];
        
        else
            
            hexStr = [NSString stringWithFormat:@"%@%@",hexStr,newHexStr]; 
    } 
    return hexStr; 
}

+(NSString *)localWiFiIPAddress
{
    BOOL success;
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    success = getifaddrs(&addrs) == 0;
    if (success) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0)
            {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                if ([name isEqualToString:@"en0"])  // Wi-Fi adapter
                    return [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)cursor->ifa_addr)->sin_addr)];
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return nil;
}

+(BOOL) isWifiNewWork{
    BOOL isWifi = NO;
    Reachability *r = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            isWifi = NO;
            //            NSLog(@"没有网络");
            break;
        case ReachableViaWWAN:
            isWifi = NO;
            //            NSLog(@"正在使用3G网络");
            break;
        case ReachableViaWiFi:
            isWifi = YES;
            //            NSLog(@"正在使用wifi网络");
            break;
    }
    
    return isWifi;
    
}

@end

/************************************************************************************/

@implementation Member

//获取Ud对象用户信息
+(Member *)getMember
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *memberDict = [ud objectForKey:@"MEMBER_UD"];
    if (!memberDict) {
        return nil;
    }
    
    Member *memberObj = [[Member alloc] init];
    memberObj.uName = [memberDict objectForKey:@"uName"];
    memberObj.uPwd = [memberDict objectForKey:@"uPwd"];
    memberObj.uKey = [memberDict objectForKey:@"uKey"];
    memberObj.isRemeber = [[memberDict objectForKey:@"isRemeber"] boolValue];
    
    return memberObj;
}

//设置对象信息
+(void)setUdMember:(NSString *)uName
           andUPwd:(NSString *)uPwd
           andUKey:(NSString *)uKey
      andIsRemeber:(BOOL)isRemeber
{
    NSMutableDictionary *memberDict = [[NSMutableDictionary alloc] init];
    [memberDict setObject:uName forKey:@"uName"];
    [memberDict setObject:uPwd forKey:@"uPwd"];
    [memberDict setObject:uKey forKey:@"uKey"];
    [memberDict setObject:[NSNumber numberWithBool:isRemeber] forKey:@"isRemeber"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:memberDict forKey:@"MEMBER_UD"];
    [ud synchronize];
}

@end

/*************************************** 配置信息 *********************************************/

@implementation Config

//获取配置信息
+(Config *)getConfig
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary *objDic = [ud objectForKey:@"CONFIG_UD"];
    if (!objDic) {
        return nil;
    }
    
    Config *obj = [[Config alloc] init];
    obj.configVersion = [objDic objectForKey:@"configVersion"];
    obj.isSetSign = [[objDic objectForKey:@"isSetSign"] boolValue];
    obj.isWriteCenterControl = [[objDic objectForKey:@"isWriteCenterControl"] boolValue];
    obj.isSetIp = [[objDic objectForKey:@"isSetIp"] boolValue];
    obj.isBuyCenterControl = [[objDic objectForKey:@"isBuyCenterControl"] boolValue];
    
    return obj;
}

//设置配置信息
+(void)setConfigArr:(NSArray *)configArr
{
    NSMutableDictionary *memberDict = [[NSMutableDictionary alloc] init];
    
    //配置文件版本
    [memberDict setObject:[configArr objectAtIndex:1] forKey:@"configVersion"];
    
    //是否配置过标记，未配置则强制进入配置模式
    NSString *sIsSetSign = [configArr objectAtIndex:3];
    BOOL bIsSetSign = NO;
    if ([[sIsSetSign uppercaseString] isEqualToString:@"TRUE"]) {
        bIsSetSign = YES;
    }
    [memberDict setObject:[NSNumber numberWithBool:bIsSetSign] forKey:@"isSetSign"];
    
    //是否写入中控
    NSString *sIsWriteCenterControl = [configArr objectAtIndex:4];
    BOOL bIsWriteCenterControl = NO;
    if ([[sIsWriteCenterControl uppercaseString] isEqualToString:@"TRUE"]) {
        bIsWriteCenterControl = YES;
    }
    [memberDict setObject:[NSNumber numberWithBool:bIsWriteCenterControl] forKey:@"isWriteCenterControl"];
    
    //是否设置 IP
    NSString *sIsSetIp = [configArr objectAtIndex:5];
    BOOL bIsSetIp = NO;
    if ([[sIsSetIp uppercaseString] isEqualToString:@"TRUE"]) {
        bIsSetIp = YES;
    }
    [memberDict setObject:[NSNumber numberWithBool:bIsSetIp] forKey:@"isSetIp"];
    
    //是否购买中控
    NSString *sIsBuyCenterControl = [configArr objectAtIndex:6];
    BOOL bIsBuyCenterControl = NO;
    if ([[sIsBuyCenterControl uppercaseString] isEqualToString:@"TRUE"]) {
        bIsBuyCenterControl = YES;
    }
    [memberDict setObject:[NSNumber numberWithBool:bIsBuyCenterControl]forKey:@"isBuyCenterControl"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:memberDict forKey:@"CONFIG_UD"];
    [ud synchronize];
}

//设置配置信息
+(void)setConfigObj:(Config *)obj
{
    NSMutableDictionary *memberDict = [[NSMutableDictionary alloc] init];
    
    //配置文件版本
    [memberDict setObject:obj.configVersion forKey:@"configVersion"];
    
    //是否配置过标记，未配置则强制进入配置模式
    [memberDict setObject:[NSNumber numberWithBool:obj.isSetSign] forKey:@"isSetSign"];
    
    //是否写入中控
    [memberDict setObject:[NSNumber numberWithBool:obj.isWriteCenterControl] forKey:@"isWriteCenterControl"];
    
    //是否设置 IP
    [memberDict setObject:[NSNumber numberWithBool:obj.isSetIp] forKey:@"isSetIp"];
    
    //是否购买中控
    [memberDict setObject:[NSNumber numberWithBool:obj.isBuyCenterControl]forKey:@"isBuyCenterControl"];
    
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    [ud setObject:memberDict forKey:@"CONFIG_UD"];
    [ud synchronize];
}

//临时变量,用于对比本地配置属性
+(Config *)getTempConfig:(NSArray *)configArr
{
    Config *obj = [[Config alloc] init];
    
    obj.configVersion = [configArr objectAtIndex:1];
    
    //是否配置过标记，未配置则强制进入配置模式
    NSString *sIsSetSign = [configArr objectAtIndex:3];
    BOOL bIsSetSign = NO;
    if ([[sIsSetSign uppercaseString] isEqualToString:@"TRUE"]) {
        bIsSetSign = YES;
    }
    obj.isSetSign = bIsSetSign;
    
    //是否写入中控
    NSString *sIsWriteCenterControl = [configArr objectAtIndex:4];
    BOOL bIsWriteCenterControl = NO;
    if ([[sIsWriteCenterControl uppercaseString] isEqualToString:@"TRUE"]) {
        bIsWriteCenterControl = YES;
    }
    obj.isWriteCenterControl = bIsWriteCenterControl;
    
    //是否设置 IP
    NSString *sIsSetIp = [configArr objectAtIndex:5];
    BOOL bIsSetIp = NO;
    if ([[sIsSetIp uppercaseString] isEqualToString:@"TRUE"]) {
        bIsSetIp = YES;
    }
    obj.isSetIp = bIsSetIp;
    
    //是否购买中控
    NSString *sIsBuyCenterControl = [configArr objectAtIndex:6];
    BOOL bIsBuyCenterControl = NO;
    if ([[sIsBuyCenterControl uppercaseString] isEqualToString:@"TRUE"]) {
        bIsBuyCenterControl = YES;
    }
    obj.isBuyCenterControl = bIsBuyCenterControl;
    
    return obj;
}

@end

/************************************************************************************/

@implementation SQLiteUtil

//获取数据库对象
+(FMDatabase *)getDB
{
    NSString *dbPath = [[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:DBNAME];
    FMDatabase *db = [FMDatabase databaseWithPath:dbPath];
    
    return db;
}

//中控信息sql
+(NSString *)connectControlSql:(Control *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO CONTROL (\"Ip\", \"SendType\", \"Port\", \"Domain\", \"Url\", \"Updatever\",\"Jsname\",\"Jstel\",\"Jsuname\",\"Jsaddess\", \"Jslogo\", \"Jsqq\",\"OpenPic\") VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\")",obj.Ip, obj.SendType, obj.Port, obj.Domain, obj.Url, obj.Updatever,obj.Jsname,obj.Jstel,obj.Jsuname,obj.Jsaddess,obj.Jslogo,obj.Jsqq,obj.OpenPic];
    
    return sql;
}

//设备表sql拼接
+(NSString *)connectDeviceSql:(Device *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO DEVICE (\"DeviceId\" , \"DeviceName\" , \"Type\" , \"HouseId\" , \"LayerId\" , \"RoomId\") VALUES (\"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\")",obj.DeviceId, obj.DeviceName,obj.Type, obj.HouseId, obj.LayerId, obj.RoomId];
    return sql;
}

//命令表sql拼接
+(NSString *)connectOrderSql:(Order *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO ORDERS (\"OrderId\", \"OrderName\", \"Type\", \"SubType\" , \"OrderCmd\", \"Address\", \"StudyCmd\",\"OrderNo\", \"HouseId\", \"LayerId\", \"RoomId\", \"DeviceId\") VALUES  (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\" , \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\")",obj.OrderId, obj.OrderName,obj.Type, obj.SubType , obj.OrderCmd,obj.Address, obj.StudyCmd,obj.OrderNo, obj.HouseId, obj.LayerId, obj.RoomId, obj.DeviceId];
    return sql;
}

//房间表sql拼接
+(NSString *)connectRoomSql:(Room *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO ROOM (\"RoomId\", \"RoomName\", \"HouseId\", \"LayerId\") VALUES (\"%@\", \"%@\", \"%@\", \"%@\")",obj.RoomId,obj.RoomName,obj.HouseId, obj.LayerId];
    return sql;
}

//场景表sql拼接
+(NSString *)connectSenceSql:(Sence *)obj
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO SENCE (\"SenceId\" , \"SenceName\" , \"Macrocmd\" , \"Type\" , \"CmdList\" , \"HouseId\" , \"LayerId\" , \"RoomId\") VALUES (\"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\" , \"%@\")",obj.SenceId,obj.SenceName,obj.Macrocmd, obj.Type,obj.CmdList, obj.HouseId,obj.LayerId,obj.RoomId];
    return sql;
}

//获取当前版本号
+(NSString *)getCurVersionNo
{
    FMDatabase *db = [self getDB];
 
    NSString *versionNo = @"";
    NSString *sql = @"SELECT UPDATEVER FROM CONTROL LIMIT 1";
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            versionNo = [rs stringForColumn:@"Updatever"];
            
            break;
        }
        
        [rs close];
    }
    
    [db close];
    
    return versionNo;
}

//获取设置当前默认楼层和房间号码
+(void)setDefaultLayerIdAndRoomId
{
    FMDatabase *db = [self getDB];
    
    NSString *sql = @"SELECT MIN(LAYERID) AS LayerId,ROOMID,HOUSEID FROM (SELECT RoomId,LayerId,HouseId FROM ROOM GROUP BY LAYERID ORDER BY LAYERID ASC)";
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            [dic setObject:[DataUtil getDefaultValue:[rs stringForColumn:@"LayerId"]] forKey:@"LayerId"];
            [dic setObject:[DataUtil getDefaultValue:[rs stringForColumn:@"RoomId"]] forKey:@"RoomId"];
            [dic setObject:[DataUtil getDefaultValue:[rs stringForColumn:@"HouseId"]] forKey:@"HouseId"];
            
            NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
            [ud setObject:dic forKey:Global_Room_Attr];
            [ud synchronize];
            
            break;
        }
        
        [rs close];
    }
    
    [db close];
}

//清除数据
+(void)clearData
{
    FMDatabase *db = [self getDB];
    
    [db open];
    
    [db executeUpdate:@"DELETE FROM CONTROL"];
    [db executeUpdate:@"DELETE FROM DEVICE"];
    [db executeUpdate:@"DELETE FROM ORDERS"];
    [db executeUpdate:@"DELETE FROM ROOM"];
    [db executeUpdate:@"DELETE FROM SENCE"];
    
    [db close];
    
    //删除文件
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *logoPath = [[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:@"logo.png"];
    NSString *defaultPath = [[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:@"help.png"];
    [fileManager removeItemAtPath:logoPath error:&error];
    [fileManager removeItemAtPath:defaultPath error:&error];
}

//执行sql语句事物
+(BOOL)handleConfigToDataBase:(NSArray *)sqlArr
{
    FMDatabase *db = [self getDB];
    
    [db open];
    BOOL bResult = [self addToDataBase:db andSQL:sqlArr];
    [db close];
    
    return bResult;
}

//执行添加
+(BOOL)addToDataBase:(FMDatabase *)db andSQL:(NSArray *)sqlArr
{
    BOOL bResult = FALSE;
    
    [db beginTransaction];
    
    for (NSString *sql in sqlArr) {
        bResult = [db executeUpdate:sql];
    }
    
    [db commit];
    
    return bResult;
}

//获取场景列表
+(NSArray *)getSenceList:(NSString *)houseId
              andLayerId:(NSString *)layerId
              andRoomId:(NSString *)roomId
{
    NSMutableArray *senceArr = [NSMutableArray array];
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT S.*,I.NewType FROM SENCE S LEFT JOIN ICON I ON S.SENCEID=I.DEVICEID AND I.TYPE='macro' WHERE S.HOUSEID='%@' AND S.LAYERID='%@' AND S.ROOMID='%@'",houseId,layerId,roomId];

    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Sence *obj = [Sence setSenceId:[rs stringForColumn:@"SenceId"]
                              andSenceName:[rs stringForColumn:@"SenceName"]
                               andMacrocmd:[rs stringForColumn:@"Macrocmd"]
                                   andType:[rs stringForColumn:@"Type"]
                                andCmdList:[rs stringForColumn:@"CmdList"]
                                andHouseId:[rs stringForColumn:@"HouseId"]
                                andLayerId:[rs stringForColumn:@"LayerId"]
                                 andRoomId:[rs stringForColumn:@"RoomId"]
                               andIconType:[rs stringForColumn:@"NewType"]];
            [senceArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    //add图标
    Sence *senceObj = [[Sence alloc] init];
    senceObj.Type = SANSANADDMACRO;
    senceObj.SenceName = @"添加场景";
    [senceArr addObject:senceObj];
    
    return senceArr;
}

//获取具体场景命令集合，用于紧急模式下发送
+(NSMutableArray *)getOrderBySenceId:(NSString *)senceId
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT SENCEID, SENCENAME, CMDLIST FROM SENCE WHERE SENCEID='%@'",senceId];
    
    Sence *obj = [[Sence alloc] init];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]){
            obj.SenceId = [rs stringForColumn:@"SenceId"];
            obj.SenceName = [rs stringForColumn:@"SenceName"];
            obj.CmdList = [rs stringForColumn:@"CmdList"];
        }
        
        [rs close];
        
        NSArray *cmdListArr = [obj.CmdList componentsSeparatedByString:@"|"];
        NSArray *orderIdArr = [[cmdListArr objectAtIndex:0] componentsSeparatedByString:@","];
        NSArray *timerArr = [[cmdListArr objectAtIndex:1] componentsSeparatedByString:@","];
        
        for (int i = 0; i < [orderIdArr count];i ++) {
            NSString *subSql = [NSString stringWithFormat:@"SELECT O.ORDERID,O.ORDERNAME,O.ORDERCMD,O.ADDRESS,D.DEVICEID,D.DEVICENAME,D.TYPE,I.NEWTYPE FROM ORDERS O LEFT JOIN DEVICE D ON O.DEVICEID=D.DEVICEID  LEFT JOIN ICON I ON O.DEVICEID=I.DEVICEID  WHERE O.ORDERID='%@'",[orderIdArr objectAtIndex:i]];
            FMResultSet *rs = [db executeQuery:subSql];
            if ([rs next])
            {
                Sence *subobj = [[Sence alloc] init];
                subobj.SenceId = [rs stringForColumn:@"DeviceId"];
                subobj.OrderId = [rs stringForColumn:@"OrderId"];
                subobj.OrderCmd = [rs stringForColumn:@"OrderCmd"];
                subobj.Address = [rs stringForColumn:@"Address"];
                subobj.SenceName = [rs stringForColumn:@"DeviceName"];
                subobj.OrderName = [rs stringForColumn:@"OrderName"];
                subobj.Type = [rs stringForColumn:@"Type"];
                subobj.IconType = [rs stringForColumn:@"NewType"];
                subobj.Timer = [timerArr objectAtIndex:i];
                [orderArr addObject:subobj];
            }
            
            [rs close];
        }
    }
    
    [db close];
    
    return orderArr;
}

//更新场景下命令和时间
+(BOOL)updateCmdListBySenceId:(NSString *)senceId andSenceName:(NSString *)senceName andCmdList:(NSString *)cmdLists
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE SENCE SET CMDLIST='%@' , SENCENAME='%@' WHERE SENCEID='%@'",cmdLists,senceName,senceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//添加场景
+(BOOL)insertSence:(Sence *)obj
{
    GlobalAttr *globalAttr = [DataUtil shareInstanceToRoom];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO SENCE (SENCEID,SENCENAME,MACROCMD,TYPE,CMDLIST,HOUSEID,LAYERID,ROOMID) VALUES('%@','%@','%@','%@','%@','%@','%@','%@')",obj.SenceId,obj.SenceName,obj.Macrocmd,@"macro",obj.CmdList,globalAttr.HouseId,globalAttr.LayerId,globalAttr.RoomId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取设备列表
+(NSArray *)getDeviceList:(NSString *)houseId
              andLayerId:(NSString *)layerId
               andRoomId:(NSString *)roomId
{
    NSMutableArray *deviceArr = [NSMutableArray array];
    
    FMDatabase *db = [self getDB];
    
    NSString *lightKeyWord = @"%light%";
    
    NSString *sql = [NSString stringWithFormat:@"SELECT D.*,I.NewType FROM DEVICE D LEFT JOIN ICON I ON D.DEVICEID=I.DEVICEID AND I.TYPE !='%@' WHERE D.HOUSEID='%@' AND D.LAYERID='%@' AND D.ROOMID='%@' AND D.TYPE NOT LIKE '%@'",MACRO,houseId,layerId,roomId,lightKeyWord];
    
    if ([db open]) {
        
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Device *obj = [Device setDeviceId:[rs stringForColumn:@"DeviceId"]
                                andDeviceName:[rs stringForColumn:@"DeviceName"]
                                      andType:[rs stringForColumn:@"Type"]
                                   andHouseId:[rs stringForColumn:@"HouseId"]
                                   andLayerId:[rs stringForColumn:@"LayerId"]
                                    andRoomId:[rs stringForColumn:@"RoomId"]
                                  andIconType:[rs stringForColumn:@"NewType"]];
            [deviceArr addObject:obj];
        }
        
        [rs close];
    }
    
    sql = @"SELECT COUNT(*) FROM DEVICE WHERE TYPE LIKE '%light%'";
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            int totalCount = [rs intForColumnIndex:0];
            if (totalCount > 0) {
                Device *obj = [Device setDeviceId:@""
                                    andDeviceName:@"照明"
                                          andType:@"light"
                                       andHouseId:@""
                                       andLayerId:@""
                                        andRoomId:@""
                                      andIconType:nil];
                [deviceArr addObject:obj];
            }
        }
    }
    
    [db close];
    
    //add图标
    Device *deviceObj = [[Device alloc] init];
    deviceObj.Type = SANSANADDDEVICE;
    deviceObj.DeviceName = @"添加设备";
    [deviceArr addObject:deviceObj];
    
    return deviceArr;
}

//更新图标
+(BOOL)changeIcon:(NSString *)deviceId
          andType:(NSString *)type
       andNewType:(NSString *)newType
{
    BOOL bResult = FALSE;
    
    NSString *sql = [NSString stringWithFormat:@"REPLACE INTO ICON (DEVICEID,TYPE,NEWTYPE) VALUES ('%@','%@','%@')",deviceId,type,newType];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        bResult = [db executeUpdate:sql];
    }
    
    [db close];
    
    return bResult;
}

//获取房间列表
+(NSArray *)getRoomList:(NSString *)houseId
             andLayerId:(NSString *)layerId
{
    NSMutableArray *roomArr = [NSMutableArray array];
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ROOM WHERE HOUSEID='%@' AND LAYERID='%@'",houseId,layerId];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Room *obj = [Room setRoomId:[rs stringForColumn:@"RoomId"]
                            andRoomName:[rs stringForColumn:@"RoomName"]
                             andHouseId:[rs stringForColumn:@"HouseId"]
                             andLayerId:[rs stringForColumn:@"LayerId"]];
            [roomArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return roomArr;
}

//重命名场景
+(BOOL)renameSenceName:(NSString *)senceId
            andNewName:(NSString *)newName
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE SENCE SET SENCENAME='%@' WHERE SENCEID='%@'",newName,senceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//重命名设备
+(BOOL)renameDeviceName:(NSString *)deviceId
            andNewName:(NSString *)newName
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE DEVICE SET DEVICENAME='%@' WHERE DEVICEID='%@'",newName,deviceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//删除场景
+(BOOL)removeSence:(NSString *)senceId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM SENCE WHERE SENCEID='%@'",senceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//删除设备
+(BOOL)removeDevice:(NSString *)deviceId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM DEVICE WHERE DEVICEID='%@'",deviceId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取该设备下所有命令类型
+(NSArray *)getOrderTypeGroupOrder:(NSString *)deviceId
{
    NSMutableArray *typeArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT DEVICEID,TYPE FROM ORDERS WHERE DEVICEID='%@' GROUP BY TYPE ORDER BY CAST(ORDERNO AS INT) ASC",deviceId];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Order *obj = [[Order alloc] init];
            obj.DeviceId = [rs stringForColumn:@"DeviceId"];
            obj.Type = [rs stringForColumn:@"Type"];
            [typeArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return typeArr;
}

//获取指定设备下指定类型的命令集合,用于非照明设备命令查询
+(NSArray *)getOrderListByDeviceId:(NSString *)deviceId andType:(NSString *)type
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ORDERS WHERE DEVICEID='%@' AND TYPE='%@' ORDER BY SUBTYPE ASC",deviceId,type];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Order *obj = [Order setOrderId:[rs stringForColumn:@"OrderId"]
                                   andOrderName:[rs stringForColumn:@"OrderName"]
                                        andType:[rs stringForColumn:@"Type"]
                                     andSubType:[rs stringForColumn:@"SubType"]
                                    andOrderCmd:[rs stringForColumn:@"OrderCmd"]
                                     andAddress:[rs stringForColumn:@"Address"]
                                    andStudyCmd:[rs stringForColumn:@"StudyCmd"]
                                     andOrderNo:[rs stringForColumn:@"OrderNo"]
                                     andHouseId:[rs stringForColumn:@"HouseId"]
                                     andLayerId:[rs stringForColumn:@"LayerId"]
                                      andRoomId:[rs stringForColumn:@"RoomId"]
                                    andDeviceId:[rs stringForColumn:@"DeviceId"]];
            [orderArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return orderArr;
}

//获取指定设备下指定类型的命令集合,用于照明设备命令查询
+(NSArray *)getOrderListByDeviceId:(NSString *)deviceId
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT * FROM ORDERS WHERE DEVICEID='%@' ORDER BY SUBTYPE ASC",deviceId];
    
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            Order *obj = [Order setOrderId:[rs stringForColumn:@"OrderId"]
                              andOrderName:[rs stringForColumn:@"OrderName"]
                                   andType:[rs stringForColumn:@"Type"]
                                andSubType:[rs stringForColumn:@"SubType"]
                               andOrderCmd:[rs stringForColumn:@"OrderCmd"]
                                andAddress:[rs stringForColumn:@"Address"]
                               andStudyCmd:[rs stringForColumn:@"StudyCmd"]
                                andOrderNo:[rs stringForColumn:@"OrderNo"]
                                andHouseId:[rs stringForColumn:@"HouseId"]
                                andLayerId:[rs stringForColumn:@"LayerId"]
                                 andRoomId:[rs stringForColumn:@"RoomId"]
                               andDeviceId:[rs stringForColumn:@"DeviceId"]];
            [orderArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return orderArr;
}

//获取当前房间下所有的照明设备
+(NSArray *)getLightDevice:(NSString *)houseId
                andLayerId:(NSString *)layerId
                 andRoomId:(NSString *)roomId
{
    NSMutableArray *deviceArr = [NSMutableArray array];
    
    NSString *sql = [NSString stringWithFormat:@"SELECT DeviceId,DeviceName,Type FROM DEVICE WHERE TYPE IN ('light','light_1','light_check') AND HOUSEID='%@' AND LAYERID='%@' AND ROOMID='%@' ORDER BY TYPE ASC",houseId,layerId,roomId];
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            Device *obj = [[Device alloc] init];
            obj.DeviceId = [rs stringForColumn:@"DeviceId"];
            obj.DeviceName = [rs stringForColumn:@"DeviceName"];
            obj.Type = [rs stringForColumn:@"Type"];
            
            [deviceArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return deviceArr;
}

//获取当前房间下所有的照明设备(除了type＝‘light’)，考虑到先加载type＝‘light’的照明控件，所以分开取数据
+(NSArray *)getLightComplexDevice:(NSString *)houseId
                andLayerId:(NSString *)layerId
                 andRoomId:(NSString *)roomId
{
    NSMutableArray *deviceArr = [NSMutableArray array];
    
    NSString *keyWord = @"%light%";
    NSString *sql = [NSString stringWithFormat:@"SELECT DeviceId,DeviceName,Type FROM DEVICE WHERE TYPE LIKE '%@' AND HOUSEID='%@' AND LAYERID='%@' AND ROOMID='%@' AND TYPE NOT IN ('light','light_1','light_check') ORDER BY TYPE ASC",keyWord,houseId,layerId,roomId];
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            Device *obj = [[Device alloc] init];
            obj.DeviceId = [rs stringForColumn:@"DeviceId"];
            obj.DeviceName = [rs stringForColumn:@"DeviceName"];
            obj.Type = [rs stringForColumn:@"Type"];
            
            [deviceArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return deviceArr;
}

//添加命令到购物车表，用于构建场景
+(BOOL)addOrderToShoppingCar:(NSString *)orderId andDeviceId:(NSString *)deviceId
{
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO SHOPPINGCAR (ORDERID,DEVICEID,TIMER) VALUES ('%@','%@','%@')",orderId,deviceId,@"20"];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取购物车里的命令
+(NSMutableArray *)getShoppingCarOrder
{
    NSMutableArray *orderArr = [NSMutableArray array];
    
    NSString *sql = @"SELECT S.ORDERID,S.DEVICEID,O.ORDERNAME,D.DEVICENAME,D.TYPE,I.NEWTYPE,S.TIMER FROM SHOPPINGCAR S LEFT JOIN ORDERS O ON S.ORDERID=O.ORDERID LEFT JOIN DEVICE D ON S.DEVICEID=D.DEVICEID LEFT JOIN ICON I ON S.DEVICEID=I.DEVICEID";
    FMDatabase *db = [self getDB];
    
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]){
            
            Sence *obj = [[Sence alloc] init];
            obj.SenceId = [rs stringForColumn:@"DeviceId"];
            obj.OrderId = [rs stringForColumn:@"OrderId"];
            obj.SenceName = [rs stringForColumn:@"DeviceName"];
            obj.OrderName = [rs stringForColumn:@"OrderName"];
            obj.Type = [rs stringForColumn:@"Type"];
            obj.IconType = [rs stringForColumn:@"NewType"];
            obj.Timer = [rs stringForColumn:@"Timer"];
            [orderArr addObject:obj];
        }
        
        [rs close];
    }
    
    [db close];
    
    return orderArr;
}

//更新场景的时间间隔
+(BOOL)updateShoppingCarTimer:(NSString *)orderId andDeviceId:(NSString *)deviceId andTimer:(NSString *)timer
{
    NSString *sql = [NSString stringWithFormat:@"UPDATE SHOPPINGCAR SET TIMER='%@' WHERE DEVICEID='%@' AND ORDERID='%@'",timer,deviceId,orderId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//删除所有添加的场景命令
+(BOOL)removeShoppingCar
{
    NSString *sql = @"DELETE FROM SHOPPINGCAR";
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取购物车数量
+(int)getShoppingCarCount
{
    int totalCount = 0;
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = @"SELECT COUNT(*) FROM SHOPPINGCAR";
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            totalCount = [rs intForColumnIndex:0];
        }
    }
    
    [db close];
    
    return totalCount;
}

//移除购物车的某条命令
+(BOOL)removeShoppingCarByOrderId:(NSString *)orderId
{
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM SHOPPINGCAR WHERE ORDERID='%@'",orderId];
    
    FMDatabase *db = [self getDB];
    
    [db open];
    
    BOOL bResult = [db executeUpdate:sql];
    
    [db close];
    
    return bResult;
}

//获取全局配置信息
+(Control *)getControlObj
{
    FMDatabase *db = [self getDB];
    Control *obj = nil;
    NSString *sql = @"SELECT * FROM Control";
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            obj = [Control setIp:[rs stringForColumn:@"Ip"]
                     andSendType:[rs stringForColumn:@"SendType"]
                         andPort:[rs stringForColumn:@"Port"]
                       andDomain:[rs stringForColumn:@"Domain"]
                          andUrl:[rs stringForColumn:@"Url"]
                    andUpdatever:[rs stringForColumn:@"Updatever"]
                       andJsname:[rs stringForColumn:@"Jsname"]
                        andJstel:[rs stringForColumn:@"Jstel"]
                      andJsuname:[rs stringForColumn:@"Jsuname"]
                     andJsaddess:[rs stringForColumn:@"Jsaddess"]
                       andJslogo:[rs stringForColumn:@"Jslogo"]
                         andJsqq:[rs stringForColumn:@"Jsqq"]
                      andOpenPic:[rs stringForColumn:@"OpenPic"]];
        }
    }
    
    [db close];
    
    return obj;
}

//当前设备是否有学习模式
+(BOOL)isStudyModel:(NSString *)deviceId
{
    BOOL isResult = NO;
    int totalCount = 0;
    
    FMDatabase *db = [self getDB];
    
    NSString *sql = [NSString stringWithFormat:@"select count(studycmd) from Orders where deviceid='%@' and studycmd<>''",deviceId];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        if ([rs next]) {
            totalCount = [rs intForColumnIndex:0];
        }
    }
    
    [db close];
    
    if (totalCount > 0) {
        isResult = YES;
    }
    
    return isResult;
}

@end
