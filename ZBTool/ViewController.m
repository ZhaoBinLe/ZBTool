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
    
}
- (void)dismissView:(NSNotification*)info{
    NSLog(@"%@",[info.userInfo allValues]);
    [_zbloadView dismissLoadingView];
    _zbloadView = nil;
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
