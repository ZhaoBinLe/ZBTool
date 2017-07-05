//
//  ZBRegexTool.h
//  ZBTool
//
//  Created by qmap01 on 17/3/1.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBRegexTool : NSObject
//邮箱
+ (BOOL) validateEmail:(NSString *)email;
//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile;
//车牌号验证
+ (BOOL) validateCarNo:(NSString *)carNo;
//车型
+ (BOOL) validateCarType:(NSString *)CarType;
//用户名
+ (BOOL) validateUserName:(NSString *)name;
//密码
+ (BOOL) validatePassword:(NSString *)passWord;
//昵称
+ (BOOL) validateNickname:(NSString *)nickname;
//身份证号
+ (BOOL) validateIdentityCard: (NSString *)identityCard;
@end
