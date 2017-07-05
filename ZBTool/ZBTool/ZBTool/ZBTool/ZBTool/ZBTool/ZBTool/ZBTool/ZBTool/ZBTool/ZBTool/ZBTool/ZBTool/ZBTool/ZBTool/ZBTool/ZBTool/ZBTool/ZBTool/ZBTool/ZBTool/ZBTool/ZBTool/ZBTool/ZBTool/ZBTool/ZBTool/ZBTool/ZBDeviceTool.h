//
//  ZBDeviceTool.h
//  ZBTool
//
//  Created by qmap01 on 17/2/28.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBDeviceTool : NSObject
+(ZBDeviceTool *)shareSingleton;
//1.获取电池电量
+(CGFloat)getBatteryQuantity;
//2.获取电池状态
+(UIDeviceBatteryState)getBatteryStauts;
//3.获取总内存大小
+(long long)getTotalMemorySize;
//4.获取当前可用内存
+(long long)getAvailableMemorySize;
//5.获取已使用内存
+ (double)getUsedMemory;
//6.容量转换
+(NSString *)fileSizeToString:(unsigned long long)fileSize;
//7.获取设备型号
+ (NSString *)getCurrentDeviceModel;

@end
