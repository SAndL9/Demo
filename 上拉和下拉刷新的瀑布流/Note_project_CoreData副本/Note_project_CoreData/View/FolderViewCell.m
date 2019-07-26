//
//  FolderViewCell.m
//  Note_project_CoreData
//
//  Created by lanouhn on 16/5/5.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "FolderViewCell.h"

@implementation FolderViewCell

// 使用XIB或者storyBoard创建的视图,要在视图添加手势或者子视图等可以使用这个符
- (void)awakeFromNib{
    self.longPress = [[UILongPressGestureRecognizer alloc]init];
    [self addGestureRecognizer:self.longPress];
    
}




@end
