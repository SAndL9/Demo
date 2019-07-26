//
//  ArrowAngleView.m
//  wwjTableView
//
//  Created by 吴伟军 on 16/7/7.
//  Copyright © 2016年 wuwj. All rights reserved.
//

#import "ArrowAngleView.h"
#import <objc/runtime.h>
CGFloat const ArrowSpace      = 20;
NSString const *dataArrayKey  = @"dataArrayKey";

@interface ArrowAngleView ()<UITableViewDataSource,UITableViewDelegate>

@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGFloat width;

@property (assign, nonatomic) CGFloat superX;
@property (assign, nonatomic) CGFloat superY;
@end

@implementation ArrowAngleView

- (NSMutableArray *)dataArray{
    return objc_getAssociatedObject(self, &dataArrayKey);
}

- (void)setDataArray:(NSMutableArray *)dataArray{
    objc_setAssociatedObject(self, &dataArrayKey, dataArray, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setTabelView:(CGRect)frame{
    UITableView *tableView = [[UITableView alloc] initWithFrame:(CGRectMake(0, ArrowSpace, frame.size.width, frame.size.height - ArrowSpace))];
    tableView.backgroundColor = self.backgroundColor;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:tableView];
}


- (void)setTargetRect:(CGRect)targetRect{
    self.x = targetRect.origin.x;
    self.y = targetRect.origin.y;
    self.width = targetRect.size.width;
    [self setNeedsDisplay];
}

- (void)drawArrowRectangle:(CGRect)frame{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    //启始位置坐标x，y
    CGFloat origin_x = frame.origin.x;
    CGFloat origin_y = frame.origin.y + ArrowSpace;
    //第一条线的位置坐标
    CGFloat line_1_x = origin_x;
    CGFloat line_1_y = frame.size.height;
    //第二条线的位置坐标
    CGFloat line_2_x = frame.size.width;
    CGFloat line_2_y = line_1_y;
    //第三条线的位置坐标
    CGFloat line_3_x = line_2_x;
    CGFloat line_3_y = origin_y;
    //第四条线的位置坐标
    CGFloat line_4_x = self.x - self.superX + self.width / 2 + ArrowSpace / 2;
    CGFloat line_4_y = origin_y;
    //尖角的顶点位置坐标
    CGFloat line_5_x = line_4_x - ArrowSpace / 2;
    CGFloat line_5_y = frame.origin.y;
    //第六条线位置坐标
    CGFloat line_6_x = line_5_x - ArrowSpace / 2;
    CGFloat line_6_y = origin_y;
    
    CGContextMoveToPoint(context, origin_x, origin_y);
    
    CGContextAddLineToPoint(context, line_1_x, line_1_y);
    CGContextAddLineToPoint(context, line_2_x, line_2_y);
    CGContextAddLineToPoint(context, line_3_x, line_3_y);
    CGContextAddLineToPoint(context, line_4_x, line_4_y);
    CGContextAddLineToPoint(context, line_5_x, line_5_y);
    CGContextAddLineToPoint(context, line_6_x, line_6_y);
    
    CGContextClosePath(context);
    
    UIColor *costomColor = [UIColor cyanColor];
    CGContextSetFillColorWithColor(context, costomColor.CGColor);
    
    CGContextFillPath(context);
}

- (void)drawRect:(CGRect)rect{
    
    //绘制带箭头的框框
    [self drawArrowRectangle:rect];
    [self setTabelView:rect];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        self.superX = frame.origin.x;
        self.superY = frame.origin.y;
    }
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.backgroundColor = [UIColor cyanColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate didSelectedWithIndexPath:indexPath.row];
    [self removeFromSuperview];
}



@end
