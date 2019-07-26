//
//  DataUtil.h
//  QLink
//
//  Created by SANSAN on 14-9-20.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Model.h"

@interface DataUtil : NSObject

//获取沙盒地址
+(NSString *)getDirectoriesInDomains;

//检测是否为空
+(BOOL)checkNullOrEmpty:(NSString *)str;
//验证手机号
+(BOOL) isValidateMobile:(NSString *)mobile;

//判断节点类型并且转换为数组
+(NSArray *)changeDicToArray:(NSObject *)obj;

//判断是否为nil,nil则返回空
+(NSString *)getDefaultValue:(NSString *)value;

//全局变量
+(GlobalAttr *)shareInstanceToRoom;

//更新房间号
+(void)setGlobalAttrRoom:(NSString *)roomId;

//设置全局模式
+(void)setGlobalModel:(NSString *)global;

//获取全局模式类型
+(NSString *)getGlobalModel;

//设置是否添加场景
+(void)setGlobalIsAddSence:(BOOL)isAdd;

//获取是否添加场景模式
+(BOOL)getGlobalIsAddSence;

+(NSStringEncoding)getGB2312Code;

//设置编辑的场景id
+(void)setUpdateInsertSenceInfo:(NSString *)senceId
                   andSenceName:(NSString *)senceName;

+ (NSString *)hexStringFromString:(NSString *)string;

+ (NSString *)localWiFiIPAddress;

//设置udp端口
+(void)setUdpPort:(NSString *)port;

//获取udp端口
+(NSString *)getUdpPort;

+(BOOL) isWifiNewWork;

@end

/************************************************************************************/

@interface Member : NSObject

@property(nonatomic,strong) NSString *uName;
@property(nonatomic,strong) NSString *uPwd;
@property(nonatomic,strong) NSString *uKey;
@property(nonatomic,assign) BOOL isRemeber;

//获取Ud对象用户信息
+(Member *)getMember;

//设置对象信息
+(void)setUdMember:(NSString *)uName
           andUPwd:(NSString *)uPwd
           andUKey:(NSString *)uKey
      andIsRemeber:(BOOL)isRemeber;

@end

/************************************************************************************/

@interface Config : NSObject

@property(nonatomic,strong) NSString *configVersion;//配置文件版本
@property(nonatomic,assign) BOOL isSetSign;//是否配置过标记,未配置则强制进入配置页面
@property(nonatomic,assign) BOOL isWriteCenterControl;//是否写入中控
@property(nonatomic,assign) BOOL isSetIp;//是否配置中控IP
@property(nonatomic,assign) BOOL isBuyCenterControl;//是否购买中控

//获取配置信息
+(Config *)getConfig;

//设置配置信息
+(void)setConfigArr:(NSArray *)configArr;

//设置配置信息
+(void)setConfigObj:(Config *)obj;

//临时变量,用于对比本地配置属性
+(Config *)getTempConfig:(NSArray *)configArr;

@end

/************************************************************************************/

@interface SQLiteUtil : NSObject

//中控信息sql
+(NSString *)connectControlSql:(Control *)obj;
//设备表sql拼接
+(NSString *)connectDeviceSql:(Device *)obj;

//命令表sql拼接
+(NSString *)connectOrderSql:(Order *)obj;

//房间表sql拼接
+(NSString *)connectRoomSql:(Room *)obj;

//场景表sql拼接
+(NSString *)connectSenceSql:(Sence *)obj;

//获取当前版本号
+(NSString *)getCurVersionNo;

//获取设置当前默认楼层和房间号码
+(void)setDefaultLayerIdAndRoomId;

//清除数据
+(void)clearData;

//执行sql语句事物
+(BOOL)handleConfigToDataBase:(NSArray *)sqlArr;

//获取场景列表
+(NSArray *)getSenceList:(NSString *)houseId
              andLayerId:(NSString *)layerId
               andRoomId:(NSString *)roomId;

//获取具体场景命令集合
+(NSMutableArray *)getOrderBySenceId:(NSString *)senceId;

//更新场景下命令和时间
+(BOOL)updateCmdListBySenceId:(NSString *)senceId andSenceName:(NSString *)senceName andCmdList:(NSString *)cmdLists;

//添加场景
+(BOOL)insertSence:(Sence *)obj;

//获取设备列表
+(NSArray *)getDeviceList:(NSString *)houseId
               andLayerId:(NSString *)layerId
                andRoomId:(NSString *)roomId;

//更新图标
+(BOOL)changeIcon:(NSString *)deviceId
          andType:(NSString *)type
       andNewType:(NSString *)newType;

//获取房间列表
+(NSArray *)getRoomList:(NSString *)houseId
             andLayerId:(NSString *)layerId;

//重命名场景
+(BOOL)renameSenceName:(NSString *)senceId
            andNewName:(NSString *)newName;

//重命名设备
+(BOOL)renameDeviceName:(NSString *)deviceId
             andNewName:(NSString *)newName;

//删除场景
+(BOOL)removeSence:(NSString *)senceId;

//删除设备
+(BOOL)removeDevice:(NSString *)deviceId;

//获取该设备下所有命令类型
+(NSArray *)getOrderTypeGroupOrder:(NSString *)deviceId;

//获取指定设备下指定类型的命令集合,用于非照明设备命令查询
+(NSArray *)getOrderListByDeviceId:(NSString *)deviceId andType:(NSString *)type;

//获取指定设备下指定类型的命令集合,用于照明设备命令查询
+(NSArray *)getOrderListByDeviceId:(NSString *)deviceId;

//获取当前房间下所有的照明设备
+(NSArray *)getLightDevice:(NSString *)houseId
                andLayerId:(NSString *)layerId
                 andRoomId:(NSString *)roomId;

//获取当前房间下所有的照明设备(除了type＝‘light’)，考虑到先加载type＝‘light’的照明控件，所以分开取数据
+(NSArray *)getLightComplexDevice:(NSString *)houseId
                       andLayerId:(NSString *)layerId
                        andRoomId:(NSString *)roomId;

//添加命令到购物车表，用于构建场景
+(BOOL)addOrderToShoppingCar:(NSString *)orderId andDeviceId:(NSString *)deviceId;

//获取购物车里的命令
+(NSMutableArray *)getShoppingCarOrder;

//更新场景的时间间隔
+(BOOL)updateShoppingCarTimer:(NSString *)orderId andDeviceId:(NSString *)deviceId andTimer:(NSString *)timer;

//删除所有添加的场景命令
+(BOOL)removeShoppingCar;

//获取购物车数量
+(int)getShoppingCarCount;

//移除购物车的某条命令
+(BOOL)removeShoppingCarByOrderId:(NSString *)orderId;

//获取全局配置信息
+(Control *)getControlObj;

//当前设备是否有学习模式
+(BOOL)isStudyModel:(NSString *)deviceId;

@end




