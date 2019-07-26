//
//  InputView.m
//  CopyObject
//
//  Created by tianlei on 2017/3/24.
//  Copyright © 2017年 QF-001. All rights reserved.
//

#import "InputView.h"
#import <objc/runtime.h>

#define kNomalColor  [UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]
#define kSelectColor [UIColor colorWithRed:0.35 green:0.53 blue:0.98 alpha:1.0]

@interface InputView ()<UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, assign) NSInteger index;

@end

@implementation InputView

- (instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 40);
        [self initData];
    }
    return self;
}

- (void)initData{
    CGFloat width = 30;
    CGFloat spacing = 10;
    _textFields = [NSMutableArray array];
    _index = 0;
    CGFloat leftSpacing = ([UIScreen mainScreen].bounds.size.width - 270.0)/2.0;
    for (int i = 0; i < 7; i ++) {
        CGRect frame = CGRectMake(leftSpacing + i*(width + spacing), 0, width, width);
        UITextField *textField = [self textFieldWithFrame:frame];
        if( 0 == i){
           // textField.layer.borderColor = kSelectColor.CGColor;
        }
        [_textFields addObject:textField];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    for (UITextField *t in _textFields) {
        [self addSubview:t];
    }
}


- (UITextField *)textFieldWithFrame:(CGRect )frame{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    [textField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    textField.layer.borderWidth = 1;
    textField.textAlignment = NSTextAlignmentCenter;
    textField.font = [UIFont systemFontOfSize:18];
    textField.layer.borderColor = kNomalColor.CGColor;
    textField.delegate = self;
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([textField class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(deleteBtn));
    method_exchangeImplementations(method1, method2);
    return textField;
}

- (void)textDidChange:(UITextField *)textField{

    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > 1) {
                textField.text = [toBeString substringToIndex:1];
            }
            [textField endEditing:YES];
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (textField.text.length > 1) {
            textField.text = [textField.text substringToIndex:1];
        }
        [textField endEditing:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    for (int i = 0; i < _textFields.count; i ++) {
        if (_textFields[i] == textField) {
            _index = i;
        }
    }
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (![textField.superview isKindOfClass:[InputView class]]) {
        _index ++;
        [self setTextFieldNomalColor];
        textField.layer.borderColor = kSelectColor.CGColor;
        return YES;
    }
    
    if (textField.text.length != 0) {
        if(_textFields[6] == textField){
            textField.layer.borderColor = kSelectColor.CGColor;
            return YES;
        }
        return NO;
    }
    int tempIndex = 0;
    for (UITextField *t in _textFields) {
        if (t != textField) {
            tempIndex ++;
        }else{
            break;
        }
    }
    for (int i = 0; i < tempIndex; i ++) {
        UITextField *t = _textFields[i];
        if (t.text.length == 0) {
            return NO;
        }
    }
    textField.layer.borderColor = kSelectColor.CGColor;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason{
    if (textField.text.length == 0) {
        if (_index == 0) {
            [_textFields.firstObject becomeFirstResponder];
        }else{
            _index --;
            UITextField *t = _textFields[_index];
            [self setTextFieldNomalColor];
            [t becomeFirstResponder];
        }
    }else{
        if (_index != 6) {
            _index ++;
            UITextField *t = _textFields[_index];
            [self setTextFieldNomalColor];
            [t becomeFirstResponder];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        BOOL isShow = NO;
        for (UITextField *t in _textFields) {
            if(t.isFirstResponder){
                isShow = YES;
            }
        }
        if (!isShow) {
            [self setTextFieldNomalColor];
        }
    });
}

- (void)deleteBtn{
    UITextField *textField = (UITextField *)self;
    if(![self.superview isKindOfClass:[InputView class]]){
        if (textField.text.length > 0) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
        return;
    }
    InputView *inputView = (InputView *)textField.superview;
    NSArray *textFields = [inputView valueForKey:@"textFields"];
    
    if (textField.text.length == 0) {
        if (inputView.index > 0) {
            UITextField *t = textFields[inputView.index-1];
            t.text = @"";
            [t becomeFirstResponder];
        }
        return;
    }
    
    if (inputView.index == 6) {
        textField.text = @"";
        return;
    }
}

- (void)setTextFieldNomalColor{
    for (int i = 0; i < 7; i ++) {
        UITextField *textField = _textFields[i];
        textField.layer.borderColor = kNomalColor.CGColor;
    }
}

- (NSString *)text{
    NSString *text = @"";
    for (UITextField *textField in _textFields) {
        text = [NSString stringWithFormat:@"%@%@", text, textField.text];
    }
    return text;
}
@end
