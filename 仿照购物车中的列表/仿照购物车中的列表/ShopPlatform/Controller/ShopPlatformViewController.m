//
//  ShopPlatformViewController.m
//  电商
//
//  Created by zhou on 16/8/9.
//  Copyright © 2016年 zhou. All rights reserved.
//shopPlatform

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "ShopPlatformViewController.h"
#import "ShopPlatformTableViewCell.h"
#import "ShopPlatformModel.h"

@interface ShopPlatformViewController ()<UITableViewDelegate,UITableViewDataSource,shopPlatformTableViewCellDelegate>
/** tableView */
@property (weak, nonatomic) IBOutlet UITableView *tableView;
/** 总价格 */
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
/** 全选按钮 */
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;
/** 存储数据 */
@property (nonatomic, strong) NSMutableArray *shopPlatformArray;
/** 判断选中商品的种类个数 */
@property (nonatomic,assign) NSInteger count;
/** tableView的内容的高度 */
//@property (nonatomic,assign) CGFloat tableViewContentSizeHeight;

/** 存储调出键盘的textfield的tag */
@property (nonatomic,assign) NSInteger textfieldTag;

@end

@implementation ShopPlatformViewController

- (NSMutableArray *)shopPlatformArray
{
    if (_shopPlatformArray == nil) {
        _shopPlatformArray = [NSMutableArray array];
    }
    return _shopPlatformArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"购物平台";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //默认选中的
    self.count = 0;
    
    //选中和不选中的图片
    [self.allSelectBtn setImage:[[UIImage imageNamed:@"yy_select_disabled"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [self.allSelectBtn setImage:[[UIImage imageNamed:@"yy_select_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
    
    //给数据
    for (int i = 0; i < 4; i++) {
        ShopPlatformModel *model = [[ShopPlatformModel alloc] init];
        model.isSelect = NO;
        model.presentprice = i+1;
        model.totalnumber = 1;
        [self.shopPlatformArray addObject:model];
        
    }
    
    [self.tableView reloadData];
    

    // 监听键盘的位置改变
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    // 监听键盘的通知
    [center addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}
/**
 *  是哪个textfield弹出的键盘，来确定所在cell的位置高度，是否需要移动tableview
 */
- (void)textfieldBeginEditingTableViewCell:(ShopPlatformTableViewCell *)cell andTextfieldTag:(NSInteger)tag
{
    self.textfieldTag = tag;
}
/**
 *  弹出和隐藏键盘的通知方法
 */
- (void)keyboardWillChangeFrame:(NSNotification *)note
{
    // 拿到键盘弹出或隐藏后的frame
    CGRect keyboardFrame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //90是每个cell的高度  cellYH是self.textfieldTag所在cell的y值加上cell的高度，也就是几个cell的高度相加
    CGFloat cellYH = 90 * (self.textfieldTag + 1);
    
    CGFloat surplus = ScreenHeight - 64 - cellYH;
    
//    NSLog(@"ScreenHeight == %lf,cellYH==%lf,surplus == %lf",ScreenHeight,cellYH,surplus);
    
    if (keyboardFrame.origin.y < ScreenHeight) {//键盘弹出
        
        if (surplus > keyboardFrame.size.height) {//不用移动
            
        }else{
            
            CGFloat keyboardH = keyboardFrame.size.height;
            
            CGFloat cha = keyboardH - surplus;
            
            self.view.transform = CGAffineTransformMakeTranslation(0, -cha);
            
        }

    }else{//键盘隐藏
        self.view.transform = CGAffineTransformIdentity;
    }
}


//控制器销毁之前移除键盘的通知
- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
# pragma mark tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.shopPlatformArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ShopPlatformTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shopPlatform"];
    
    cell.indexpath = indexPath;
    
    cell.data = self.shopPlatformArray[indexPath.row];

    cell.delegate = self;
    
    
    return cell;
}
/**
 *  滑动删除
 */
- (NSArray<UITableViewRowAction *> *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction * _Nonnull action, NSIndexPath * _Nonnull indexPath) {
        
        
        ShopPlatformModel *model = self.shopPlatformArray[indexPath.row];
        if (model.isSelect) {//在选中
            
            NSString *money = [self.totalPriceLabel.text substringFromIndex:1];
            NSInteger intMoney = money.integerValue;
            NSInteger surplus = intMoney - model.presentprice * model.totalnumber;
            //重新给总价赋值
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %ld",surplus];
            //要把选中商品的个数减一
            self.count--;
        }
        
        //移除掉这个数据
        [self.shopPlatformArray removeObjectAtIndex:indexPath.row];
        
//        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //要刷新全部的数据，因为数据中的数据tag跟cell的位置有关，需要重新给每个控件的tag赋值
        [self.tableView reloadData];
        
    }];
    
    return @[deleteRowAction];
}
/**
 *  shopPlatformTableViewCellDelegate的代理方法，是否选中商品,不对
 */
- (void)shopPlatformTableViewCell:(ShopPlatformTableViewCell *)cell andTag:(NSInteger)tag
{
    //在键盘弹出的时候，要先退出键盘
    [self.view endEditing:YES];
    
    ShopPlatformModel *model = self.shopPlatformArray[tag];
    //取消选中
    if (model.isSelect) {
        model.isSelect = NO;
        //substringFromIndex:
        NSString *money = [self.totalPriceLabel.text substringFromIndex:1];
        NSInteger intMoney = money.integerValue;
        NSInteger surplus = intMoney - model.presentprice * model.totalnumber;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %ld",surplus];
        self.count--;
    }else//选中
    {
        model.isSelect = YES;

        NSString *money = [self.totalPriceLabel.text substringFromIndex:1];
        NSInteger intMoney = money.integerValue;
        NSInteger surplus = intMoney + model.presentprice * model.totalnumber;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %ld",surplus];
        self.count++;
    }
    //replaceObjectAtIndex:方
    //更新数据
    [self.shopPlatformArray replaceObjectAtIndex:tag withObject:model];
    //刷新数据
//    [self.tableView reloadData];
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:tag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    
    //判断选中的个数，如果选中的个数是dataArray的个数，代表全选
    if (self.count == self.shopPlatformArray.count) {
        self.allSelectBtn.selected = YES;
    }else{
        self.allSelectBtn.selected = NO;
    }

}
/**
 *  当输入数量的时候，从一个numberTextfield跳到另一个numberTextfield的时候，要计算被选中的商品的价格的总数
 */
- (void)textfieldTextdidChangeTableViewCell:(ShopPlatformTableViewCell *)cell andTextField:(UITextField *)textfield andIdexpath:(NSIndexPath *)indexpath
{
    
    ShopPlatformModel *model = self.shopPlatformArray[indexpath.row];
    if (model.isSelect)//判断你要离开的numberTextfield是否被选中，这是选中
    {
        self.totalPriceLabel.text = @"0";//总价格赋值为0
        NSInteger totalMoney = 0;//保存其他的被选中的商品的总价格
        for (int i = 0; i < self.shopPlatformArray.count; i++)
        {//遍历一下所有的数据
            
            if (i == indexpath.row)//如果遍历到你要离开的numberTextfield的位置，跳过
            {
//                continue;
            }else//这是其他的数据
            {
                
                ShopPlatformModel *shopModel = self.shopPlatformArray[i];
                if (shopModel.isSelect)//其他的数据，只计算被选中的商品的价格
                {
                    totalMoney = totalMoney + shopModel.presentprice * shopModel.totalnumber;
                }
                
            }
            
        }
        
        //要离开的numberTextfield的价格
        NSInteger oneMoney = model.presentprice * model.totalnumber;
        
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %ld",totalMoney + oneMoney];//所有的总价格
        
    }
}
/**
 *  减数量
 */
- (IBAction)reduceClick:(UIButton *)sender {
    //在键盘弹出的时候，要先退出键盘
    [self.view endEditing:YES];
    
    ShopPlatformModel *model = self.shopPlatformArray[sender.tag];
    //判断商品的个数>1的时候，才会减1
    if (model.totalnumber > 1) {
        model.totalnumber--;
        [self.shopPlatformArray replaceObjectAtIndex:sender.tag withObject:model];
        
    }else
    {
        //阻止在数量为1的时候，下面的代码不会再次执行
        return;
    }
    //刷新减后的数量的数据
//    [self.tableView reloadData];
    NSIndexPath *indepath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indepath] withRowAnimation:UITableViewRowAnimationNone];
    
    //判断如果这个商品在选中的时候，要更新总价格
    if (model.isSelect) {
        //选中总价格的更新

        NSString *money = [self.totalPriceLabel.text substringFromIndex:1];
        NSInteger intMoney = money.integerValue;
        NSInteger surplus = intMoney - model.presentprice;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %ld",surplus];
        
    }
    

}
/**
 *  加数量
 */
- (IBAction)addClick:(UIButton *)sender {
    //在键盘弹出的时候，要先退出键盘
    [self.view endEditing:YES];
    
    //加数量
    ShopPlatformModel *model = self.shopPlatformArray[sender.tag];
    model.totalnumber++;
    [self.shopPlatformArray replaceObjectAtIndex:sender.tag withObject:model];
    //更新加的数量的数据
//    [self.tableView reloadData];
    NSIndexPath *indepath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[indepath] withRowAnimation:UITableViewRowAnimationNone];
    
    //判断如果这个商品在选中的时候，要更新总价格
    if (model.isSelect) {

        NSString *money = [self.totalPriceLabel.text substringFromIndex:1];
        NSInteger intMoney = money.integerValue;
        NSInteger surplus = intMoney + model.presentprice;
        self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %ld",surplus];
    }

}

/**
 *  全选中按钮
 */
- (IBAction)allSelectClick:(UIButton *)sender {
    
    //先把总价格赋值为 0
    self.totalPriceLabel.text = @"¥ 0";
    
    //如果在选中的状态，再次点击为不是选中的状态
    if (self.allSelectBtn.selected) {
        //不在选中的状态，商品全部不选中
        self.allSelectBtn.selected = NO;
        for (int i = 0; i < self.shopPlatformArray.count; i++) {
            ShopPlatformModel *model = self.shopPlatformArray[i];
            model.isSelect = NO;
            
            [self.shopPlatformArray replaceObjectAtIndex:i withObject:model];
            
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ 0"];
            
            
        }
        //如果商品全部不选中，选中商品的个数为 0
        self.count = 0;
        
    }else{//如果不在选中的状态，再次点击的时候，为选中的状态
        
        //在选中的状态，商品全部选中
        self.allSelectBtn.selected = YES;
        for (int i = 0; i < self.shopPlatformArray.count; i++) {
            ShopPlatformModel *model = self.shopPlatformArray[i];
            model.isSelect = YES;
            
            [self.shopPlatformArray replaceObjectAtIndex:i withObject:model];
            
            NSString *money = [self.totalPriceLabel.text substringFromIndex:1];
            NSInteger intMoney = money.integerValue;
            NSInteger surplus = intMoney + model.presentprice * model.totalnumber;
            self.totalPriceLabel.text = [NSString stringWithFormat:@"¥ %ld",surplus];
        }
        //如果商品全部选中，选中商品的个数为 dataArray的个数
        self.count = self.shopPlatformArray.count;
    }
    
    
    //刷新数据
    [self.tableView reloadData];
}


@end
