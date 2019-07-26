//
//  iConView.m
//  QLink
//
//  Created by SANSAN on 14-9-18.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import "iConView.h"

@implementation iConView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setIcon:(NSString *)icon andTitle:(NSString *)title
{
    self.imgName = [icon stringByAppendingString:@".png"];
    self.imgNameSel = [icon stringByAppendingString:@"_select.png"];
    
    UIImageView *ivIcon = [[UIImageView alloc] init];
    ivIcon.frame = CGRectMake(22, 8, 62, 62);
    ivIcon.tag = 101;
    ivIcon.image = [UIImage imageNamed:_imgName];
    [self addSubview:ivIcon];
    
    UILabel *lTitle = [[UILabel alloc] init];
    lTitle.frame = CGRectMake(0, 78, 106, 20);
    lTitle.text = title;
    lTitle.textColor = [UIColor whiteColor];
    lTitle.backgroundColor = [UIColor clearColor];
    lTitle.textAlignment = NSTextAlignmentCenter;
    lTitle.font = [UIFont systemFontOfSize:FONTSIZE];
    [self addSubview:lTitle];
    
    if (![icon isEqualToString:SANSANADDMACRO] && ![icon isEqualToString:@"light"] && ![icon isEqualToString:SANSANADDDEVICE]) {
        //实例化长按手势监听
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressed:)];
        longPress.minimumPressDuration = 1.0;//表示最短长按的时间
        //将长按手势添加到需要实现长按操作的视图里
        [self addGestureRecognizer:longPress];
    } else {
        //实例化长按手势监听
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLightLongPressed:)];
        longPress.minimumPressDuration = 1.0;//表示最短长按的时间
        //将长按手势添加到需要实现长按操作的视图里
        [self addGestureRecognizer:longPress];
    }
    
    // 单击的 Recognizer
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapPressed)];
    //点击的次数
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    
    //给self添加一个手势监测；
    [self addGestureRecognizer:singleRecognizer];
}

//长按事件的实现方法
- (void)handleLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (self.delegate && [gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        [self.delegate handleLongPressed:_index andType:_pType];
        NSLog(@"第%d索引",_index);
    }
}

//照明类设备长按事件的实现方法
- (void)handleLightLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (self.delegate && [gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示"
                                                        message:@"照明类设备请到设备详情进行操作"
                                                       delegate:nil
                                              cancelButtonTitle:@"关闭"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//单击事件
-(void)handleSingleTapPressed
{
    if (self.delegate) {
        [self.delegate handleSingleTapPressed:_index andType:_pType];
        NSLog(@"第%d索引",_index);
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIImageView *ivIcon = (UIImageView *)[self viewWithTag:101];
    ivIcon.image = [UIImage imageNamed:_imgNameSel];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    UIImageView *ivIcon = (UIImageView *)[self viewWithTag:101];
    ivIcon.image = [UIImage imageNamed:_imgName];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
