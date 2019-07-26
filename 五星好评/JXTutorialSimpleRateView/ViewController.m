//
//  ViewController.m
//  JXTutorialSimpleRateView
//
//  Created by 汪骏祥 on 9/17/15.
//  Copyright (c) 2015 junxiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)ratingDidChange:(int)rating {
    [self.statusLbl setText:[NSString stringWithFormat:@"Rating: %d", rating]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rateView setEditable:YES
           andNotSelectedImage:[UIImage imageNamed:@"kermit_empty"]
              andSelectedImage:[UIImage imageNamed:@"kermit_full"]
                     andRating:0
                  andMaxRating:5
                   andDelegate:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
