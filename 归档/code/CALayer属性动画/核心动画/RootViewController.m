//
//  RootViewController.m
//  核心动画
//
//  Created by 徐赢 on 13-7-4.
//  Copyright (c) 2013年 徐赢. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //如果对layer的相关属性做动画
    //1，创建一个动画对象，并指定，这个对象对layer的哪个属性做动画
    //2，设置动画参数：动画时间，动画曲线等。。
    //3，把动画，添加到layer
    
    
    //CAAnimation:动画的基类，提供一些基本的方法和属性
    //创建动画对象的一个便利构造（+号方法）animation
    //timingFunction,动画曲线，淡入淡出等
    //delegate:提供动画完成的时间点
    //遵守CAMediaTiming协议（和动画时间相关的）（可以看成，CAAnimation有如下属性）
    //duration：动画时长
    //repeatCount：重复次数 （-1一直做动画）
    //autoreverses:自动反转动画
    
    //CAPropertyAnimation,CAAnimation的子类，
    //+ (id)animationWithKeyPath:(NSString *)path;
    
    //CABasicAnimation是CAPropertyAnimation子类，
    //fromValue,toValue,byValue
    
    
    //CAKeyframeAnimation是CAPropertyAnimation子类，关键帧动画
    //values,存放动画关键帧值
    //keytimes，配置每段动画的时间
    
    //path，动画路径
    
    
    
    //CAAnimationGroup是CAAnimation子类，相当于一个容器，
    
    
    //显示动画
    //不影响layer的相关属性
    
    //隐式动画
    //UIView的动画，动画结果会影响UIView的相关属性
    
    
    //modelLayer储存layer的相关属性值
    //presentationLayer负责告诉屏幕，显示的内容
    
    //当layer上无动画的时候，m和p的值为一样
    //当layer上有动画时，两值不一致。
    
    
    self.aLayer = [CALayer layer];
    self.aLayer.frame = CGRectMake(40, 40, 40, 40);
    self.aLayer.shadowColor = [UIColor blackColor].CGColor;
    self.aLayer.shadowOffset = CGSizeMake(4, 4);
    self.aLayer.shadowOpacity = 0.6;
    self.aLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:self.aLayer];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 400, 100, 44);
    [button addTarget:self action:@selector(tapButton3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    
}

-(void)tapButton3
{
    CAAnimationGroup * group = [CAAnimationGroup animation];
    group.duration = 5;
    
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:2];
    
    CABasicAnimation * transformA = [CABasicAnimation animationWithKeyPath:@"transform"];
   // transformA.duration = 3;
    
    CATransform3D start = self.aLayer.transform;
    transformA.fromValue = [NSValue valueWithCATransform3D:start];
    
     CATransform3D end = CATransform3DTranslate(start, 100, 100, 0);

    transformA.toValue = [NSValue valueWithCATransform3D:end];
    [arr addObject:transformA];
    
    
    CABasicAnimation * bgColor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    bgColor.fromValue = (__bridge id)(self.aLayer.backgroundColor);
    bgColor.toValue = (__bridge id)([UIColor blueColor].CGColor);
    
    [arr addObject:bgColor];
    
    
    group.animations = arr;
    
    [self.aLayer addAnimation:group forKey:nil];
    
}

-(void)tapButton2
{
    CAKeyframeAnimation * positionK = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionK.duration = 5;
    //创建一个圆形路径
    UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(40, 40, 200, 200)];
    positionK.path = path.CGPath;
    [self.aLayer addAnimation:positionK forKey:nil];
    
    
    
}

-(void)tapButton1
{
    CAKeyframeAnimation * positionK = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionK.duration = 10;
    
    NSMutableArray * values = [NSMutableArray arrayWithCapacity:5];
    
    CGPoint start = self.aLayer.position;
    [values addObject:[NSValue valueWithCGPoint:start]];
    CGPoint point1 = start;
    point1.x += 200;
    [values addObject:[NSValue valueWithCGPoint:point1]];
    CGPoint point2 = point1;
    point2.y += 200;
    [values addObject:[NSValue valueWithCGPoint:point2]];
    
    CGPoint point3 = point2;
    point3.x -= 200;
    [values addObject:[NSValue valueWithCGPoint:point3]];
    
    CGPoint end = point3;
    end.y -= 200;
    [values addObject:[NSValue valueWithCGPoint:end]];
    
    positionK.values = values;

    //数组里面元素是NSNumber类型，而且值为0-1之间，递增，
    //每两个值之间的差值为动画时间比例
    positionK.keyTimes = [NSArray arrayWithObjects:@0,@0.1,@0.4,@0.5,@1, nil];

    [self.aLayer addAnimation:positionK forKey:nil];
    
}
-(void)tapButton
{
    CABasicAnimation * positionA = [CABasicAnimation animationWithKeyPath:@"transform"];
    positionA.duration = 3;
    
    CATransform3D start = self.aLayer.transform;
    positionA.fromValue = [NSValue valueWithCATransform3D:start];
    
   // CATransform3D end = CATransform3DTranslate(start, 100, 100, 0);
    
   CATransform3D end = CATransform3DRotate(start, 3.14, 1, 0, 0);
    positionA.toValue = [NSValue valueWithCATransform3D:end];
    
    [self.aLayer addAnimation:positionA forKey:nil];
    
    
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
