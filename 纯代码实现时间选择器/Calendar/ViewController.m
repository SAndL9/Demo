//
//  ViewController.m
//  Calendar
//
//  Created by Apple on 16/3/21.
//  Copyright © 2016年 Conductss. All rights reserved.
//

#import "ViewController.h"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
#define MainColor [UIColor colorWithRed:62.0/255.0 green:162.0/255.0 blue:232.0/255.0 alpha:1.0]

@interface ViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong,nonatomic) UIPickerView *datePicker;
@property (strong,nonatomic) UIView*timeSelectView;
@property (strong,nonatomic) UIButton *timeButtonLabel;
@property (strong,nonatomic) UIButton *cancelSelectTimeButton;
@property (strong,nonatomic) UIButton *determineSelectTimeButton;
@property (strong,nonatomic) NSMutableArray *myArray1;
@property (strong,nonatomic) NSMutableArray *myArray;
@property (strong,nonatomic) NSString  *timeSelectedString;
@property (strong,nonatomic)NSString  *str10;
@property (strong,nonatomic)NSString  *str11;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始时间选择文字
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月"];
    self.str10 = [formatter stringFromDate:[NSDate date]];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"yyyy年"];
    self.str11 = [formatter1 stringFromDate:[NSDate date]];
    self.timeSelectedString = [NSString stringWithFormat:@"%@%@",self.str11,self.str10];
    //设置pickerview初始默认
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM"];
    NSString *str111 = [formatter2 stringFromDate:[NSDate date]];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"yyyy"];
    NSString *str222 = [formatter3 stringFromDate:[NSDate date]];
    int a = [str111 intValue];
    int b = [str222 intValue];
    [self.datePicker selectRow:a-1 inComponent:1 animated:NO];
    [self.datePicker selectRow:b-1900 inComponent:0 animated:NO];
    [self.view addSubview:self.timeButtonLabel];
    [self.view addSubview:self.timeSelectView];
}

-(UIButton *)timeButtonLabel{
    if (!_timeButtonLabel) {
        _timeButtonLabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 56, SCREENWIDTH, 55)];
        [_timeButtonLabel setTitleColor:[UIColor grayColor] forState:UIControlStateNormal ];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy年MM月"];
        NSString *str10 = [formatter stringFromDate:[NSDate date]];
        [_timeButtonLabel setTitle:str10 forState:UIControlStateNormal];
        [_timeButtonLabel addTarget:self action:@selector(timeSelectedButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeButtonLabel;
}

-(void)timeSelectedButtonAction{

    
    [self.view addSubview:self.timeSelectView];
    [UIView animateWithDuration:0.3 animations:^{
        self.timeSelectView.frame = CGRectMake(0, SCREENHEIGHT-315, SCREENWIDTH, 316);
    }];
}



#pragma  mark - timeSelected
-(UIView *)timeSelectView{
    if (!_timeSelectView) {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        label.text = @"时间选择";
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        
        _timeSelectView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 316)];
        _timeSelectView.backgroundColor = [UIColor whiteColor];
        [_timeSelectView addSubview:label];
        [_timeSelectView addSubview:self.datePicker];
        [_timeSelectView addSubview:self.cancelSelectTimeButton];
        [_timeSelectView addSubview:self.determineSelectTimeButton];
    }
    return _timeSelectView;
}
-(UIPickerView *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 150)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.dataSource = self;
        _datePicker.delegate = self;
    }
    return _datePicker;
}

-(UIButton *)cancelSelectTimeButton{
    if (!_cancelSelectTimeButton) {
        _cancelSelectTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(30, 200, 80, 40)];
        _cancelSelectTimeButton.backgroundColor = MainColor;
        _cancelSelectTimeButton.layer.cornerRadius = 5;
        _cancelSelectTimeButton.layer.masksToBounds = YES;
        [_cancelSelectTimeButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelSelectTimeButton addTarget:self action:@selector(cancelSelectTimeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelSelectTimeButton;
}


-(UIButton *)determineSelectTimeButton{
    if (!_determineSelectTimeButton) {
        _determineSelectTimeButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, 200, 80, 40)];
        _determineSelectTimeButton.backgroundColor = MainColor;
        _determineSelectTimeButton.layer.cornerRadius = 5;
        _determineSelectTimeButton.layer.masksToBounds = YES;
        [_determineSelectTimeButton setTitle:@"确定" forState:UIControlStateNormal];
        [_determineSelectTimeButton addTarget:self action:@selector(determineSelectTimeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _determineSelectTimeButton;
}

-(void)cancelSelectTimeButtonAction{
    [UIView animateWithDuration:0.3 animations:^{
        self.timeSelectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 316);
    }];

}


-(void)determineSelectTimeButtonAction{
    [self.timeButtonLabel setTitle:self.timeSelectedString forState:UIControlStateNormal];
    [UIView animateWithDuration:0.3 animations:^{
        self.timeSelectView.frame = CGRectMake(0, SCREENHEIGHT, SCREENWIDTH, 316);
    }];
    
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    if (component == 0) {
        self.str11 = self.myArray[row];
    }else{
        self.str10 = self.myArray1[row];
    }
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"MM"];
    NSString *str111 = [formatter2 stringFromDate:[NSDate date]];
    NSDateFormatter *formatter3 = [[NSDateFormatter alloc] init];
    [formatter3 setDateFormat:@"yyyy"];
    NSString *str222 = [formatter3 stringFromDate:[NSDate date]];
    int a = [str111 intValue];
    int b = [str222 intValue];
    int c = [self.str10 intValue];
    int d = [self.str11 intValue];
    if (d>b||(d==b&&c>a)) {
        [self.datePicker selectRow:a-1 inComponent:1 animated:YES];
        [self.datePicker selectRow:b-1900 inComponent:0 animated:YES];
    }
    
    self.timeSelectedString = [NSString stringWithFormat:@"%@%@",self.str11,self.str10];
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0) {
        return 200;
    }else {
        return 12;
    }
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (component == 0) {
        return  self.myArray[row];
    }else {
        return  self.myArray1[row];
    }
}


-(NSMutableArray *)myArray1{
    if (!_myArray1) {
        self.myArray1 = [[NSMutableArray alloc]init];
        for (int i = 1; i<13; i++) {
            NSString *str = [NSString stringWithFormat:@"%d%@",i,@"月"];
            [self.myArray1 addObject:str];
        }
    }
    return _myArray1;
}
-(NSMutableArray *)myArray{
    if (!_myArray) {
        self.myArray = [[NSMutableArray alloc]init];
        for (int i = 1900; i<2100; i++) {
            NSString *str = [NSString stringWithFormat:@"%d%@",i,@"年"];
            [self.myArray addObject:str];
        }
    }
    return _myArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
