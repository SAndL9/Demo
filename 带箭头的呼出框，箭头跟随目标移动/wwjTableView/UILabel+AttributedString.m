//
//  UILabel+AttributedString.m
//  My Tool
//
//  Created by 吴伟军 on 16/7/4.
//  Copyright © 2016年 吴伟军. All rights reserved.
//

#import "UILabel+AttributedString.h"
#import <objc/runtime.h>
NSString const *timeTextKey     = @"timeTextKey";
NSString const *verticalTextKey = @"verticalTextKey";

@implementation UILabel (AttributedString)
- (void)setTypewithString:(NSString *)string withColor:(UIColor *)color backgroundColor:(UIColor *)backgroundColor withFont:(UIFont *)font withRangeIndex:(NSInteger)theRange withLenth:(NSInteger)theLength{
    if (string.length < theRange + theLength) {
        self.text = string;
    }
    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:string];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(theRange, theLength)];
    [str addAttribute:NSFontAttributeName value:font range:NSMakeRange(theRange, theLength)];
    [str addAttribute:NSBackgroundColorAttributeName value:backgroundColor range:NSMakeRange(theRange, theLength)];
    self.attributedText = str;
}

- (CGFloat)timeText{
    NSNumber *number = objc_getAssociatedObject(self, &timeTextKey);
    return number.floatValue;
}

- (void)setTimeText:(CGFloat)timeText{
    NSNumber *number = [NSNumber numberWithDouble:timeText];
    objc_setAssociatedObject(self, &timeTextKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    CGFloat time = [number floatValue];
    NSDate *sendDate = [[NSDate alloc] initWithTimeIntervalSince1970:time / 1000.0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm"];
    //[dateFormatter setDateStyle:(NSDateFormatterMediumStyle)];
    NSString *locationString = [dateFormatter stringFromDate:sendDate];
    self.text = locationString;
}

- (NSString *)verticalText{
    return objc_getAssociatedObject(self, &verticalTextKey);
}

- (void)setVerticalText:(NSString *)verticalText{
    objc_setAssociatedObject(self, &verticalTextKey, verticalText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    NSMutableString *str = [[NSMutableString alloc] initWithString:verticalText];
    NSInteger count = str.length;
    for (int i = 1; i < count; i ++) {
        [str insertString:@"\n" atIndex:i*2-1];
    }
    self.text = str;
    self.numberOfLines = 0;
}

- (void)setLabelTextWithLeftImage:(UIImage *)image andTitle:(NSString *)title{
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, -6, image.size.width, image.size.height);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, title.length)];
    NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attrStr insertAttributedString:att atIndex:0];
    self.attributedText = attrStr;
}

- (void)setLabelTextWithRightImage:(UIImage *)image andTitle:(NSString *)title{
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc]init];
    textAttachment.image = image;
    textAttachment.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:title];
    [attrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17.0] range:NSMakeRange(0, title.length)];
    NSAttributedString *att = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attrStr insertAttributedString:att atIndex:title.length];
    self.attributedText = attrStr;
}


@end
