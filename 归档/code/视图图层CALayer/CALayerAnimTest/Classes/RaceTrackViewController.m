//
//  RaceTrackViewController.m
//  CALayerAnimTest
//
//  Created by Michael Nachbaur on 10-11-28.
//  Copyright 2010 Decaf Ninja Software. All rights reserved.
//

#import "RaceTrackViewController.h"
#import <QuartzCore/QuartzCore.h>

#define degreesToRadians(x) (M_PI * x / 180.0)
#define P(x,y) CGPointMake(x, y)

@implementation RaceTrackViewController



- (void)loadView {
	[super loadView];
	
	self.view.backgroundColor = [UIColor greenColor];	

	UIBezierPath *trackPath = [UIBezierPath bezierPath];
	[trackPath moveToPoint:P(160, 25)];
	[trackPath addCurveToPoint:P(300, 120)
				 controlPoint1:P(320, 0)
				 controlPoint2:P(300, 80)];
	[trackPath addCurveToPoint:P(80, 380)
				 controlPoint1:P(300, 200)
				 controlPoint2:P(200, 480)];
	[trackPath addCurveToPoint:P(140, 300)
				 controlPoint1:P(0, 300)
				 controlPoint2:P(200, 220)];
	[trackPath addCurveToPoint:P(210, 200)
				 controlPoint1:P(30, 420)
				 controlPoint2:P(280, 300)];
	[trackPath addCurveToPoint:P(70, 110)
				 controlPoint1:P(110, 80)
				 controlPoint2:P(110, 80)];
	[trackPath addCurveToPoint:P(160, 25)
				 controlPoint1:P(0, 160)
				 controlPoint2:P(0, 40)];
	
    
	CAShapeLayer *racetrack = [CAShapeLayer layer];
	racetrack.path = trackPath.CGPath;
	racetrack.strokeColor = [UIColor blackColor].CGColor;
	racetrack.fillColor = [UIColor orangeColor].CGColor;
	racetrack.lineWidth = 30.0;
    
	[self.view.layer addSublayer:racetrack];

	CAShapeLayer *centerline = [CAShapeLayer layer];
	centerline.path = trackPath.CGPath;
	centerline.strokeColor = [UIColor whiteColor].CGColor;
	centerline.fillColor = [UIColor clearColor].CGColor;
	centerline.lineWidth = 2.0;
	centerline.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:6], [NSNumber numberWithInt:2],[NSNumber numberWithInt:4], nil];
	[self.view.layer addSublayer:centerline];
	
	CALayer *car = [CALayer layer];
	car.bounds = CGRectMake(0, 0, 44.0, 20.0);
	car.position = P(160, 25);
	car.contents = (id)([UIImage imageNamed:@"carmodel.png"].CGImage);
	[self.view.layer addSublayer:car];
	
	CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	anim.path = trackPath.CGPath;
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.autoreverses = YES;
	anim.rotationMode = kCAAnimationRotateAutoReverse;
	//anim.repeatCount = HUGE_VALF;
	anim.duration = 8.0;
	[car addAnimation:anim forKey:@"race"];
}


@end
