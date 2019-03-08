//
//  CoordsTool.h
//  Substation
//
//  Created by qmap01 on 16/12/9.
//  Copyright © 2016年 QMAP. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^coodsMessage)( double  longitude, double latitude);

@interface CoordsTool : NSObject

+ (CoordsTool *)shareSingleton;

- (void)gcj_encrypt:(double)wgsLat :(double)wgslon :(coodsMessage)block ;

- (void)gcj_decrypt:(double)gcjLat :(double)gcjLon :(coodsMessage)block ;

- (void)mercator_encrypt:(double)wgsLat :(double)wgsLon :(coodsMessage)block ;

- (void)mercator_decrypt:(double)mercatorLat :(double)mercatorLon :(coodsMessage)block ;

- (double)distance:(double)latA :(double)lonA :(double)latB :(double)lonB ;

- (void)bd_encrypt:(double)gg_lat :(double)gg_lon :(coodsMessage)block ;

- (void)bd_decrypt:( double)bd_lat :( double)bd_lon :(coodsMessage)block ;

@end
