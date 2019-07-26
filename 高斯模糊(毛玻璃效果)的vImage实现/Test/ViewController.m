//
//  ViewController.m
//  Test
//
//  Created by lisongrc on 15/8/20.
//  Copyright (c) 2015年 rcplatform. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Utility.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) UIImage *image;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _image = [UIImage imageNamed:@"a"];
    _imageView.image = _image;
}

- (IBAction)sliderValueChange:(UISlider *)sender {
    _imageView.image = [_image gaussBlur:sender.value];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
