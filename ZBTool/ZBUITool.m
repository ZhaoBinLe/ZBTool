//
//  ZBUITool.m
//  ZBTool
//
//  Created by qmap01 on 17/2/28.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import "ZBUITool.h"

@implementation ZBUITool

//16进制颜色值
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}
+ (CGFloat)heightWithWidth:(CGFloat)width font:(CGFloat)font str:(NSString *)string {
    UIFont *fonts = [UIFont systemFontOfSize:font];
    CGSize size = CGSizeMake(width, MAXFLOAT);
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName ,nil];
    size =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.height;

}
+ (CGFloat)widthWithheight:(CGFloat)height font:(CGFloat)font str:(NSString *)string {
    UIFont *fonts = [UIFont systemFontOfSize:font];
    CGSize size = CGSizeMake(MAXFLOAT, height);
    NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:fonts,NSFontAttributeName ,nil];
    size =[string boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size.width;
}
@end
