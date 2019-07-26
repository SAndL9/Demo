//
//  ThirdViewController.m
//  app
//
//  Created by apple on 15/7/9.
//  Copyright (c) 2015年 rong. All rights reserved.
//

#import "ThirdViewController.h"

@interface ThirdViewController ()

@property (strong, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation ThirdViewController
NSArray* pickerData;
NSArray* allKeys;
NSArray* allKeys2;
NSInteger selected;
NSInteger selected2;
NSInteger selected3;


- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"];
    pickerData = [[NSArray alloc]initWithContentsOfFile:plistPath];
    allKeys = [[pickerData objectAtIndex:0] allKeys];
    allKeys2 = [[[[pickerData objectAtIndex:0] objectForKey:[allKeys objectAtIndex:0]] objectAtIndex:0] allKeys];
    selected = 0;
    selected2 = 0;
    selected3 = 0;
    self.picker.dataSource = self;
    self.picker.delegate = self;


    

    }
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return pickerData.count;
    }
    if (component == 1) {
       return [[[pickerData objectAtIndex:selected] objectForKey:[allKeys objectAtIndex:0]] count];
    }
    return [[[[[pickerData objectAtIndex:selected] objectForKey:[allKeys objectAtIndex:0]] objectAtIndex:selected2] objectForKey:[allKeys2 objectAtIndex:0]] count];
}
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {

        return [[pickerData objectAtIndex:row] objectForKey:[allKeys objectAtIndex:1]];
    }
   else  if (component == 1) {
        return [[[[pickerData objectAtIndex:selected] objectForKey:[allKeys objectAtIndex:0]] objectAtIndex:row] objectForKey:[allKeys2 objectAtIndex:1]];
    }
    else if (![[[[[pickerData objectAtIndex:selected] objectForKey:[allKeys objectAtIndex:0]] objectAtIndex:0] objectForKey:[allKeys2 objectAtIndex:0]] count] ) {
        return @" ";
     }
        return [[[[[pickerData objectAtIndex:selected] objectForKey:[allKeys objectAtIndex:0]] objectAtIndex:selected2] objectForKey:[allKeys2 objectAtIndex:0]] objectAtIndex:row];



}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (component == 0) {
        selected = row;
        [self.picker reloadComponent:1];
    }
    else if (component == 1) {
        selected2 = row;
        [self.picker reloadComponent:2];
    }
}
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    if (component == 0) {
        return 80;
    }
    if (component ==1) {
        return 130;
    }
    return 100;
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

