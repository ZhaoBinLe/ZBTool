//
//  PhotosManager.h
//  iOSPhotos
//
//  Created by qmap01 on 2018/4/3.
//  Copyright © 2018年 Zhaobin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface PhotosManager : NSObject
+ (PhotosManager*)shareSignleton;

/**
 创建本地相册

 @param collectionAry 相册名称组
 */
- (void)PhotosCreateCollections:(NSArray *)collectionAry;

/**
 获取创建本地相册

 @param collectionAry 相册名称
 @return 主动创建的本地相册
 */
- (NSArray *)PhotosGetAllPhotosCollection:(NSArray *)collectionAry;

/**
 获取相片

 @param collection 单相册
 @return 相片组
 */
- (NSArray *)searchAllImagesInCollection:(PHAssetCollection *)collection;
@end
