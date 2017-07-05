//
//  ZBLoadingView.m
//  ZBTool
//
//  Created by qmap01 on 17/2/28.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import "ZBLoadingView.h"

@implementation ZBLoadingView
{
    FLAnimatedImageView *_loadingView;
}
- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self createUI];
        
    }
    return self;
}
- (void)createUI {
    _loadingView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake((self.frame.size.width - 44)/2, (self.frame.size.height - 44)/2, 44, 44)];
    [self addSubview:_loadingView];
    
    NSString *hdPath = [[NSBundle mainBundle] pathForResource:@"LoadingAnimation" ofType:@"gif"];
    NSData *data = [NSData dataWithContentsOfFile:hdPath];
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:data];
    _loadingView.animatedImage = image;
}
#pragma mark - 
- (void)dismissLoadingView {
    [UIView animateWithDuration:0.6f animations:^{
        self.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
- (void)dealloc {
    if (_loadingView) {
        [_loadingView removeFromSuperview];
        _loadingView = nil;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
