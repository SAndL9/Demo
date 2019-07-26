//
//  MyAlertView.h
//  QLink
//
//  Created by SANSAN on 14-9-23.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAlertView : UIAlertView

//长按参数(用于场景，和非照明设备)
@property(nonatomic,strong) NSString *pType;//区分场景和设备类型
@property(nonatomic,assign) int pIndex;//取场景或设备用到的索引

//长按照明参数
@property(nonatomic,strong) NSString *pDeviceName;
@property(nonatomic,strong) UILabel *plTitle;

//删除参数
@property(nonatomic,strong) NSString *pDeviceId;

@end
