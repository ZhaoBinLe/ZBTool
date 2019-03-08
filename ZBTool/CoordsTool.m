//
//  CoordsTool.m
//  Substation
//
//  Created by qmap01 on 16/12/9.
//  Copyright © 2016年 QMAP. All rights reserved.
//

#import "CoordsTool.h"

static CoordsTool *shareCTManager = nil;
@implementation CoordsTool

double  PI = 3.14159265358979324;
double  x_pi = 3.14159265358979324 * 3000.0/180.0;

+ (CoordsTool *)shareSingleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareCTManager = [[CoordsTool allocWithZone:NULL]init];
    });
    return shareCTManager;
}
- (void)delta:(double)lat :(double)lon :(coodsMessage)block{
     double a = 6378245.0;
     double ee = 0.00669342162296594323;
     double dLat = [self transformLat:lon-105.0 :lat-35.0];
     double dLon = [self transformLon:lon-105.0 :lat-35.0];
     double radLat = lat / 180.0 * PI;
     double magic = sin(radLat);
     magic = 1 - ee * magic *magic;
     double sqrtMagic = sqrt(magic);
     dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * PI);
     dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * PI);
     block(lat,lon);
}
//WGS-84 to GCJ-02
- (void)gcj_encrypt:(double)wgsLat :(double)wgslon :(coodsMessage)block {
    if ([self outOfChina:wgsLat :wgslon])
    {
        block(wgsLat,wgslon);
    }
    [self delta:wgsLat :wgslon :^( double longitude,  double latitude) {
        double Lat = wgsLat + latitude;
        double Lon = wgslon + longitude;
        block(Lat,Lon);
    }];
    
}
 //GCJ-02 to WGS-84
- (void)gcj_decrypt:(double)gcjLat :(double)gcjLon :(coodsMessage)block {
    if ([self outOfChina:gcjLat :gcjLon])
    {
        block(gcjLat,gcjLon);
    }
    [self delta:gcjLat :gcjLon :^( double longitude,  double latitude) {
        double Lat = gcjLat - latitude;
        double Lon = gcjLon - longitude;
        block(Lat,Lon);
    }];
}
//WGS-84 to Web mercator
//mercatorLat -> y mercatorLon -> x
- (void)mercator_encrypt:(double)wgsLat :(double)wgsLon :(coodsMessage)block {
    double x = wgsLon * 20037508.34 / 180.;
    double y = log(tan((90. + wgsLat) * PI / 360.)) / (PI / 180.);
    y = y * 20037508.34 / 180.;
    block(y,x);
}
// Web mercator to WGS-84
// mercatorLat -> y mercatorLon -> x
- (void)mercator_decrypt:(double)mercatorLat :(double)mercatorLon :(coodsMessage)block {
    double x = mercatorLon / 20037508.34 * 180.;
    double y = mercatorLat / 20037508.34 * 180.;
    y = 180 / PI * (2 * atan(exp(y * PI / 180.)) - PI / 2);
    block(y,x);
}
// two point's distance
- (double)distance:(double)latA :(double)lonA :(double)latB :(double)lonB  {
    double earthR = 6371000.;
    double x = cos(latA * PI / 180.) * cos(latB * PI / 180.) * cos((lonA - lonB) * PI / 180);
    double y = sin(latA * PI / 180.) * sin(latB * PI / 180.);
    double s = x + y;
    if (s > 1) s = 1;
    if (s < -1) s = -1;
    double alpha = acos(s);
    double distance = alpha * earthR;
    return distance;
}
- (bool)outOfChina:(double)lat :(double)lon {
    if (lon<72.004 || lon>137.8347) {
        return true;
    }
    if (lat < 0.8293 || lat > 55.8271) {
        return true;
    }
    return false;
}
- (double)transformLat:(double)x :(double)y {
    long double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrtl(abs(x));
    ret += (20.0 * sin(6.0 * x * PI) + 20.0 * sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * PI) + 40.0 * sin(y / 3.0 * PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * PI) + 320 * sin(y * PI / 30.0)) * 2.0 / 3.0;
    return ret;
}
- (double)transformLon:(double)x :(double)y {
    long double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * PI) + 20.0 * sin(2.0 * x * PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * PI) + 40.0 * sin(x / 3.0 * PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * PI) + 300.0 * sin(x / 30.0 * PI)) * 2.0 / 3.0;
    return ret;
}
 //GCJ-02 坐标转换成 BD-09(百度)
- (void)bd_encrypt:(double)gg_lat :(double)gg_lon :(coodsMessage)block  {
    double x = gg_lon, y = gg_lat;
    double bd_lat = 0.0, bd_lon = 0.0;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    bd_lon = z * cos(theta) + 0.0065;
    bd_lat = z * sin(theta) + 0.006;
    block(bd_lat,bd_lon);
}
 // BD-09(百度) 坐标转换成 GCJ-02
- (void)bd_decrypt:(double)bd_lat :(double)bd_lon :(coodsMessage)block  {
    double x = bd_lon - 0.0065, y = bd_lat - 0.006;
    double gg_lat = 0.0, gg_lon = 0.0;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    gg_lon = z * cos(theta);
    gg_lat = z * sin(theta);
    block(gg_lat,gg_lon);
}

@end
