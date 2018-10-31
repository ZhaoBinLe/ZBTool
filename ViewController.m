//
//  ViewController.m
//  ZBTool
//
//  Created by qmap01 on 17/2/28.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import "ViewController.h"
#import "ZBLoadingView.h"
#import "ZBDeviceTool.h"
#import "ZBPathTool.h"
#import "NSArray+SplitAry.h"
#import "ImageTool.h"
#import "ZBMathTool.h"
#import <WebKit/WebKit.h>
@interface ViewController ()
@property (nonatomic,strong) ZBLoadingView *zbloadView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    NSNotification *info = [[NSNotification alloc]initWithName:@"gifManager" object:@[@"1",@"2"] userInfo:@{@"a":@"啊",@"b":@"哈"}];
    [self.view addSubview:self.zbloadView];
    [self performSelector:@selector(dismissView:) withObject:info afterDelay:10];
    
    [ZBDeviceTool shareSingleton];
    NSLog(@"%@",[ZBDeviceTool getCurrentDeviceModel]);
    
    NSArray *ary = @[@"1",@"2",@"3",@"4",@"5",@"6",@"8",@"9",@"10",@"11",@"12"];
    NSArray *new =  [ary createSubAryWithsplitArraywithSubSize:2];
    NSLog(@"count:%ld",new.count);
    
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSLog(@"型号: %@",phoneModel );
    
//    [self imageFunction];
 
    NSString *chinese = [ZBMathTool convertAmount:@"121231231356324.78"];
    NSLog(@"%@",chinese);
}
- (void)dismissView:(NSNotification*)info{
    NSLog(@"%@",[info.userInfo allValues]);
    [_zbloadView dismissLoadingView];
    _zbloadView = nil;
}
- (void)imageFunction {
    ImageTool *tool = [ImageTool shareTool];
    NSString *hdPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"gif"];
    NSData *data= [NSData dataWithContentsOfFile:hdPath];
    double time = [tool durationForGifData:data];
    FLAnimatedImageView  *gifimage = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(0, 20, 100, 100)];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    gifimage.animatedImage = image;
    [self.view addSubview:gifimage];
    NSLog(@"GIF:%lf",time);
}
- (ZBLoadingView *)zbloadView {
    if (!_zbloadView) {
        _zbloadView = [[ZBLoadingView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    }
    return _zbloadView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
