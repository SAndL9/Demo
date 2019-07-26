//
//  GLHGuideView.m
//  GLHGuideView
//
//  Created by ligui on 2017/5/26.
//  Copyright © 2017年 ligui. All rights reserved.
//

#import "GLHGuideView.h"

typedef enum{
    Left  = 1,
    Right = 1 << 1,
    Upper = 1 << 2,
    Down  = 1 << 3
}GLHGuideLocation;
@interface GLHGuideView()
@property (nonatomic, copy) NSArray<NSDictionary<NSString *,NSValue *> *> *guidesArr;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) GLHGuideLocation location;
@property (nonatomic, strong) UILabel *labMessage;

@property (nonatomic, strong) NSArray *arrowTypeArr;
@property (nonatomic, strong) UIImageView *arrowImageView;


@end
@implementation GLHGuideView
- (GLHGuideView *)initWithFrame:(CGRect)frame
                        guides:(NSArray<NSDictionary<NSString *,NSValue *> *> *)guides  arrowType:(NSArray *)arrowTypeArr{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"guides-------%@",guides);
        self.backgroundColor = [UIColor colorWithRed:32/255.0f green:32/255.0f blue:32/255.0f alpha:0.8];
        _guidesArr = guides;
      
        _arrowTypeArr = arrowTypeArr;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(sureTapClick:)];
        [self addGestureRecognizer:tap];
        // 引导描述
        self.labMessage = [[UILabel alloc] init];
        self.labMessage.textColor = [UIColor whiteColor];
        self.labMessage.font = [UIFont systemFontOfSize:16];
        self.labMessage.textAlignment = NSTextAlignmentCenter;
        self.labMessage.numberOfLines = 0;
        [self addSubview:self.labMessage];
        
        _arrowImageView = [[UIImageView alloc] init];
        [self addSubview:_arrowImageView];
    }
    return self;
}
- (void)showGuide {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.currentIndex = 0;
    [self guideWithIndex:self.currentIndex];
}

- (void)guideWithIndex:(NSInteger)index {
    if (self.guidesArr.count == 0) {
        return;
    }
    NSDictionary *dic = self.guidesArr[index];
    NSString *descStr = [[dic allKeys] firstObject];
    CGRect rect = [dic[descStr] CGRectValue];
    
    [self configImageAndLabelLocation:descStr nearRect:rect arrowType:_arrowTypeArr[index]];
    
    UIBezierPath *shapePath;
    CGFloat lineWidth = 0.0;
    
 
        // 方形
        shapePath = [UIBezierPath bezierPathWithRect:rect];
   
    
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *bezier = [UIBezierPath bezierPathWithRect:self.bounds];
    [bezier appendPath:[shapePath bezierPathByReversingPath]];
    layer.path = bezier.CGPath;
    layer.lineWidth = lineWidth;
    layer.lineDashPattern = @[@5,@5];
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.fillColor = [UIColor redColor].CGColor;
    self.layer.mask = layer;
}
- (void)configImageAndLabelLocation:(NSString *)labelText nearRect:(CGRect)rect arrowType:(NSString *)arrowType
{
    NSString *arrowNameStr = @"";
    CGRect arrowFrame = _arrowImageView.frame;
    arrowFrame.size = CGSizeMake(100, 80);
    
    CGRect labelFrame = _labMessage.frame;
    
    CGFloat labelHeight = [labelText boundingRectWithSize:CGSizeMake(100, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16]} context:nil].size.height+5;
    switch ([arrowType integerValue]) {
        case 1:
            arrowNameStr = @"leftUp";
            arrowFrame.origin.x = rect.origin.x;
            arrowFrame.origin.y = rect.origin.y+rect.size.height;
            labelFrame = CGRectMake(rect.origin.x, arrowFrame.origin.y+arrowFrame.size.height, 100, labelHeight);
            break;
        case 2:
            arrowNameStr = @"rightUp";
            arrowFrame.origin.x = rect.origin.x+rect.size.width-arrowFrame.size.width;
            arrowFrame.origin.y = rect.origin.y+rect.size.height;
            labelFrame = CGRectMake(rect.origin.x, arrowFrame.origin.y+arrowFrame.size.height, 100, labelHeight);
            break;
        case 3:
            arrowNameStr = @"leftDown";
            arrowFrame.origin.x = rect.origin.x;
            arrowFrame.origin.y = rect.origin.y-arrowFrame.size.height;
            labelFrame = CGRectMake(rect.origin.x, arrowFrame.origin.y-arrowFrame.size.height, 100,labelHeight);
            break;
        case 4:
            arrowNameStr = @"rightDown";
            arrowFrame.origin.x = rect.origin.x+rect.size.width-arrowFrame.size.width;
            arrowFrame.origin.y = rect.origin.y-arrowFrame.size.height;
            labelFrame = CGRectMake(rect.origin.x, arrowFrame.origin.y-arrowFrame.size.height, 100, labelHeight);
            break;
        case 99:
            labelFrame = self.frame;
            arrowFrame = CGRectZero;
            break;
        case 98:
            arrowFrame = self.frame;

            break;
        default:
            break;
    }
    _arrowImageView.image = [UIImage imageNamed:arrowNameStr];
    _labMessage.text = labelText;
    _arrowImageView.frame = arrowFrame;
    _labMessage.frame = labelFrame;
}


/**
 *   新手指引确定
 */
- (void)sureTapClick:(UITapGestureRecognizer *)tap
{
    self.currentIndex ++;
    if (self.currentIndex < self.guidesArr.count) {
        [self guideWithIndex:self.currentIndex];
        return;
    }
    
    [self removeFromSuperview];
}


@end
