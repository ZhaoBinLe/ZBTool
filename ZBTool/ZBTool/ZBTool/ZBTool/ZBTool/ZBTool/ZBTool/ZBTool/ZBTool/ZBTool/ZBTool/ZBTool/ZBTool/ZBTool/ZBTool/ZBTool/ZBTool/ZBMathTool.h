//
//  ZBMathTool.h
//  ZBTool
//
//  Created by qmap01 on 17/2/28.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBMathTool : NSObject

/**
 计算最大公约数

 @param numA num
 @param numB num
 @return 最大公约数
 */
+ (NSInteger)maxCommonDivisor:(NSInteger)numA :(NSInteger)numB;

/**
 计算最小公倍数

 @param numA num
 @param numB num
 @return 最小公倍数
 */
+ (NSInteger)minCommonMultiple:(NSInteger)numA :(NSInteger)numB;

/**
 时间格式化：Date(1485054526180)

 @param dataStr 字符串
 @return 时间
 */
+ (NSString *)fixStrToTime:(NSString *)dataStr;
@end
