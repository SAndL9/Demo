//
//  MaskView.m
//  不规则截图
//
//  Created by macbook on 16/8/2.
//  Copyright © 2016年 macbook. All rights reserved.
//

#import "MaskView.h"


@implementation TPoint
- (instancetype)initWithX:(CGFloat)x andY:(CGFloat)y{
    if (self = [super init]) {
        self.x = x;
        self.y = y;
    }
    return self;
}
- (void)setPoint:(CGPoint)point {
    self.x = point.x;
    self.y = point.y;
}
- (CGPoint)getPoint {
    return CGPointMake(self.x, self.y);
}
- (CGRect)getRect {
    return CGRectMake(MAX(self.x-40, 0), MAX(self.y-40, 0), self.x+40, self.y+40);
}

@end

@interface MaskView ()
/** currentColor */
@property (strong, nonatomic) UIColor *currentColor;
/** arrayOfPoints */
@property (strong, nonatomic) NSArray *arrayOfPoints;
@end

@implementation MaskView{
    CGContextRef _ctx;
    BOOL _isMove;
    CGPoint _offset;
    TPoint * _movePoint;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.currentColor = [UIColor greenColor];
        UIGraphicsBeginImageContext(self.bounds.size);
        _isMove = NO;
    }
    return self;
}

- (NSArray *)arrayOfPoints{
    if (!_arrayOfPoints) {
        CGFloat kWidth = CGRectGetWidth(self.bounds)*0.25;
        CGFloat kHeight = CGRectGetHeight(self.bounds)*0.25;
        TPoint *point1 = [[TPoint alloc]initWithX:kWidth andY:kHeight];
        TPoint *point2 = [[TPoint alloc]initWithX:kWidth*3 andY:kHeight];
        TPoint *point3 = [[TPoint alloc]initWithX:kWidth*3 andY:kHeight*3];
        TPoint *point4 = [[TPoint alloc]initWithX:kWidth andY:kHeight*3];
        _arrayOfPoints = [NSArray arrayWithObjects:point1, point2, point3, point4, nil];
    }
    return _arrayOfPoints;
}

- (NSArray *)getPoints {
    return [self.arrayOfPoints copy];
}

- (CGFloat)distanceFromPoint:(CGPoint)sou ToPoint:(CGPoint)des{
    return sqrt(pow(des.x-sou.x,2)+pow(des.y-sou.y,2));
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    _movePoint = nil;
    __block CGFloat distance = 100.0;
    [self.arrayOfPoints enumerateObjectsUsingBlock:^(TPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if(CGRectContainsPoint([obj getRect], [touch locationInView:self])) {
            _isMove = YES;
            if ([self distanceFromPoint:[obj getPoint] ToPoint:[touch locationInView:self]]<distance) {
                distance = [self distanceFromPoint:[obj getPoint] ToPoint:[touch locationInView:self]];
                _offset = CGPointMake([obj getPoint].x-[touch locationInView:self].x, [obj getPoint].y-[touch locationInView:self].y);
                _movePoint = obj;
            }
        }
    }];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveWithTouch:touches withEvent:event];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveWithTouch:touches withEvent:event];
    _isMove = NO;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self moveWithTouch:touches withEvent:event];
    _isMove = NO;
}

- (void)moveWithTouch:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_isMove) {
        UITouch *touch = [touches anyObject];
        CGFloat x = MIN(MAX([touch locationInView:self].x+_offset.x, 0), CGRectGetWidth(self.bounds));
        CGFloat y = MIN(MAX([touch locationInView:self].y+_offset.y, 0), CGRectGetHeight(self.bounds));
        [_movePoint setPoint:CGPointMake(x, y)];
        
        /**
         添加判断四边形任意两边是否都不交叉（非端点），如果交叉则对点的数组重新排列
         */
        
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    _ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(_ctx);
    CGContextSetLineWidth(_ctx, 1);
    CGContextSetLineJoin(_ctx, kCGLineJoinRound);
    CGContextSetStrokeColorWithColor(_ctx, [[UIColor blackColor] CGColor]);
    [self.arrayOfPoints enumerateObjectsUsingBlock:^(TPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [[self.arrayOfPoints objectAtIndex:idx] getPoint];
        if (idx == 0) {
            CGContextMoveToPoint(_ctx, point.x, point.y);
        }
        else {
            CGContextAddLineToPoint(_ctx, point.x, point.y);
        }
    }];
    CGContextClosePath(_ctx);
    CGContextStrokePath(_ctx);
    
    
    CGContextSetLineWidth(_ctx, 1);
    for (TPoint * point in self.arrayOfPoints) {
        CGContextStrokeEllipseInRect(_ctx, CGRectMake(point.x-10, point.y-10, 20, 20));
    }
    
    CGContextBeginPath(_ctx);
    [self.arrayOfPoints enumerateObjectsUsingBlock:^(TPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [[self.arrayOfPoints objectAtIndex:idx] getPoint];
        if (idx == 0) {
            CGContextMoveToPoint(_ctx, point.x, point.y);
        }
        else {
            CGContextAddLineToPoint(_ctx, point.x, point.y);
        }
    }];
    CGContextAddRect(_ctx, self.bounds);
    CGContextClosePath(_ctx);
    CGContextEOClip(_ctx);
    CGContextSetFillColorWithColor(_ctx, [[[UIColor blackColor]colorWithAlphaComponent:0.3] CGColor]);
    CGContextFillRect(_ctx, self.bounds);
}

- (UIImage *)getSnipImageWithImage:(UIImage *)image{
    UIGraphicsBeginImageContext(self.bounds.size);
        
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextBeginPath(ctx);
        
    [self.arrayOfPoints enumerateObjectsUsingBlock:^(TPoint * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGPoint point = [[self.arrayOfPoints objectAtIndex:idx] getPoint];
        if (idx == 0) {
            CGContextMoveToPoint(ctx, point.x, point.y);
        }
        else {
            CGContextAddLineToPoint(ctx, point.x, point.y);
        }
    }];
        
    CGContextClosePath(ctx);
    CGContextClip(ctx);
    [image drawInRect:self.bounds];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        
    return newImage;
}


//判断两条线段是否相交

//double determinant(double v1, double v2, double v3, double v4)  // 行列式
//{
//    return (v1*v4-v2*v3);
//}
//
//bool intersect3(CGPoint aa, CGPoint bb, CGPoint cc, CGPoint dd)
//{
//    double delta = determinant(bb.x-aa.x, cc.x-dd.x, bb.y-aa.y, cc.y-dd.y);
//    if ( delta<=(1e-6) && delta>=-(1e-6) )  // delta=0，表示两线段重合或平行
//    {
//        return false;
//    }
//    double namenda = determinant(cc.x-aa.x, cc.x-dd.x, cc.y-aa.y, cc.y-dd.y) / delta;
//    if ( namenda>1 || namenda<0 )
//    {
//        return false;
//    }
//    double miu = determinant(bb.x-aa.x, cc.x-aa.x, bb.y-aa.y, cc.y-aa.y) / delta;
//    if ( miu>1 || miu<0 )
//    {
//        return false;
//    }
//    return true;
//}


@end
