//
//  FloatingCloudViewController.m
//  CALayerAnimTest
//
//  Created by Michael Nachbaur on 10-11-28.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import "FloatingCloudViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation FloatingCloudViewController

- (void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	
	UIImage *cloudImage = [UIImage imageNamed:@"cloud.png"];
	
	CALayer *cloud = [CALayer layer];
	cloud.contents = (id)cloudImage.CGImage;
	cloud.bounds = CGRectMake(0, 0, cloudImage.size.width, cloudImage.size.height);
	cloud.position = CGPointMake(self.view.bounds.size.width / 2,
								 cloudImage.size.height / 2);
	[self.view.layer addSublayer:cloud];
	
	CGPoint startPt = CGPointMake(self.view.bounds.size.width + cloud.bounds.size.width / 2,
								  cloud.position.y);
	CGPoint endPt = CGPointMake(cloud.bounds.size.width / -2,
								cloud.position.y);

	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"position"];
	anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
	anim.fromValue = [NSValue valueWithCGPoint:startPt];
	anim.toValue = [NSValue valueWithCGPoint:endPt];
	anim.repeatCount = HUGE_VALF;
	anim.duration = 8.0;
	[cloud addAnimation:anim forKey:@"position"];
}

@end
