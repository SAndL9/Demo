    //
//  ButtonActionsViewController.m
//  CALayerAnimTest
//
//  Created by Michael Nachbaur on 11-01-01.
//  Copyright 2011 Decaf Ninja Software. All rights reserved.
//

#import "ButtonActionsViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface ButtonActionsViewController (Private)

- (void)buttonClicked:(id)sender;

@end

typedef enum {
	ButtonActionsBehaviorTypeNone,
	ButtonActionsBehaviorTypeExpand,
	ButtonActionsBehaviorTypeAnimateTrash
} ButtonActionsBehaviorType;

@implementation ButtonActionsViewController

- (void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
	
	UIScrollView *scrollView = [[[UIScrollView alloc] initWithFrame:self.view.bounds] autorelease];
	scrollView.bounces = YES;
	[self.view addSubview:scrollView];
	
	// Scale out on click
	{
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 320, 24)] autorelease];
		label.text = @"Scale button";
		label.textAlignment = UITextAlignmentCenter;
		[label sizeToFit];
		[scrollView addSubview:label];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.center = CGPointMake(220, 30);
		button.tag = ButtonActionsBehaviorTypeExpand;
		[button setTitle:@"Delete" forState:UIControlStateNormal];
		[button sizeToFit];
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:button];
	}
	
	// Animated trash delete
	{
		UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(10, 126, 320, 24)] autorelease];
		label.text = @"Animate image into trash button";
		label.textAlignment = UITextAlignmentCenter;
		[label sizeToFit];
		[scrollView addSubview:label];
		
		UIImageView *icon = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carmodel.png"]] autorelease];
		icon.center = CGPointMake(290, 150);
		icon.tag = ButtonActionsBehaviorTypeAnimateTrash;
		[scrollView addSubview:icon];
		
		UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		button.center = CGPointMake(40, 200);
		button.tag = ButtonActionsBehaviorTypeAnimateTrash;
		[button setTitle:@"Delete Icon" forState:UIControlStateNormal];
		[button sizeToFit];
		[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:button];
		[scrollView bringSubviewToFront:icon];
	}
	
	// Determine the size of all subviews of the scrollview
	CGRect contentSize = CGRectZero;
	for (UIView *subview in scrollView.subviews) {
		contentSize = CGRectUnion(contentSize, subview.frame);
	}
	scrollView.contentSize = contentSize.size;
}

- (void)buttonClicked:(id)sender {
	UIView *senderView = (UIView*)sender;
	if (![senderView isKindOfClass:[UIView class]])
		return;
	
	switch (senderView.tag) {
		case ButtonActionsBehaviorTypeExpand: {
			CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
			anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
			anim.duration = 0.125;
			anim.repeatCount = 1;
			anim.autoreverses = YES;
			anim.removedOnCompletion = YES;
			anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
			[senderView.layer addAnimation:anim forKey:nil];

			break;
		}

		case ButtonActionsBehaviorTypeAnimateTrash: {
			UIView *icon = nil;
			for (UIView *theview in senderView.superview.subviews) {
				if (theview.tag != ButtonActionsBehaviorTypeAnimateTrash)
					continue;
				if ([theview isKindOfClass:[UIImageView class]]) {
					icon = theview;
					break;
				}
			}
			
			if (!icon)
				return;
			
			UIBezierPath *movePath = [UIBezierPath bezierPath];
			[movePath moveToPoint:icon.center];
			[movePath addQuadCurveToPoint:senderView.center
							 controlPoint:CGPointMake(senderView.center.x, icon.center.y)];
			
			CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
			moveAnim.path = movePath.CGPath;
			moveAnim.removedOnCompletion = YES;
			
			CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
			scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
			scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
			scaleAnim.removedOnCompletion = YES;
			
			CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
			opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
			opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
			opacityAnim.removedOnCompletion = YES;
			
			CAAnimationGroup *animGroup = [CAAnimationGroup animation];
			animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
			animGroup.duration = 0.5;
			[icon.layer addAnimation:animGroup forKey:nil];

			break;
		}
	}
}

@end
