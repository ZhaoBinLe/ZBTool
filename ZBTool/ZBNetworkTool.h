//
//  ZBNetworkTool.h
//  ZBTool
//
//  Created by qmap01 on 2018/5/4.
//  Copyright © 2018年 Zhaobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef NS_ENUM(NSUInteger,HTTPMethod) {
    GET,
    POST
};
typedef void (^AFNetworkReachabilityStatusBlock)(AFNetworkReachabilityStatus status) ;

@interface ZBNetworkTool : NSObject
+ (instancetype)shareNetTool;
- (void)request:(HTTPMethod)method
      urlString:(NSString *)urlString
     parameters:(id)parameters
        success:(void (^)(id))success
           fail:(void (^)(NSError *))fail;
- (void)getNetStatus:(AFNetworkReachabilityStatusBlock)statusblock;
@end
