//
//  RegisterViewController.m
//  QLink
//
//  Created by 尤日华 on 15-1-7.
//  Copyright (c) 2015年 SANSAN. All rights reserved.
//

#import "RegisterViewController.h"
#import "ILBarButtonItem.h"
#import "AFHTTPRequestOperation.h"
#import "NetworkUtil.h"
#import "DataUtil.h"
#import "SVProgressHUD.h"
#import "UIAlertView+MKBlockAdditions.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *tfInviteCode;
@property (weak, nonatomic) IBOutlet UITextField *tfName;
@property (weak, nonatomic) IBOutlet UITextField *tfPassWord;
@property (weak, nonatomic) IBOutlet UITextField *tfPassWordTwo;

@property (weak, nonatomic) IBOutlet UIImageView *ivLogo;

@end

@implementation RegisterViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self initNavigation];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initControlSet];
    
    [self registerObserver];
}

-(void)initControlSet
{
    //设置输入框代理
    _tfName.delegate = self;
    _tfInviteCode.delegate = self;
    _tfPassWord.delegate = self;
    _tfPassWord.secureTextEntry = YES;
    _tfPassWordTwo.delegate = self;
    _tfPassWordTwo.secureTextEntry = YES;
    
    [_tfName setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    [_tfInviteCode setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    [_tfPassWord setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    [_tfPassWordTwo setValue:[NSNumber numberWithInt:10] forKey:PADDINGLEFT];
    
    Control *control = [SQLiteUtil getControlObj];
    if (control && control.Jslogo) {
        UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[DataUtil getDirectoriesInDomains] stringByAppendingPathComponent:@"logo.png"]];
        self.ivLogo.image = image;
    }
}

-(void)registerObserver
{
    //注册键盘出现与隐藏时候的通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboadWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}


//设置导航
-(void)initNavigation
{
    [self.navigationController.navigationBar setHidden:NO];
    
    ILBarButtonItem *back =
    [ILBarButtonItem barItemWithImage:[UIImage imageNamed:@"首页_返回.png"]
                        selectedImage:[UIImage imageNamed:@"首页_返回.png"]
                               target:self
                               action:@selector(btnBackPressed)];
    
    self.navigationItem.leftBarButtonItem = back;
    
    UIButton *btnTitle = [UIButton buttonWithType:UIButtonTypeCustom];
    btnTitle.frame = CGRectMake(0, 0, 100, 20);
    [btnTitle setTitle:@"注册" forState:UIControlStateNormal];
    btnTitle.titleEdgeInsets = UIEdgeInsetsMake(-5, 0, 0, 0);
    btnTitle.backgroundColor = [UIColor clearColor];
    
    [btnTitle setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.titleView = btnTitle;
}

-(void)btnBackPressed
{
    [self.navigationController popViewControllerAnimated:YES];
}

//注册
- (IBAction)btnRegisterPressed:(id)sender
{
    NSString *mobile = _tfName.text;
    NSString *pwd = _tfPassWord.text;
    NSString *pwd1 = _tfPassWordTwo.text;
    if ([DataUtil checkNullOrEmpty:mobile] || [DataUtil checkNullOrEmpty:pwd] || [DataUtil checkNullOrEmpty:pwd1]) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"请输入完整信息"];
        return;
    }
    if (![DataUtil isValidateMobile:mobile]) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"请输入正确的手机号"];
        return;
    }
    if (pwd.length < 6) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"密码最少6位"];
        return;
    }
    if (![pwd isEqualToString:pwd1]) {
        [UIAlertView alertViewWithTitle:@"温馨提示" message:@"两次密码输入不一致"];
        return;
    }
    
    [self.view endEditing:YES];

    [SVProgressHUD show];
    
    NSString *sUrl = [NetworkUtil getRegisterUrl:mobile andPwd:pwd andICode:_tfInviteCode.text];
    NSURL *url = [NSURL URLWithString:sUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    define_weakself;
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject)
     {
         NSString *sConfig = [[NSString alloc] initWithData:responseObject encoding:[DataUtil getGB2312Code]];
         NSRange range = [sConfig rangeOfString:@"error"];
         if (range.location != NSNotFound)
         {
             NSArray *errorArr = [sConfig componentsSeparatedByString:@":"];
             if (errorArr.count > 1) {
                 [SVProgressHUD showErrorWithStatus:errorArr[1]];
                 return;
             }
         }
         
         [SVProgressHUD showSuccessWithStatus:@"注册成功"];
         
         NSArray *infoArr = [sConfig componentsSeparatedByString:@":"];
         weakSelf.loginVC.tfKey.text = infoArr[1];
         weakSelf.loginVC.tfName.text = weakSelf.tfName.text;
         weakSelf.loginVC.tfPassword.text = weakSelf.tfPassWord.text;
         [self.navigationController popViewControllerAnimated:YES];
         
     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         [SVProgressHUD dismiss];
         [UIAlertView alertViewWithTitle:@"温馨提示" message:@"请检查网络链接"];
     }];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperation:operation];
}

#pragma mark -
#pragma mark UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"登录页_输入框02.png"];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    textField.background = [UIImage imageNamed:@"登录页_输入框01.png"];
}

#pragma mark -
#pragma mark 通知注册

//键盘出现时候调用的事件
-(void) keyboadWillShow:(NSNotification *)note{
    [UIView animateWithDuration:0.2 animations:^(void){
        self.view.frame = CGRectMake(0, -40, 320, self.view.frame.size.height);
    }];
}

//键盘消失时候调用的事件
-(void)keyboardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:0.2 animations:^(void){
        self.view.frame = CGRectMake(0, 64, 320, self.view.frame.size.height);
    }];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
