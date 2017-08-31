//
//  ZBWebView.m
//  ZBTool
//
//  Created by qmap01 on 2017/8/30.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import "ZBWebView.h"

@interface ZBwebToast : UIView
{
    UILabel *m_contentLabel;
}
@property(strong,readwrite,nonatomic)UILabel *m_contentLabel;

+ (ZBwebToast*)share;
- (void)show:(NSString *)content withDuration:(NSTimeInterval)duration withView:(UIView *)view;

@end
@implementation ZBwebToast

static ZBwebToast *m_share = nil;

+ (ZBwebToast *)share {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_share = [[ZBwebToast allocWithZone:NULL]init];
    });
    
    return m_share;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.userInteractionEnabled = NO;
        self.layer.cornerRadius = 3.f;
        self.layer.shadowOpacity = 0.6;
        self.layer.shadowRadius = 3;
        self.layer.shadowOffset = CGSizeMake(3, 3);
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        
        _m_contentLabel = [[UILabel alloc] init];
        _m_contentLabel.backgroundColor = [UIColor clearColor];
        _m_contentLabel.font = [UIFont systemFontOfSize:12];
        _m_contentLabel.textColor = [UIColor whiteColor];
        _m_contentLabel.numberOfLines = 0;
        _m_contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:_m_contentLabel];
    }
    return self;
}
- (void)show:(NSString *)content withDuration:(NSTimeInterval)duration withView:(UIView *)view
{
    if (content) {
        
        _m_contentLabel.text=content;
        
        [self updateFramewithView:view];
        
        self.alpha = 1.0f;
        if (!self.superview)
        {
            [view addSubview:self];
            [view bringSubviewToFront:self];
            [self performSelector:@selector(doNext) withObject:nil afterDelay:duration];
        }
    }
}
- (void)updateFramewithView:(UIView *)view
{
    CGSize sizeFrame=[_m_contentLabel.text sizeWithAttributes:@{NSFontAttributeName:_m_contentLabel.font}];
    CGFloat width = sizeFrame.width + 40;
    CGFloat height = sizeFrame.height + 20;
    _m_contentLabel.bounds = CGRectMake(0, 0, sizeFrame.width, sizeFrame.height);
    _m_contentLabel.center = CGPointMake(width/2, height/2);
    self.bounds = CGRectMake(0, 0, width, height);
    
    self.center = CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
}
- (void)doNext
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         
                         self.alpha = 0;}
     
                     completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         
                     }];
}

@end
@interface ZBWebView()
{
    NSString *_webUrl;
    CGRect _frame;
    
}
@property(strong,readwrite,nonatomic)UIProgressView *progressView;

@end
@implementation ZBWebView
- (void)dealloc
{
    self.scrollView.delegate = nil;
    [self removeObserver:self forKeyPath:@"estimatedProgress"];
    [[self configuration].userContentController removeScriptMessageHandlerForName:@"CALLBACK_FUNCTION"];
}
- (instancetype)initWithFrame:(CGRect)frame withUrl:(NSString *)url
{
    self = [super initWithFrame:frame];
    if (self) {
        _frame=frame;
        self.backgroundColor=[UIColor whiteColor];
        self.navigationDelegate = self;
        self.UIDelegate=self;
        self.scrollView.scrollEnabled=YES;
        self.scrollView.delegate = self;
        self.configuration.requiresUserActionForMediaPlayback = NO;
        [self loadRequestWithRelativeUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        [self config];
        _webUrl=url;
    }
    return self;
}

-(void)config{
    [self configuration].userContentController = [[WKUserContentController alloc] init];
    [[self configuration].userContentController addScriptMessageHandler:self name:@"js.functionName"];
    NSString *metaStr = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content','width=480,user-scalable=no');document.getElementsByTagName('head')[0].appendChild(meta);";
    WKUserScript *wkUserScript = [[WKUserScript alloc] initWithSource:metaStr injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    [[self configuration].userContentController addUserScript:wkUserScript];
    [self configuration].preferences = [[WKPreferences alloc] init];
    [self configuration].preferences.minimumFontSize = 13;
    [self configuration].preferences.javaScriptEnabled = YES;
    [self configuration].preferences.javaScriptCanOpenWindowsAutomatically = NO;
    //添加进度监听
    [self addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)refreshWebView{
    [self loadRequestWithRelativeUrl:_webUrl];
}
- (void)loadRequestWithRelativeUrl:(nonnull NSString *)url
{
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:16];
    [self loadRequest:request];
    _webUrl=url;
}
- (void)loadRequestWithRelativeUrl:(NSString *)url params:(NSDictionary *)params {
    
    NSURL *urlparam = [self generateURL:url params:params];
    [self loadRequest:[NSURLRequest requestWithURL:urlparam]];
}
- (NSURL *)generateURL:(NSString*)baseURL params:(NSDictionary*)params {
    
    _webUrl = baseURL;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    
    NSMutableArray* pairs = [NSMutableArray array];
    
    for (NSString* key in param.keyEnumerator) {
        NSString *value = [NSString stringWithFormat:@"%@",[param objectForKey:key]];
        
        NSString* escaped_value = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(NULL,
                                                                                                        (__bridge CFStringRef)value,NULL,(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",kCFStringEncodingUTF8);
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, escaped_value]];
    }
    
    NSString *query = [pairs componentsJoinedByString:@"&"];
    baseURL = [baseURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSString* url = @"";
    if ([baseURL containsString:@"?"]) {
        url = [NSString stringWithFormat:@"%@&%@",baseURL, query];
    }
    else {
        url = [NSString stringWithFormat:@"%@?%@",baseURL, query];
    }
    
    return [NSURL URLWithString:url];
}

- (UIColor *)progressColor{
    return  _progressView.tintColor;
}

- (void)setProgressColor:(UIColor *)progressColor{
    self.progressView.tintColor=progressColor;
}

#pragma mark -web代理
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [self evaluateJavaScript:@"document.documentElement.style.webkitTouchCallout='none';" completionHandler:nil];
    [self evaluateJavaScript:@"document.documentElement.style.webkitUserSelect='none';" completionHandler:nil];
}
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"WebError=%@",error);
    [[ZBwebToast share]show:@"请检查网络..." withDuration:1 withView:self];
}
//接收到服务器跳转请求
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    decisionHandler(WKNavigationResponsePolicyAllow);
}
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    if (navigationAction.targetFrame == nil) {
        [webView loadRequest:navigationAction.request];
    }
    
    decisionHandler(WKNavigationActionPolicyAllow);
}
-(WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures
{
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}
//重点
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message
{
    NSLog(@"JS 调用了 %@ 方法，传回参数 %@",message.name,message.body);
    
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    [dic setObject:[message.body objectForKey:@"body"] forKey:@"body"];
    [dic setObject:message.name forKey:@"js.functionName"];
    if ([_delegate respondsToSelector:@selector(zbWebViewCallBack:)]) {
        [_delegate zbWebViewCallBack:dic];
    }
}
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    [[ZBwebToast share]show:message withDuration:1 withView:self];
}
- (void)callJS:(NSString *)jsMethod withParam:(id)param handler:(void (^)(id _Nullable))handler {
    NSString *dataJson;
    NSData*data;
    
    if ([param isKindOfClass:[NSString class]]) {
        data=[param dataUsingEncoding:NSUTF8StringEncoding];
        dataJson=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    else if([param isKindOfClass:[NSArray class]]||[param isKindOfClass:[NSMutableArray class]]||[param isKindOfClass:[NSDictionary class]]||[param isKindOfClass:[NSMutableDictionary class]]){
        data=[NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:nil];
        dataJson=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    }
    else{
        dataJson=@"";
    }
    NSLog(@"call js:%@",jsMethod);
    NSString *dataFunc=[NSString stringWithFormat:@"%@(%@)",jsMethod,dataJson];
    [self evaluateJavaScript:dataFunc completionHandler:^(id _Nullable response, NSError * _Nullable error) {
        if (handler) {
            handler(response);
        }
    }];
}
- (UIProgressView *)progressView
{
    if (!_progressView)
    {
        UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        progressView.tintColor =self.progressColor?self.progressColor:[UIColor redColor];
        progressView.trackTintColor = [UIColor clearColor];
        [self addSubview:progressView];
        self.progressView = progressView;
    }
    return _progressView;
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (object == self && [keyPath isEqualToString:@"estimatedProgress"])
    {
        CGFloat newprogress = [[change objectForKey:NSKeyValueChangeNewKey] doubleValue];
        if (newprogress == 1)
        {
            self.progressView.hidden = YES;
            [self.progressView setProgress:0 animated:NO];
        }
        else
        {
            self.progressView.hidden = NO;
            [self.progressView setProgress:newprogress animated:YES];
        }
    }
}
-(void)show{
    
    [UIView animateWithDuration:0.6 animations:^{
        self.frame=_frame;
    }];
}
-(void)hide{
    [UIView animateWithDuration:0.6 animations:^{
        self.frame=CGRectMake(self.frame.origin.x +_frame.size.width, _frame.origin.y, _frame.size.width, _frame.size.height);
    }];
}
@end
