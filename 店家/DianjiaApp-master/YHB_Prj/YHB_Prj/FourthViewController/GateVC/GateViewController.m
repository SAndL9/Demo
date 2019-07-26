//
//  GateViewController.m
//  YHB_Prj
//
//  Created by Johnny's on 15/8/25.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "GateViewController.h"
#import "GateTableViewCell.h"
#import "GateHeaderView.h"
#import "GateDetailViewController.h"
#import "LoginManager.h"

@interface GateViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_gateTableView;
}
@property(nonatomic, strong) NSArray *gateArr;
@end

@implementation GateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"门店管理";
    
    LoginMode *myMode = [[LoginManager shareLoginManager] getLoginMode];
    _gateArr = myMode.storeList;
    
    _gateTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, kMainScreenHeight-64) style:UITableViewStyleGrouped];
    _gateTableView.backgroundColor = [UIColor whiteColor];
    _gateTableView.delegate = self;
    _gateTableView.dataSource = self;
    _gateTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_gateTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _gateArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [GateHeaderView HeightForGateHeaderView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GateTableViewCell heightForGateCell];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kMainScreenWidth, 0.5)];
    footLineView.backgroundColor = RGBCOLOR(220, 220, 220);
    return footLineView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    static NSString *headerId = @"header";
    GateHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerId];
    if (!headerView)
    {
        headerView = [[GateHeaderView alloc] initWithReuseIdentifier:headerId];
    }
    StoreMode *mode = _gateArr[section];
    [headerView setTitle:mode.strStoreName];
    
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"GateCell";
    GateTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"GateTableViewCell" bundle:nil] forCellReuseIdentifier:cellId];
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(GateTableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    StoreMode *mode = _gateArr[indexPath.row];
    [cell setCellWithMode:mode];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
//    NSLog(@"%ld", indexPath.section);
    StoreMode *mode = _gateArr[indexPath.section];
    GateDetailViewController *vc = [[GateDetailViewController alloc] initWithMode:mode];
    [self.navigationController pushViewController:vc animated:YES];
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
