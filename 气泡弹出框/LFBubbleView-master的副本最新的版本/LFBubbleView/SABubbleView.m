//
//  SABubbleView.m
//  LFBubbleViewDemo
//
//  Created by 李磊 on 26/6/17.
//  Copyright © 2017年 李磊. All rights reserved.
//

#import "SABubbleView.h"

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

@interface SABubbleView ()

//优先使用triangleXY。如果triangleXY和triangleXYScale都不设置，则三角在中间
@property (nonatomic, assign) CGFloat triangleXY;//三角中心的x或y（三角朝上下代表x,三角朝左右代表y）
@property (nonatomic, assign) CGFloat triangleXYScale;//三角的中心x或y位置占边长的比例，如0.5代表在中间

@property (nonatomic, assign) CGPoint  point;

@end

@implementation SABubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.transform = CGAffineTransformMakeScale(0.0001, 0.0001);
        //        self.backgroundColor = [UIColor blackColor];
        _contentView = [[UIView alloc] init];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.contentView];
        
        self.lbTitle = [[UILabel alloc] init];
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
        if (self.direction == SATriangleDirection_Down || self.direction == SATriangleDirection_Up) {
            self.triangleXY = self.triangleXYScale * self.frame.size.width;
        } else {
            self.triangleXY = self.triangleXYScale * self.frame.size.height ;
        }
        
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGSize titleSize = [self.lbTitle.text boundingRectWithSize:CGSizeMake(150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
    CGRect rect = self.frame;
    rect.size.width = 180;
    
    if (self.direction == SATriangleDirection_Down || self.direction ==
        SATriangleDirection_Up) {
        self.triangleXY = rect.size.width / 2.0;
        rect.size.height = titleSize.height + 40;
    }else{
        
        rect.size.height = titleSize.height + 30;
        self.triangleXY = rect.size.height / 2.0;
    }
    self.frame = rect;
    
    //contentView与self的边距
    CGFloat padding = 15;
    switch (self.direction) {
        case SATriangleDirection_Down:
        {
            self.frame = CGRectMake(_point.x - self.triangleXY, _point.y - self.frame.size.height, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - 2 * padding , self.frame.size.height - triangleH - 2 * padding);
            
        }
            break;
        case SATriangleDirection_Up:
        {
            self.frame = CGRectMake(_point.x - self.triangleXY, _point.y, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding,triangleH +padding , self.frame.size.width - 2 * padding, self.frame.size.height  - triangleH - 2 * padding);
        }
            break;
        case SATriangleDirection_Left:
        {
            self.frame = CGRectMake(_point.x, _point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(triangleH +padding     , padding, self.frame.size.width - triangleH - 2 * padding, self.frame.size.height - 2 * padding);
        }
            break;
        case SATriangleDirection_Right:
        {
            self.frame = CGRectMake(_point.x - self.frame.size.width, _point.y - self.triangleXY, self.frame.size.width, self.frame.size.height);
            self.contentView.frame = CGRectMake(padding, padding, self.frame.size.width - triangleH - 2 * padding, self.frame.size.height - 2 * padding);
        }
            break;
        default:
            break;
    }
    
    self.lbTitle.frame = CGRectMake(0, 0, self.contentView.frame.size.width , self.contentView.frame.size.height );
    [self setNeedsDisplay];
    [self layoutIfNeeded];
    [self initData];
    
}

- (void)drawRect:(CGRect)rect {
    [self initData];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    switch (self.direction) {
        case SATriangleDirection_Down:
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
        case SATriangleDirection_Up:
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
        case SATriangleDirection_Left:
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
        case SATriangleDirection_Right:
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

- (void)setDismissAfterSecond:(CGFloat)dismissAfterSecond {
    _dismissAfterSecond = dismissAfterSecond;
    if (_dismissAfterSecond > 0) {
        __block SABubbleView *blockTips = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_dismissAfterSecond * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [blockTips removeFromSuperview];
        });
    }
}

- (void)showInPoint:(CGPoint)point {
    
    if (_state == MenuShow) return;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
    }];
    
    _state = MenuShow;
    
    
    //数据配置
    [self initData];
    self.point = point;
    
    
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
