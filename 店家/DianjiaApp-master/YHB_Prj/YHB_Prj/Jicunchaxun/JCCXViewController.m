//
//  JCCXViewController.m
//  YHB_Prj
//
//  Created by  striveliu on 15/8/31.
//  Copyright (c) 2015年 striveliu. All rights reserved.
//

#import "JCCXViewController.h"
#import "JCCXManager.h"
#import "JCCXMode.h"
#import "JCCXCell.h"

@interface JCCXViewController ()
@property (strong, nonatomic) IBOutlet UIButton *weiquwanBT;
@property (strong, nonatomic) IBOutlet UIButton *yiquwanBT;
@property (strong, nonatomic) IBOutlet UIButton *shaixuanBT;
@property (strong, nonatomic) IBOutlet UITableView *tableiview;
@property (strong, nonatomic) JCCXManager *manager;
@property (strong, nonatomic) JCCXModeList *modeList;
@end

@implementation JCCXViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if(self=[super initWithNibName:nibNameOrNil bundle:nil])
    {
        self.hidesBottomBarWhenPushed = YES;
        self.manager = [[JCCXManager alloc] init];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.tableiview.dataSource = self;
    self.tableiview.delegate = self;
    [self.manager appGetProductStaySrl:1 finishBlock:^(JCCXModeList *list) {
        if(list)
        {
            self.modeList = list;
            [self.tableiview reloadData];
        }
    }];
    [self.shaixuanBT addTarget:self action:@selector(shuaixuanBTItem) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark 点击筛选按钮
- (void)shuaixuanBTItem
{
    [self pushXIBName:@"JCCXSXViewController" animated:YES selector:@"setJCCXManager:" param:self.manager,nil];
}

#pragma mark - UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 170.0f;
}
- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.modeList.modeList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JCCXCell *cell = [tableView dequeueReusableCellWithIdentifier:@"jccxcell"];
    if(!cell)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"JCCXCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [self configureCell:cell forRowAtIndexPath:indexPath];

    return cell;
}

- (void)configureCell:(JCCXCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row < self.modeList.modeList.count)
    {
        JCCXMode *mode = [self.modeList.modeList objectAtIndex:indexPath.row];
        [cell setCellData:mode];
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
