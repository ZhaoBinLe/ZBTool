//
//  ZBUITool.h
//  ZBTool
//
//  Created by qmap01 on 17/2/28.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBUITool : NSObject
+(UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;
/// 获取UILabel高度
/// @param width UILabel.width
/// @param font UILabel.font
/// @param string Text
+ (CGFloat)heightWithWidth:(CGFloat)width font:(CGFloat)font str:(NSString *)string;

/// 获取UILabel宽度
/// @param height UILabel.height
/// @param font UILabel.font
/// @param string Text
+ (CGFloat)widthWithheight:(CGFloat)height font:(CGFloat)font str:(NSString *)string;


@end
