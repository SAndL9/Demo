//
//  LFBubbleView.m
//  LFBubbleViewDemo
//
//  Created by 张林峰 on 16/6/29.
//  Copyright © 2016年 张林峰. All rights reserved.
//

#import "LFBubbleView.h"
//圆角
#define cornerRadius 10
//默认背景色
#define color [UIColor colorWithRed:9/255.0 green:113/255.0 blue:206/255.0 alpha:1]

//默认三角形高
#define triangleH      10
//默认三角形底边长
#define triangleW      15
//默认字体颜色
#define kELBubbleViewTextColor  [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
//默认字体大小
#define kELBubbleViewFont 17

@interface LFBubbleView ()

@end

@implementation LFBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        self.backgroundColor = [UIColor blackColor];
        _contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.contentView];
        
        self.lbTitle = [[UILabel alloc] init];
        self.lbTitle.font = [UIFont systemFontOfSize:kELBubbleViewFont];
        self.lbTitle.textColor = kELBubbleViewTextColor;
//        self.lbTitle.backgroundColor = [UIColor redColor];
        self.lbTitle.textAlignment = NSTextAlignmentCenter;
        self.lbTitle.numberOfLines = 0;
        [_contentView addSubview:self.lbTitle];
    }
    return self;
}

//数据配置
- (void)initData {

    if (self.triangleXY < 1) {
        if (self.triangleXYScale == 0) {
            self.triangleXYScale = 0.5;
        }
        if (self.direction == LFTriangleDirection_Down || self.direction == LFTriangleDirection_Up) {
            self.triangleXY = self.triangleXYScale * self.frame.size.width;
        } else {
            self.triangleXY = self.triangleXYScale * self.frame.size.height;
        }
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize titleSize = [self.lbTitle.text boundingRectWithSize:CGSizeMake(180, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    NSLog(@"frameSize---%f",titleSize.height);
    CGRect rect = self.frame;
    rect.size.width = 180;
    if (titleSize.height <50) {
        rect.size.height = 52;
    }else{
        rect.size.height = titleSize.height;
    }
    self.frame = rect;
    
   
     self.lbTitle.frame = CGRectMake(0, 0, self.contentView.frame.size.width , self.contentView.frame.size.height );
    [self setNeedsDisplay];
    [self layoutIfNeeded];
   
}

- (void)drawRect:(CGRect)rect {

    [self initData];
    
    CGMutablePathRef path = CGPathCreateMutable();

    CGContextRef context = UIGraphicsGetCurrentContext();

    switch (self.direction) {
        case LFTriangleDirection_Down:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y +cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - triangleH - cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + rect.size.height - triangleH - cornerRadius, cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - triangleW/2,rect.origin.y + rect.size.height - triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                                 rect.origin.y + rect.size.height);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + triangleW/2,
                                 rect.origin.y + rect.size.height - triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - cornerRadius,rect.origin.y + rect.size.height - triangleH);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - cornerRadius,rect.origin.y + rect.size.height - triangleH - cornerRadius, cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - cornerRadius, rect.origin.y + cornerRadius,cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + cornerRadius, rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + cornerRadius, cornerRadius,-M_PI / 2, M_PI, 1);
        }
            break;
        case LFTriangleDirection_Up:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + cornerRadius + triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + rect.size.height - cornerRadius,
                         cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - cornerRadius,rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - cornerRadius,rect.origin.y + rect.size.height - cornerRadius, cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + triangleH + cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - cornerRadius, rect.origin.y + triangleH + cornerRadius,cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY + triangleW/2,
                                 rect.origin.y + triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY,
                                 rect.origin.y);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + self.triangleXY - triangleW/2,
                                 rect.origin.y + triangleH);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + triangleH);
            CGPathAddArc(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + triangleH + cornerRadius, cornerRadius,
                         -M_PI / 2, M_PI, 1);
        }
            break;
        case LFTriangleDirection_Left:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x + triangleH, rect.origin.y + cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x +triangleH, rect.origin.y + self.triangleXY - triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x,rect.origin.y + self.triangleXY);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + triangleH,rect.origin.y + self.triangleXY + triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + triangleH,rect.origin.y + rect.size.height - cornerRadius);
            
            CGPathAddArc(path, NULL, rect.origin.x + triangleH + cornerRadius, rect.origin.y + rect.size.height - cornerRadius,cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - cornerRadius,rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - cornerRadius,rect.origin.y + rect.size.height - cornerRadius, cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width,rect.origin.y + cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - cornerRadius, rect.origin.y + cornerRadius,cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + triangleH + cornerRadius, rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + triangleH + cornerRadius, rect.origin.y + cornerRadius, cornerRadius,-M_PI / 2, M_PI, 1);
            
        }
            break;
        case LFTriangleDirection_Right:
        {
            CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + cornerRadius);
            CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + rect.size.height - cornerRadius,cornerRadius, M_PI, M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - triangleH - cornerRadius,rect.origin.y + rect.size.height);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - triangleH - cornerRadius,rect.origin.y + rect.size.height - cornerRadius, cornerRadius, M_PI / 2, 0.0f, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - triangleH,rect.origin.y + self.triangleXY + triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width,rect.origin.y + self.triangleXY);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - triangleH,rect.origin.y + self.triangleXY - triangleW/2);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - triangleH,rect.origin.y + cornerRadius);
            CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - triangleH - cornerRadius, rect.origin.y + cornerRadius,cornerRadius, 0.0f, -M_PI / 2, 1);
            CGPathAddLineToPoint(path, NULL, rect.origin.x + cornerRadius,rect.origin.y);
            CGPathAddArc(path, NULL, rect.origin.x + cornerRadius, rect.origin.y + cornerRadius, cornerRadius,-M_PI / 2, M_PI, 1);
        }
            break;
        default:
            break;
    }
    
    
    CGPathCloseSubpath(path);
    
    //填充气泡
    [color setFill];
    CGContextAddPath(context, path);
    CGContextSaveGState(context);
    CGContextFillPath(context);
    CGContextRestoreGState(context);
    
}

#pragma mark - 公有方法

-(void)setDismissAfterSecond:(CGFloat)dismissAfterSecond {
    _dismissAfterSecond = dismissAfterSecond;
    if (_dismissAfterSecond > 0) {
        __block LFBubbleView *blockTips = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_dismissAfterSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [blockTips removeFromSuperview];
        });
    }
}

- (void)showInPoint:(CGPoint)point {
    NSLog(@"point----%f---%f",point.x,point.y);
    if (_state == MenuShow) return;
    
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    
    _state = MenuShow;
    
    
    //数据配置
    [self initData];
    //contentView与self的边距
    CGFloat padding = 15;
    switch (self.direction) {
        case LFTriangleDirection_Down:
        {
            self.frame = CGRectMake(point.x - self.triangleXY, point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding , self.frame.size.height - triangleH - 2 * padding);
            
        }
            break;
        case LFTriangleDirection_Up:
        {
            self.frame = CGRectMake(point.x - self.triangleXY, point.y, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding,triangleH +padding , self.frame.size.width - 2 * padding, self.frame.size.height  - triangleH - 2 * padding);
        }
            break;
        case LFTriangleDirection_Left:
        {
            self.frame = CGRectMake(point.x, point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(triangleH +padding     , padding, self.frame.size.width - triangleH - 2 * padding, self.frame.size.height - 2 * padding);
        }
            break;
        case LFTriangleDirection_Right:
        {
            self.frame = CGRectMake(point.x - self.frame.size.width, point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - triangleH - 2 * padding, self.frame.size.height - 2 * padding);
        }
            break;
        default:
            break;
    }
    
    
 
    
}

// 隐藏menu
- (void)hideMenu
{
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
    }];
    
    _state = MenuDismiss;
}

@end
