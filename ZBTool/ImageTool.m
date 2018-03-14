//
//  ImageTool.m
//  SystemFunction
//
//  Copyright (c) 2013年 qianfeng. All rights reserved.
//

#import "ImageTool.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageTool

static ImageTool *_shareImageTool =nil;
//返回单例的静态方法
+(ImageTool *)shareTool
{
    //确保线程安全
    @synchronized(self){
        //确保只返回一个实例
        if (_shareImageTool == nil) {
            _shareImageTool = [[ImageTool alloc] init];
        }
    }
    return _shareImageTool;
}

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

//在指定的视图内进行截屏操作,返回截屏后的图片
-(UIImage *)imageWithScreenContentsInView:(UIView *)view
{
    //根据屏幕大小，获取上下文
    UIGraphicsBeginImageContext([[UIScreen mainScreen] bounds].size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return viewImage;
}


-(UIImage*)resizeImageToSize:(CGSize)size
                 sizeOfImage:(UIImage*)image
{

    UIGraphicsBeginImageContext(size);
    //获取上下文内容
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //重绘image
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    //根据指定的size大小得到新的image
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}
- (double)durationForGifData:(NSData *)data{
    //将GIF图片转换成对应的图片源
    CGImageSourceRef gifSource = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    //获取其中图片源个数，即由多少帧图片组成
    size_t frameCout = CGImageSourceGetCount(gifSource);
    //定义数组存储拆分出来的图片
    NSMutableArray* frames = [[NSMutableArray alloc] init];
    NSTimeInterval totalDuration = 0;
    for (size_t i=0; i<frameCout; i++) {
        //从GIF图片中取出源图片
        CGImageRef imageRef = CGImageSourceCreateImageAtIndex(gifSource, i, NULL);
        //将图片源转换成UIimageView能使用的图片源
        UIImage* imageName = [UIImage imageWithCGImage:imageRef];
        //将图片加入数组中
        [frames addObject:imageName];
        double duration = [self gifImageDeleyTime:gifSource index:i];
        totalDuration += duration;
        CGImageRelease(imageRef);
    }
    
    //获取循环次数
    NSInteger loopCount;//循环次数
    CFDictionaryRef properties = CGImageSourceCopyProperties(gifSource, NULL);
    if (properties) {
        CFDictionaryRef gif = CFDictionaryGetValue(properties, kCGImagePropertyGIFDictionary);
        if (gif) {
            CFTypeRef loop = CFDictionaryGetValue(gif, kCGImagePropertyGIFLoopCount);
            if (loop) {
                //如果loop == NULL，表示不循环播放，当loopCount  == 0时，表示无限循环；
                CFNumberGetValue(loop, kCFNumberNSIntegerType, &loopCount);
            };
        }
    }
    
    CFRelease(gifSource);
    return totalDuration;
}
- (double)gifImageDeleyTime:(CGImageSourceRef)imageSource index:(NSInteger)index {
    float frameDuration = 0.1f;
    CFDictionaryRef cfFrameProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, index, nil);
    NSDictionary *frameProperties = (__bridge NSDictionary *)cfFrameProperties;
    NSDictionary *gifProperties = frameProperties[(NSString *)kCGImagePropertyGIFDictionary];
    
    NSNumber *delayTimeUnclampedProp = gifProperties[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
    if (delayTimeUnclampedProp) {
        frameDuration = [delayTimeUnclampedProp floatValue];
    } else {
        NSNumber *delayTimeProp = gifProperties[(NSString *)kCGImagePropertyGIFDelayTime];
        if (delayTimeProp) {
            frameDuration = [delayTimeProp floatValue];
        }
    }
    
    
    if (frameDuration < 0.011f) {
        frameDuration = 0.100f;
    }
    
    CFRelease(cfFrameProperties);
    return frameDuration;
    
}
@end
