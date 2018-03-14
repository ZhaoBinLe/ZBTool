//
//  ImageTool.h
//  SystemFunction
//
//  Copyright (c) 2013年 qianfeng. All rights reserved.


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//可以压缩图片 或者 截屏
@interface ImageTool : NSObject

//返回单例的静态方法
+(ImageTool *)shareTool;

//返回特定尺寸的UImage  ,  image参数为原图片，size为要设定的图片大小
-(UIImage*)resizeImageToSize:(CGSize)size
                 sizeOfImage:(UIImage*)image;

//在指定的视图内进行截屏操作,返回截屏后的图片
-(UIImage *)imageWithScreenContentsInView:(UIView *)view;


/**
 获取Gif图片时长

 @param data 图片二进制数据
 @return 返回时长
 */
- (double)durationForGifData:(NSData *)data;

@end
