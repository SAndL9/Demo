
//  ViewController.m
//  AnimationDemo
//
//  Created by 天蓝 on 2017/3/9.
//  Copyright © 2017年 PT. All rights reserved.
//

#import "ViewController.h"
#import "StarView.h"
#import "FireworkView.h"
#import "EggsView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self qipao];
//    [self xingxing];
//    [self yanhua];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [EggsView showEggsViewWithType:1];
}

- (void)yanhua
{
    FireworkView *view = [[FireworkView alloc] initWithFrame:CGRectMake(100, 300, 80, 80)];
    [self.view addSubview:view];
}

- (void)qipao
{
    CAEmitterLayer *emitter = [CAEmitterLayer layer];
    emitter.emitterPosition = CGPointMake(self.view.bounds.size.width/2, self.view.bounds.size.height - 60);
    emitter.emitterSize = CGSizeMake(self.view.bounds.size.width, 0);
    emitter.emitterZPosition = -1;
    emitter.emitterShape = kCAEmitterLayerLine;
    emitter.emitterMode = kCAEmitterLayerAdditive;
    emitter.preservesDepth = YES;
    emitter.emitterDepth = 10;
    
    CAEmitterCell *cell = [CAEmitterCell emitterCell];
    cell.birthRate = 0.5;
    cell.lifetime = 20;
    cell.lifetimeRange = 5;
    cell.velocity = 30;
    cell.velocityRange = 10;
    cell.yAcceleration = -2;
    cell.zAcceleration = -2;
    cell.enabled = YES;
    cell.scale = 1;
    cell.scaleRange = 0.2;
    cell.scaleSpeed = 0.1;
    cell.contents = (__bridge id _Nullable)([[UIImage imageNamed:@"4"] CGImage]);
    emitter.emitterCells = @[cell];
    [self.view.layer addSublayer:emitter];
}

- (void)xingxing
{
    StarView *view = [[StarView alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
    StarView *view1 = [[StarView alloc] initWithFrame:CGRectMake(60, 180, 40, 40)];
    StarView *view2 = [[StarView alloc] initWithFrame:CGRectMake(140, 220, 40, 40)];
    
    [self.view addSubview:view];
    [self.view addSubview:view1];
    [self.view addSubview:view2];
}

- (void)createAnimation
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 100, 100, 100)];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position.x";
    animation.fromValue = @50;
    animation.toValue = @200;
    animation.duration = 2;
    [view.layer addAnimation:animation forKey:nil];
    view.layer.position = CGPointMake(200, 100);
}



@end
