//
//  ActionNullClass.h
//  QLink
//
//  Created by 尤日华 on 14-10-4.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ActionNullClassDelegate <NSObject>

-(void)failOper;
-(void)successOper;

@end

@interface ActionNullClass : NSObject
{
    NSMutableData *responseData_;
}

@property(nonatomic,assign) id<ActionNullClassDelegate>delegate;
@property(nonatomic,assign) int iRetryCount;//连接次数

-(id)init;
-(void)initRequestActionNULL;

@end
