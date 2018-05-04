//
//  ZBNetworkTool.m
//  ZBTool
//
//  Created by qmap01 on 2018/5/4.
//  Copyright © 2018年 Zhaobin. All rights reserved.
//

#import "ZBNetworkTool.h"

@implementation ZBNetworkTool
+ (instancetype)shareNetTool {
    static ZBNetworkTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[ZBNetworkTool alloc]init];
    });
    return tool;
}
- (void)request:(HTTPMethod)method
      urlString:(NSString *)urlString
     parameters:(id)parameters
        success:(void (^)(id))success
           fail:(void (^)(NSError *))fail{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 30.f;
    manager.responseSerializer = [AFJSONResponseSerializer   serializerWithReadingOptions:NSJSONReadingMutableContainers];
    //    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/xml", @"text/plain", nil];
    if (method == GET) {
        [manager GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
          
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            fail(error);
        }];

    }else {
        [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             success(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            fail(error);
        }];
    }
}
- (void)getNetStatus:(AFNetworkReachabilityStatusBlock)statusblock{
    //监听网络状态
    AFNetworkReachabilityManager *netManager = [AFNetworkReachabilityManager sharedManager];
    [netManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        statusblock(status);
    }];
    [netManager startMonitoring];
}
@end
