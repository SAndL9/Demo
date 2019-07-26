//
//  UploadImgViewController.m
//  YHB_Prj
//
//  Created by Johnny's on 15/9/12.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "UploadImgViewController.h"
#import "NetManager.h"

@interface UploadImgViewController ()<UIAlertViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    int countNeedToUpload;
    CGFloat imgWidth;
    CGFloat interval;
    int deleteIndex;
}
@property(nonatomic,strong) UIView *bgView;
@property(nonatomic,strong) NSMutableArray *photoArr;
@property(nonatomic,strong) UIButton *btnOk;
@end

@implementation UploadImgViewController

- (instancetype)initWithUploadImgCount:(int)aCount
{
    if (self=[super init])
    {
        countNeedToUpload = aCount;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"上传图片";
    self.view.backgroundColor = [UIColor whiteColor];
    
    interval = 15;
    imgWidth = (kMainScreenWidth-interval*4)/3.0;
    
    _photoArr = [NSMutableArray arrayWithCapacity:0];
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, interval, kMainScreenWidth, imgWidth)];
    [self.view addSubview:_bgView];
    [self reloadView];
    
    CGFloat btnWidth = 240;
    _btnOk = [[UIButton alloc] initWithFrame:CGRectMake(kMainScreenWidth/2.0-btnWidth/2.0, kMainScreenHeight-64-60, btnWidth, 30)];
    [_btnOk setTitle:@"确定上传" forState:UIControlStateNormal];
    _btnOk.backgroundColor = KColor;
    _btnOk.titleLabel.font = kFont12;
    [_btnOk addTarget:self action:@selector(touchOk) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnOk];
}

//上传按钮事件
- (void)touchOk
{
    [NetManager uploadImgArry:_photoArr parameters:nil apiName:@"updateProductPicApp" uploadUrl:nil uploadimgName:nil progressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
    } succ:^(NSDictionary *successDict) {
        MLOG(@"%@", successDict);
    } failure:^(NSDictionary *failDict, NSError *error) {
        
    }];
}

- (void)reloadView
{
    [self removeSubviews:_bgView];
    CGFloat endWidth=0;
    for (int i=0; i<_photoArr.count; i++)
    {
        UIImage *img = _photoArr[i];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(endWidth+interval, 0, imgWidth, imgWidth)];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(touchPhoto:) forControlEvents:UIControlEventTouchUpInside];
        [btn setImage:img forState:UIControlStateNormal];
        [_bgView addSubview:btn];
        endWidth += interval+imgWidth;
    }
    if (_photoArr.count<countNeedToUpload)
    {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(endWidth+interval, 0, imgWidth, imgWidth)];
        btn.layer.borderWidth=0.5;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:@"+" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:btn];
    }
}

- (void)addPhoto
{
    UIActionSheet *sheet;
    
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        sheet  = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"拍照", @"从相册选择", nil];
    }
    else {
        sheet = [[UIActionSheet alloc] initWithTitle:@"选择图像" delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"取消" otherButtonTitles:@"从相册选择", nil];
    }
    
    sheet.tag = 255;
    
    [sheet showInView:self.view];
}

#pragma mark - action sheet delegte
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 255) {
        NSUInteger sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        // 判断是否支持相机
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            switch (buttonIndex) {
                case 0:
                    return;
                case 1: //相机
                    sourceType = UIImagePickerControllerSourceTypeCamera;
                    break;
                case 2: //相册
                    sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                    break;
            }
        }
        else {
            if (buttonIndex == 0) {
                return;
            } else {
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            }
        }
        
        if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) { // 从相册选择
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:picker.sourceType];
            
            if (kSystemVersion>7) {
                picker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
            }
            // 设置导航默认标题的颜色及字体大小
            picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
            [self presentViewController:picker animated:YES completion:nil];
        } else if (buttonIndex == UIImagePickerControllerSourceTypeCamera) { // 拍照
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;

            picker.delegate = self;
            if (kSystemVersion>7) {
                picker.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
            }
            // 设置导航默认标题的颜色及字体大小
            picker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                         NSFontAttributeName : [UIFont boldSystemFontOfSize:18]};
            [self presentViewController:picker animated:YES completion:nil];
        }
    }
    
}

#pragma mark - image picker delegte
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [_photoArr addObject:image];
    [self reloadView];
    if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        UIImage * oriImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 保存图片到相册中
        SEL selectorToCall = @selector(imageWasSavedSuccessfully:didFinishSavingWithError:contextInfo:);
        UIImageWriteToSavedPhotosAlbum(oriImage, self,selectorToCall, NULL);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void) imageWasSavedSuccessfully:(UIImage *)paramImage didFinishSavingWithError:(NSError *)paramError contextInfo:(void *)paramContextInfo{
    if (paramError == nil){
        NSLog(@"Image was saved successfully.");
        paramImage = nil;
    } else {
        NSLog(@"An error happened while saving the image.");
        NSLog(@"Error = %@", paramError);
    }
}

- (void)touchPhoto:(UIButton *)sender
{
    deleteIndex = (int)sender.tag-100;
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"是否要删除这张图片" message:nil delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
    [alertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==1)
    {
        [_photoArr removeObjectAtIndex:deleteIndex];
        [self reloadView];
    }
}

- (void)removeSubviews:(UIView *)aView
{
    while (aView.subviews.count)
    {
        UIView* child = aView.subviews.lastObject;
        [child removeFromSuperview];
    }
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

@end
