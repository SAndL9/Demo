//
//  FolderViewCell.h
//  Note_project_CoreData
//
//  Created by lanouhn on 16/5/5.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FolderViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@property (nonatomic,strong)UILongPressGestureRecognizer *longPress;
@end
