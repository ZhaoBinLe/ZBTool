//
//  PulicDefine.h
//  Substation
//
//  Created by qmap01 on 16/10/9.
//  Copyright © 2016年 QMAP. All rights reserved.
//

#ifndef PulicDefine_h
#define PulicDefine_h

#define kScreenHeight [[UIScreen mainScreen] bounds].size.height
#define kScreenWidth  [[UIScreen mainScreen] bounds].size.width


#define AFNAPI_REQUEST_TIMEOUT 30


#ifdef DEBUG
#define DLog(format, ...) do {\
fprintf(stderr, "<Log位置：%s : 第%d行> %s ",                               \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "\n ----------------\n/ Hello  World!  \\\n\\ my Macro Log ~ /\n ----------------\n                 ^__^\n                 (OO)___________\n                 (__)\\          )\\/\\_\n                     ||_________)\n                     ||         |\n                     ww        ww\n");            \
}while (0);
#define DLogRect(rect) DLog(@"%s x:%.4f, y:%.4f, w:%.4f, h:%.4f", #rect, rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
#define DLogSize(size) DLog(@"%s w:%.4f, h:%.4f", #size, size.width, size.height);
#define DLogPoint(point) DLog(@"%s x:%.4f, y:%.4f", #point, point.x, point.y);
#else
#define DLog(format, ...)
#define DLogRect(rect)
#define DLogSize(size)
#define DLogPoint(point)
#endif



//弱引用
#define WS(weakSelf)  __weak __typeof(self)weakSelf = self;


#define DELAYEXECUTE(delayTime,func) (dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{func;}))



#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]


#define KUIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



#define kIsEmpty(x)	(((x) == nil ||[(x) isKindOfClass:[NSNull class]] ||([(x) isKindOfClass:[NSString class]] &&  [(NSString*)(x) length] == 0) || ([(x) isKindOfClass:[NSArray class]] && [(NSArray*)(x) count] == 0))|| ([(x) isKindOfClass:[NSDictionary class]] && [(NSDictionary*)(x) count] == 0))




#endif /* PulicDefine_h */
