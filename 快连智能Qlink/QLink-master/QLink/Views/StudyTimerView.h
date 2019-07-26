//
//  StudyTimerView.h
//  QLink
//
//  Created by 尤日华 on 14-10-13.
//  Copyright (c) 2014年 SANSAN. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol StudyTimerDelegate <NSObject>

-(void)done;

@end

@interface StudyTimerView : UIView

@property(nonatomic,weak) IBOutlet UILabel *lTimer;
@property(nonatomic,assign) int pTime;
@property(nonatomic,assign) id<StudyTimerDelegate>delegate;

-(IBAction)btnDone;
-(void)startTimer;

@end
