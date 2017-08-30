//
//  ZBWebView.h
//  ZBTool
//
//  Created by qmap01 on 2017/8/30.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@protocol ZBWebviewDelegate <NSObject>

-(void)zbWebViewCallBack:(nullable id)param;

@end

NS_ASSUME_NONNULL_BEGIN
@interface ZBWebView : WKWebView<WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler,UICollectionViewDelegate>
- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)url;
- (void)loadRequestWithRelativeUrl:(nonnull NSString *)url;
- (void)loadRequestWithRelativeUrl:(NSString *)url params:(NSDictionary *)params;
-(void)refreshWebView;
- (void)callJS:(NSString *)jsMethod withParam:(id)param handler:(void (^)(id _Nullable))handler ;
-(void)show;
-(void)hide;
@property (nonatomic,weak,nullable) id <ZBWebviewDelegate> delegate;
@property (strong, nonatomic,readwrite) UIColor *progressColor;
@end
NS_ASSUME_NONNULL_END
