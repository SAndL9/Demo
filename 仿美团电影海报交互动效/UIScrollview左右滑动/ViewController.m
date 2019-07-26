//
//  ViewController.m
//  UIScrollview左右滑动
//
//  Created by naiveBoy on 2017/1/13.
//  Copyright © 2017年 liuweipeng. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+LargeArea.h"
#define cellPageWidth 60
#define space 10
#define ScrollViewEnlargeLeftSpace ( CGRectGetWidth([UIScreen mainScreen].bounds)/2 - cellPageWidth/2 )

#define ScrollViewEnlargeRightSpace ( CGRectGetWidth([UIScreen mainScreen].bounds)/2 - (cellPageWidth/2+space) )

@interface ViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *myScroolView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *contentLabels;

@property (nonatomic, assign) CGFloat lastScollPosition;
@property (nonatomic, assign) CGFloat customPageWidth;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, assign) NSInteger pageCount;

@property (nonatomic, strong) UILabel *selectLabel;
@property (nonatomic, assign) CGFloat lastScrollPosition;
@property (nonatomic, assign) BOOL userDragging;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.pageCount = self.contentLabels.count;
    self.customPageWidth = space + cellPageWidth;
    // Do any additional setup after loading the view, typically from a nib.
    [self.myScroolView setEnlargeEdgeWithTop:0 left:ScrollViewEnlargeLeftSpace bottom:0 right:ScrollViewEnlargeRightSpace];
    self.myScroolView.layer.masksToBounds = NO;
    self.myScroolView.pagingEnabled = YES;
    self.myScroolView.delegate = self;
    
    self.selectLabel = self.contentLabels[0];
    self.selectLabel.transform = CGAffineTransformMakeScale(1, 1.5);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndDecelerating");
//    self.lastScollPosition = scrollView.contentOffset.x;
//    // 这里处理切换页面后需要调用的逻辑
//    self.pageIndex = scrollView.contentOffset.x/ self.customPageWidth;
//    
////    NSLog(@"偏移量%f,page= %ld",scrollView.contentOffset.x, self.pageIndex);
//    
//    self.selectLabel.transform = CGAffineTransformMakeScale(1, 1);
//    UILabel *selectLabel = self.contentLabels[_pageIndex];
//    selectLabel.transform = CGAffineTransformMakeScale(1, 1.5);
//    self.selectLabel = selectLabel;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSInteger index = floor((scrollView.contentOffset.x - self.customPageWidth/2)/self.customPageWidth)+1;
    double currentOffX = scrollView.contentOffset.x;
    double DIF = (currentOffX - index *self.customPageWidth);
    
    if (currentOffX > self.lastScollPosition) {
        if (DIF >= 0 && DIF <=self.customPageWidth/2) {
            UILabel *labelA;
            if (-1< index < self.pageCount) {
                labelA = self.contentLabels[index];
            } else {
                labelA = nil;
            }
            labelA.transform = CGAffineTransformMakeScale(1, (150- 50.0*fabs(DIF)/self.customPageWidth)/100.0);
            UILabel *labelB;
            if (index+1 >= self.pageCount) {
                labelB = nil;
            } else {
                labelB = self.contentLabels[index+1];
            }
            labelB.transform = CGAffineTransformMakeScale(1, (100 + 50*fabs(DIF)/self.customPageWidth )/100.0);
        }
        if (-self.customPageWidth/2<= DIF && DIF <0) {
            UILabel *labelA;
            if (-1< index && index < self.pageCount) {
                labelA = self.contentLabels[index];
            } else {
                labelA = nil;
            }
            labelA.transform = CGAffineTransformMakeScale(1, (150- 50.0*fabs(DIF)/self.customPageWidth)/100.0);
            UILabel *labelC;
            if (index-1 < 0) {
                labelC = nil;
            } else {
                labelC = self.contentLabels[index-1];
            }
            labelC.transform = CGAffineTransformMakeScale(1, (100 + 50*fabs(DIF)/self.customPageWidth )/100.0);
        }
    } else {
        if (DIF <0 && DIF >=-self.customPageWidth/2) {
            UILabel *labelA;
            if (-1< index && index < self.pageCount) {
                labelA = self.contentLabels[index];
            } else {
                labelA = nil;
            }
            labelA.transform = CGAffineTransformMakeScale(1, (150- 50.0*fabs(DIF)/self.customPageWidth)/100.0);
            UILabel *labelC;
            if (index-1 < 0) {
                labelC = nil;
            } else {
                labelC = self.contentLabels[index-1];
            }
            labelC.transform = CGAffineTransformMakeScale(1, (100 + 50*fabs(DIF)/self.customPageWidth )/100.0);
        } else if (DIF >= 0 && DIF <= self.customPageWidth/2) {
            UILabel *labelA;
            if (-1< index && index < self.pageCount) {
                labelA = self.contentLabels[index];
            } else {
                labelA = nil;
            }
            labelA.transform = CGAffineTransformMakeScale(1, (150- 50.0*fabs(DIF)/self.customPageWidth)/100.0);
            UILabel *labelB;
            if (index+1 >= self.pageCount) {
                labelB = nil;
            } else {
                labelB = self.contentLabels[index+1];
            }
            labelB.transform = CGAffineTransformMakeScale(1, (100 + 50*fabs(DIF)/self.customPageWidth )/100.0);
        }
    }
}

@end
