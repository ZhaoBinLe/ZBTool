//
//  ZBMathTool.m
//  ZBTool
//
//  Created by qmap01 on 17/2/28.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import "ZBMathTool.h"
@implementation ZBMathTool
+ (NSInteger)maxCommonDivisor:(NSInteger)numA :(NSInteger)numB {
    
    NSInteger max = numA;
    while (numB%max || numA%max) {
        max--;
    }
    return max;
}
+ (NSInteger)minCommonMultiple:(NSInteger)numA :(NSInteger)numB {
    NSInteger min = numA;
    while (min%numB) {
        min+=numA;
    }
    return min;
}
+ (NSString *)fixStrToTime:(NSString *)dataStr {
    NSRange range1 =[dataStr rangeOfString:@"("];
    NSRange range2 =[dataStr rangeOfString:@")"];
    if (range1.location == NSNotFound ||range2.location == NSNotFound ) {
        return @"";
    }
    NSString *subStr = [dataStr substringWithRange:NSMakeRange(range1.location+1, range2.location-range1.location)];
    NSString *timeStr= [[NSString alloc]init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init ];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init ];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    
    NSTimeZone *timezone=[NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timezone];
    [formatter1 setTimeZone:timezone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[subStr doubleValue]/1000];
    timeStr = [formatter stringFromDate:confromTimesp];
    NSString *time = [formatter1 stringFromDate:confromTimesp];
    if ([time isEqualToString:@"1970-01-01"]) {
        return @"";
    }
    return timeStr;
}
@end
