//
//  PieChartView.m
//  环形图
//
//  Created by 舒通 on 2017/4/7.
//  Copyright © 2017年 shutong. All rights reserved.
//

#import "PieChartView.h"


@interface PieChartView ()

@end
@implementation PieChartView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configDefaultMessage];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self configDefaultMessage];
        
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self configDefaultMessage];
}

/**
 配置默认信息
 */
- (void)configDefaultMessage
{
    self.redius = 56;
    self.pieCenter = CGPointMake((self.frame.size.width /2- self.redius), (self.frame.size.height /2));
    self.progress = 0.2;
    self.pieBackGroundColor = [UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0];
    self.pieColor = [UIColor redColor];
    self.strokeLineWith = 20;

}

- (void)upLoadPieChartWithProgress:(CGFloat)progress
{
    self.progress = progress;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    
    //获取当前上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self drawPieChartBackGroundWithRedius:self.redius withCenter:self.pieCenter withWidth:self.strokeLineWith withColor:self.pieBackGroundColor andContextRef:context];
    
    [self drawPieChartWithRedius:self.redius withCenter:self.pieCenter withWidth:self.strokeLineWith withColor:self.pieColor andContextRef:context];
    // 百分比
    [self drawTextWithString:[NSString stringWithFormat:@"%0.1f%%",self.progress*100] withCenterPoint:self.pieCenter withFont:16 withColor:[UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0]  andContext:context];
//    环形图名称
    CGPoint namePoint = CGPointMake(self.pieCenter.x, self.pieCenter.y+self.redius+self.strokeLineWith+15);
    [self drawTextWithString:@"商品下单率" withCenterPoint:namePoint withFont:12 withColor:[UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0]  andContext:context];
    
//    环形颜色
    
    NSArray *color = @[self.pieBackGroundColor,self.pieColor];
    CGSize size = CGSizeMake(20, 20);
    for (int i = 0; i < self.markName.count; i++) {
        CGFloat x = self.frame.size.width/2+50;
        CGFloat y = self.frame.size.height/2 - size.height - 12 + i*(12+size.height);
        [self drawQuartWithColor:color[i] withBegin:CGPointMake(x, y) withSize:size andContext:context];
        [self drawTextWithString:self.markName[i] withBeginPoint:CGPointMake(x+30, y) withFont:12 withColor:[UIColor colorWithRed:56/255.0 green:56/255.0 blue:56/255.0 alpha:1.0] andContext:context];
    }
}

/**
 绘制环形背景图

 @param redius 半径
 @param point 中心点
 @param color 背景颜色
 @param context 上下文
 */
- (void)drawPieChartBackGroundWithRedius:(CGFloat)redius withCenter:(CGPoint)point withWidth:(CGFloat)width withColor:(UIColor *)color andContextRef:(CGContextRef)context
{
    CGFloat startAngle = 0;
    CGFloat  endAngle = M_PI * 2;
    
    CGContextSetLineWidth(context, width);//线宽
    [color setStroke]; // 颜色
    
    //路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:point radius:redius startAngle:startAngle endAngle:endAngle clockwise:NO];
    CGContextAddPath(context, path.CGPath);
    
    CGContextDrawPath(context, kCGPathStroke);
}

- (void)drawPieChartWithRedius:(CGFloat)redius withCenter:(CGPoint)point withWidth:(CGFloat)width withColor:(UIColor *)color andContextRef:(CGContextRef)context
{
    // 圆环轨迹
    CGFloat startAngle = -M_PI_2;
    CGFloat endAngle = startAngle + 2 * M_PI * self.progress;
    CGContextSetLineWidth(context, width);
    [color setStroke];
    CGContextAddArc(context, point.x, point.y, redius, startAngle, endAngle, NO);
    CGContextDrawPath(context, kCGPathStroke);
}

/**
 画文字

 @param string 文字内容
 @param point 中心点
 @param font 字号
 @param color 颜色
 @param context 上下文
 */
- (void)drawTextWithString:(NSString *)string withCenterPoint:(CGPoint)point withFont:(CGFloat)font withColor:(UIColor *)color andContext:(CGContextRef)context
{
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByCharWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:textStyle};
    CGSize textSize = [string sizeWithAttributes:attributes];
    CGRect textRect = CGRectMake(point.x-textSize.width/2, point.y - textSize.height/2, textSize.width, textSize.height);
    [string drawInRect:textRect withAttributes:attributes];
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
}
- (void)drawTextWithString:(NSString *)string withBeginPoint:(CGPoint)point withFont:(CGFloat)font withColor:(UIColor *)color andContext:(CGContextRef)context
{
    NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    textStyle.lineBreakMode = NSLineBreakByCharWrapping;
    textStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:textStyle};
//    CGSize textSize = [string sizeWithAttributes:attributes];
//    CGRect textRect = CGRectMake(point.x-textSize.width/2, point.y - textSize.height/2, textSize.width, textSize.height);
    [string drawAtPoint:point withAttributes:attributes];
//    [string drawInRect:textRect withAttributes:attributes];
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
}

/**
 画长方型

 @param color 颜色
 @param point 开始位子
 @param size 大小
 @param context 上下文
 */
- (void)drawQuartWithColor:(UIColor *)color withBegin:(CGPoint)point withSize:(CGSize)size andContext:(CGContextRef)context
{
    CGContextAddRect(context, CGRectMake(point.x, point.y, size.width, size.height));
    [color setFill];
    CGContextDrawPath(context, kCGPathFill);
}

@end
