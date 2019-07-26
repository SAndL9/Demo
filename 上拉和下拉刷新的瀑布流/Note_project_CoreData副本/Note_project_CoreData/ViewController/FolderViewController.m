//
//  FolderViewController.m
//  Note_project_CoreData
//
//  Created by lanouhn on 16/5/5.
//  Copyright © 2016年 lanouhn. All rights reserved.
//

#import "FolderViewController.h"
#import "HeaderReusableView.h"
#import "FolderViewCell.h"
#import "Folder.h"
#import "AddFolderView.h"
#import "AppDelegate.h"
@interface FolderViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)NSMutableArray *dataSource;

// 用来储存应用程序代理的数据管理对象6.1
@property (nonatomic,strong)NSManagedObjectContext *managedObjectContext;
@end

@implementation FolderViewController
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        self.dataSource = [NSMutableArray array];
    }
    return _dataSource;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    // 制造假数据
//    for (int i = 0; i < 10; i++) {
//        [self.dataSource addObject:[NSString stringWithFormat:@"文件%d",i+1]];
//    }
    
    
    // 获取应用程序对象的数据管理器对象6.2
    self.managedObjectContext = [(AppDelegate *)[UIApplication sharedApplication].delegate managedObjectContext];
    
    
    
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count + 1;
}

#pragma mark - 2.返回cell的方法
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    FolderViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"folderCell" forIndexPath:indexPath];
    cell.layer.cornerRadius = 30;
    cell.clipsToBounds = YES;

    if (indexPath.row ==  0) {
        
        cell.titleLabel.text = @"+";
        cell.titleLabel.font = [UIFont systemFontOfSize:30.0];
        cell.dateLabel.alpha = 0.0;
        
        
    } else {
        
//        NSString *title = self.dataSource[indexPath.row - 1];
        
        Folder *folder = self.dataSource[indexPath.row - 1];
        cell.titleLabel.text = folder.title;
        
        
        NSDate *date = [NSDate date];
        
//        NSDate *date = folder.creatDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *dateString = [formatter stringFromDate:date];
        cell.dateLabel.font = [UIFont systemFontOfSize:10.0];
        cell.dateLabel.alpha = 1.0;
        cell.dateLabel.text = dateString;
        
        
        // 给cell的longPress手势关联目标方法
        [cell.longPress addTarget:self action:@selector(handleLongPress:)];
        
    }
   
    return cell;
}
#pragma mark - 1.返回区头区尾视图的方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        HeaderReusableView *view  = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:@"headerView" forIndexPath:indexPath];
        view.sectionTitle.text = @"自定义文件夹";
        return view;
    }
    return nil;

}
#pragma mark <UICollectionViewDelegate>
#pragma mark - 3.选中cell会触发

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        AddFolderView * addView = [[[NSBundle mainBundle]loadNibNamed:@"AddFolderView" owner:nil options:nil]lastObject];
        addView.frame = self.collectionView.bounds;
        
        // 设置代理
        addView.titleField.delegate = self;
        
        [self.collectionView addSubview:addView];
    
        
    } else {
        
        [self performSegueWithIdentifier:@"passToNoteList" sender:indexPath];
    
    }

    
}
#pragma mark - 长按手势方法的实现
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        FolderViewCell *cell = (FolderViewCell *)sender.view;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
        if (indexPath.row) {
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"你确定要删除文件夹吗?" preferredStyle:(UIAlertControllerStyleAlert)];
            
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
            
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
 // 确定之后的操作
                // 删除数据源
                [self.dataSource removeObjectAtIndex:indexPath.row - 1];
                
                // 更新UI
                NSIndexSet * set = [NSIndexSet indexSetWithIndex:indexPath.section];
                // 只更新这个分区的数据
                [self.collectionView reloadSections:set];
                
                
            }];
            
            [alertVC addAction:action1];
            [alertVC addAction:action2];
            
            [self presentViewController:alertVC animated:YES completion:nil];
        }
        
        
        
    }
    
    
}


#pragma mark - 6.点击return 回收键盘取出文本框的内容保存

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
//    NSLog(@"保存");
    if (textField.text.length) {
        Folder *folder = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:self.managedObjectContext];
        
        folder.title = textField.text;
        folder.creatDate = [NSDate date];
        
        // 保存操作
        [self.managedObjectContext save:nil];
        // 添加到数据源
        [self.dataSource addObject:folder];
        // 重走数据源代理方法
        [self.collectionView reloadData];
        
    }
    return YES;
}




/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

@end
