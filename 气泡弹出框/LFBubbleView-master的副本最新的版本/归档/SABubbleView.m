//
//  SABubbleView.m
//  SAKitDemo
//
//  Created by 李磊 on 26/6/17.
//  Copyright © 2017年 浙江网仓科技有限公司. All rights reserved.
//

#import "SABubbleView.h"
#import "SAKitConstant.h"
@interface SABubbleView () <UIGestureRecognizerDelegate, UITableViewDelegate,UITableViewDataSource>

/** 点击蒙层的时候，是否使弹出框消失 */
@property (nonatomic,assign) BOOL dismissWhenClickMaskView;

/**是否需要蒙层，默认有*/
@property (nonatomic,assign) BOOL haveMaskView;

/**  我知道了 按钮 */
@property (nonatomic, strong) UIButton * sureButton;

/**蒙层透明度，默认是0.3*/
@property (nonatomic,assign) CGFloat maskAlpha;

/**蒙层*/
@property (nonatomic,strong) UIView *maskView;

/** 三角形边长，默认是10 */
@property (nonatomic,assign) CGFloat triangleSide;

/** 弹出框圆角，默认是5. */
@property (nonatomic,assign) CGFloat cornerRadius;

/** 弹出框背景颜色，默认是白  */
@property (nonatomic,strong) UIColor *popupBackgroundColor;

@property (nonatomic, strong) UITableView *tabelView;
@end

@implementation SABubbleView

#pragma mark-
#pragma mark- View Life Cycle

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self addInitMethods];
    }
    return self;
}

- (instancetype)initWithTrianglePoint:(CGPoint)point size:(CGSize)size{
   
    self.trianglePoint = point;
    self = [super initWithFrame:CGRectMake(point.x - size.width/2.0, point.y, size.width, size.height)];
    [self addInitMethods];
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    switch (self.triangleDicrection) {
        case SATriangleDicrectionUp:{
            self.frame = CGRectMake(self.trianglePoint.x - self.triangleSeatScale*self.frame.size.width, self.trianglePoint.y, self.frame.size.width, self.frame.size.height);
            
            self.realView.frame = CGRectMake(self.realView.frame.origin.x, self.realView.frame.origin.y+self.triangleSide*2*cos(M_PI/3), self.realView.frame.size.width, self.realView.frame.size.height-self.triangleSide*2*cos(M_PI/3));
        }
            break;
        case SATriangleDicrectionDown:{
            self.frame = CGRectMake(self.trianglePoint.x - self.triangleSeatScale*self.frame.size.width, self.trianglePoint.y-self.frame.size.height, self.frame.size.width, self.frame.size.height);
            
            self.realView.frame = CGRectMake(self.realView.frame.origin.x, self.realView.frame.origin.y, self.realView.frame.size.width, self.realView.frame.size.height-self.triangleSide*2*cos(M_PI/3));
        }
            break;
        case SATriangleDicrectionLeft:{
            self.frame = CGRectMake(self.trianglePoint.x, self.trianglePoint.y-self.triangleSeatScale*self.frame.size.height, self.frame.size.width, self.frame.size.height);
            
            self.realView.frame = CGRectMake(self.realView.frame.origin.x+self.triangleSide*2*cos(M_PI/3), self.realView.frame.origin.y, self.realView.frame.size.width-self.triangleSide*2*cos(M_PI/3), self.realView.frame.size.height);
        }
            break;
        case SATriangleDicrectionRight:{
            self.frame = CGRectMake(self.trianglePoint.x-self.frame.size.width, self.trianglePoint.y-self.triangleSeatScale*self.frame.size.height, self.frame.size.width, self.frame.size.height);
            
            self.realView.frame = CGRectMake(0, 0, self.realView.frame.size.width-self.triangleSide*2*cos(M_PI/3) , self.realView.frame.size.height);
        }
            break;
        default:
            break;
    }
    
    switch (self.bubbleViewType) {
        case SABubbleTypeNormal:{
            CGSize titleSize = [self.textLabel.text boundingRectWithSize:CGSizeMake(150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            NSLog(@"frameSize---%f",titleSize.height);
            CGRect rect = self.frame;
            rect.size.width = 180;
            rect.size.height = titleSize.height;
            if (self.triangleDicrection == SATriangleDicrectionDown ||
                self.triangleDicrection == SATriangleDicrectionUp) {
                rect.size.height = titleSize.height + 40;
                self.frame = rect;
                self.textLabel.frame = CGRectMake(15, 15, self.frame.size.width - 30 , self.frame.size.height - 40);
            }else{
                rect.size.height = titleSize.height + 30;
                self.frame = rect;
                self.textLabel.frame = CGRectMake(15, 15, self.frame.size.width - 40 , self.frame.size.height - 30);
            }

        }
            break;
        case SABubbleTypeButton:{
            CGSize titleSize = [self.textLabel.text boundingRectWithSize:CGSizeMake(150, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size;
            NSLog(@"frameSize---%f",titleSize.height);
            CGRect rect = self.frame;
            rect.size.width = 180;
            rect.size.height = titleSize.height;
            if (self.triangleDicrection == SATriangleDicrectionDown ||
                self.triangleDicrection == SATriangleDicrectionUp) {
                rect.size.height = titleSize.height + 40 + 40;
                self.frame = rect;
                self.textLabel.frame = CGRectMake(15, 15, self.frame.size.width - 30 , self.frame.size.height - 80);
                self.sureButton.frame = CGRectMake(15, titleSize.height + 15, self.frame.size.width - 30 , 40);
            }else{
                rect.size.height = titleSize.height + 30 + 30;
                self.frame = rect;
                self.textLabel.frame = CGRectMake(15, 15, self.frame.size.width - 40 , self.frame.size.height - 80);
                self.sureButton.frame = CGRectMake(15, titleSize.height + 15, self.frame.size.width - 40, 30);
            }

        }
            break;
        case SABubbleTypeView:{
            CGRect rect = self.frame;
            rect.size.height = self.dataSourceArray.count * self.tabelView.rowHeight + 30;
            rect.size.width = 120;
            self.frame = rect;
            self.tabelView.frame = CGRectMake(5, 5, self.frame.size.width -10 , self.frame.size.height -10);
        }
            break;
        default:
            break;
    }
    
}

#pragma mark - drawRect
- (void)drawRect:(CGRect)rect {
    
    // 设置背景色
    [self.realView.backgroundColor set];
    //拿到当前视图准备好的画板
    
    CGContextRef  context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    
    CGPoint startPoint;
    CGPoint middlePoint;
    CGPoint endPoint;
    
    
    switch (self.triangleDicrection) {
        case SATriangleDicrectionUp:

            
            startPoint  = CGPointMake(self.triangleSeatScale*self.frame.size.width-self.triangleSide, self.triangleSide*2*cos(M_PI/3));
            middlePoint = CGPointMake(self.triangleSeatScale*self.frame.size.width,0);
            endPoint    = CGPointMake(self.triangleSeatScale*self.frame.size.width+self.triangleSide,self.triangleSide*2*cos(M_PI/3));
            
            break;
        case SATriangleDicrectionLeft:

            startPoint  = CGPointMake(self.triangleSide*2*cos(M_PI/3), self.triangleSeatScale*self.frame.size.height-self.triangleSide);
            middlePoint = CGPointMake(self.triangleSide*2*cos(M_PI/3), self.triangleSeatScale*self.frame.size.height+self.triangleSide);
            endPoint    = CGPointMake(0,self.triangleSeatScale*self.frame.size.height);
            
            break;
        case SATriangleDicrectionDown:
            
            startPoint  = CGPointMake(self.triangleSeatScale*self.frame.size.width-self.triangleSide,self.frame.size.height-self.triangleSide*2*cos(M_PI/3));
            middlePoint = CGPointMake(self.triangleSeatScale*self.frame.size.width, self.frame.size.height);
            endPoint    = CGPointMake(self.triangleSeatScale*self.frame.size.width+self.triangleSide, self.frame.size.height-self.triangleSide*2*cos(M_PI/3));
            
            break;
        case SATriangleDicrectionRight:

            startPoint  = CGPointMake(self.frame.size.width-self.triangleSide*2*cos(M_PI/3), self.triangleSeatScale*self.frame.size.height-self.triangleSide);
            middlePoint = CGPointMake(self.frame.size.width, self.triangleSeatScale*self.frame.size.height);
            endPoint    = CGPointMake(self.frame.size.width-self.triangleSide*2*cos(M_PI/3),self.triangleSeatScale*self.frame.size.height+self.triangleSide);
            
            break;
        default:
            return;
    }
    
    CGContextMoveToPoint(context, startPoint. x, startPoint. y);
    CGContextAddLineToPoint(context, middlePoint. x, middlePoint. y);
    CGContextAddLineToPoint(context, endPoint. x, endPoint. y);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    CGContextClosePath(context);
}


#pragma mark-
#pragma mark - UIGestureRecognizerDelegate
//* 解决gestureRecognizerTap点击手势和tableView cell点击手势的冲突 *
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return YES;
}

#pragma mark-
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = self.dataSourceArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击的是----%ld",(long)indexPath.row);
    [self dismiss];
}



#pragma mark-
#pragma mark- Event response

- (void)addInitMethods {
    self.backgroundColor = [UIColor whiteColor];
    self.cornerRadius = 5.f;
    self.triangleSide = 10.f;
    self.triangleSeatScale = 0.5f;
    self.triangleDicrection = SATriangleDicrectionUp;
    self.bubbleViewType = SABubbleTypeNormal;
    self.trianglePoint = CGPointMake(self.frame.origin.x+self.frame.size.width/2.0, self.frame.origin.y);
    
    self.popupBackgroundColor = [UIColor blueColor];
    
    self.dismissWhenClickMaskView = YES;
    self.haveMaskView = YES;
    
    self.maskAlpha = 0.3;
    [self addSubview:self.realView];
    [self.realView addSubview:self.textLabel];
    [self.realView addSubview:self.sureButton];
    [self.realView addSubview:self.tabelView];
    
    
}

- (void)pressSureButtonAction:(UIButton *)sender{
    NSLog(@"点了我知道按钮");
}

- (void)pressMaskViewAction{
    if (!self.dismissWhenClickMaskView) {
        return;
    }
    [self dismiss];
}


- (void)show:(UIView *)maskSuperView{
    if (!self.haveMaskView) {
        [maskSuperView addSubview:self];
        return;
    }
    
    self.maskView.frame = maskSuperView.bounds;
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.backgroundColor = [UIColor colorWithWhite:0 alpha:self.maskAlpha];
    }];
    
    [self.maskView addSubview:self];
    
}

- (void)dismiss{
    [self removeFromSuperview];
    [UIView animateWithDuration:0.3f animations:^{
        self.maskView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        [self.maskView removeFromSuperview];
    }];
}

#pragma mark-
#pragma mark- Private Methods


#pragma mark-
#pragma mark- Getters && Setters

- (UIView *)realView{
    if (!_realView) {
        _realView = [[UIView alloc]init];
        _realView.clipsToBounds = YES;
        _realView.layer.cornerRadius = self.cornerRadius;
        _realView.backgroundColor = [UIColor sa_colorC1];
        _realView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }
    return _realView;
}

- (UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pressMaskViewAction)];
        [_maskView addGestureRecognizer:tap];
        _maskView.userInteractionEnabled = YES;
        tap.delegate = self;
    }
    return _maskView;
}

- (UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont sa_fontS7:SAFontBoldTypeB1];
        _textLabel.textColor = [UIColor sa_colorC5];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.numberOfLines = 0;
        _textLabel.backgroundColor = [UIColor redColor];
    }
    return _textLabel;
}

- (UIButton *)sureButton{
    if (!_sureButton) {
        _sureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureButton setTitle:@"我知道了" forState:UIControlStateNormal];
        _sureButton.titleLabel.font = [UIFont sa_fontS7:SAFontBoldTypeB1];
        _sureButton.titleLabel.textColor = [UIColor sa_colorC5];
        _sureButton.titleLabel.alpha = 0.6;
        [_sureButton addTarget:self action:@selector(pressSureButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureButton;
}

- (UITableView *)tabelView{
    if (!_tabelView) {
        _tabelView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tabelView.backgroundColor = [UIColor clearColor];
        _tabelView.rowHeight = 44;
        _tabelView.dataSource = self;
        _tabelView.delegate = self;
        _tabelView.tableFooterView = [[UIView alloc]init];
        [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    
    return _tabelView;
}

#pragma mark-
#pragma mark-
//SetupConstraints - (void)setupSubviewsContraints { <#配置视图约束#> }



@end
