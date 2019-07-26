//
//  AddFolderView.m
//  Note_project_CoreData
//
//  Created by lanouhn on 16/5/5.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "AddFolderView.h"

@implementation AddFolderView

#pragma mark - 4.点击结束的时候让他从父视图上移除
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    [self removeFromSuperview];
}


@end
