//
//  iConView.h
//  QLink
//
//  Created by SANSAN on 14-9-18.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol iConViewDelegate <NSObject>

-(void)handleLongPressed:(int)index andType:(NSString *)pType;
-(void)handleSingleTapPressed:(int)index andType:(NSString *)pType;

@end

@interface iConView : UIView

@property(nonatomic,assign) id<iConViewDelegate>delegate;

@property(nonatomic,assign) int index;//索引数
@property(nonatomic,strong) NSString *pType;
@property(nonatomic,strong) NSString *imgName;
@property(nonatomic,strong) NSString *imgNameSel;

-(void)setIcon:(NSString *)icon andTitle:(NSString *)title;

@end
