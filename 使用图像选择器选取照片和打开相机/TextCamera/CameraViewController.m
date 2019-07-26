//
//  CameraViewController.m
//  TextCamera
//
//  Created by lanouhn on 15/4/29.
//  Copyright (c) 2015年 lnx. All rights reserved.
//

#import "CameraViewController.h"

@interface CameraViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UIImageView *imageView;
}
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}


//Implement loadView to create a view hierarchy programmatically,without using nib.

//Implement(实现),hierarchy(层次),programmatically(编程方式)


-(void)loadView{
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, 667)] autorelease];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //新建图片显示视图
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(50, 20, 275, 350)];
    imageView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:imageView];
     [imageView release];
    
    //新建照相机控制按钮
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cameraButton.frame = CGRectMake(60, 450, 255, 40);
    [cameraButton setTitle:@"照相机" forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(openCamera) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cameraButton];
    
    //新建图片库控制按钮
    UIButton *photoesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    photoesButton.frame = CGRectMake(60, 520, 255, 40);
    [photoesButton setTitle:@"图片库" forState:UIControlStateNormal];
    [photoesButton addTarget:self action:@selector(openPhotoes) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:photoesButton];
}

//图片库打开方法
-(void)openPhotoes{
    //创建图像选择器类的一个实例对象
     UIImagePickerController *imagePickC = [[UIImagePickerController alloc]init];
    //图片来源:(相册 照相机 图片库) sourceType枚举
    imagePickC.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;//从现有的照片库选择图片, 选择范围仅限最近的相册
    //UIImagePickerControllerSourceTypePhotoLiabrary 从现有的照片库中取出图片
    //UIImagePickerControllerSourceTypeCamera 从内置的照相机选取图片或者视频,并将照片返回到委托
    
    imagePickC.delegate = self;
    //是否可以对图片进行操作 (放大缩小、位置移动等)
    imagePickC.allowsEditing = NO;
    
    //当前
    [self presentViewController:imagePickC animated:YES completion:^{
    
         }];
    [imagePickC release];
}

//照相机打开方法
-(void)openCamera{
   
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePickC = [[UIImagePickerController alloc]init];
        //图片来源:(相册 照相机 图片库)
        imagePickC.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        imagePickC.delegate = self;
        [self presentViewController:imagePickC animated:YES completion:^{
            
        }];
        [imagePickC release];
        
        //如果没有内置相机, 则发出提示
        
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您的手机没有照相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIImagePickerControllerDelegate
//当用户成功拍摄或者从照片库中选择一张图片时, 调用此方法
//图片获取 完成选择信息
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"%@",info);
    //UIImagePickerControllerOriginalImage 原始图片
    //UIImagePickerControllerOriginalEditedImage 编辑过的图片
    imageView.image = [info valueForKey:@"UIImagePickerControllerOriginalImage"];
    [picker dismissViewControllerAnimated:YES completion:^{
//        NSValue *crepRect = [info objectForKey:UIImagePickerControllerCropRect];
//        CGRect rect = [crepRect CGRectValue];
    }];
    
}

//当用户取消拍照或者选择图像时, 调用此方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
