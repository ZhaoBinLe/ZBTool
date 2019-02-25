//
//  PhotosManager.m
//  iOSPhotos
//
//  Created by qmap01 on 2018/4/3.
//  Copyright © 2018年 Zhaobin. All rights reserved.
//

#import "PhotosManager.h"

@interface PhotosManager()

@end


static PhotosManager *manager = nil;
@implementation PhotosManager
+ (PhotosManager *)shareSignleton {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PhotosManager allocWithZone:NULL];
    });
    return manager;
}
- (void)PhotosCreateCollections:(NSArray *)collectionAry {
    //查询自定义相册
    PHFetchResult<PHAssetCollection *> *collectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    for (int i=0; i<collectionAry.count; i++) {
        for (PHAssetCollection *collection in collectionResult) {
            if ([collection.localizedTitle isEqualToString:collectionAry[i]]) {
                [dict setObject:@"YES" forKey:collectionAry[i]];
            }
        }
    }
    __block NSString *collectionId = nil;
    NSError *error = nil;
    for (int i=0; i<collectionAry.count; i++) {
        //查询自定义相册对象是否存在；
        BOOL isExist = [dict[collectionAry[i]] boolValue];
        if (isExist) {
            return;
        }
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            collectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:collectionAry[i]].placeholderForCreatedAssetCollection.localIdentifier;
        } error:&error];
        if (error) {
            NSLog(@"获取相册失败:%@",collectionAry[i]);
        }
    }
    
}
- (NSArray *)PhotosGetAllPhotosCollection:(NSArray *)collectionAry {
    //获取自定义相册
    PHFetchResult<PHAssetCollection *> *collectionResult =  [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    NSMutableArray *phdata =[[NSMutableArray alloc]init];
    NSLog(@"%ld",collectionResult.count);
    for (PHAssetCollection *collection in collectionResult) {
        for (NSString *photoName in collectionAry) {
            if ([photoName isEqualToString:collection.localizedTitle]) {
                NSLog(@"创建自定相册成功：%@",collection.localizedTitle);
                [phdata addObject:collection];
            }
        }
    }
    return phdata;
}
- (NSArray *)searchAllImagesInCollection:(PHAssetCollection *)collection {
 
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;
    imageOptions.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;

  
    NSMutableArray *assetAry = [[NSMutableArray alloc]init];
    PHFetchResult<PHAsset *> *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    [assetResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[PHAsset class]]) {
            [assetAry addObject:obj];
        }
    }];
    //缓存 似乎无效
    PHCachingImageManager *cachingImage = [[PHCachingImageManager alloc] init];
    [cachingImage startCachingImagesForAssets:assetAry
                                   targetSize:PHImageManagerMaximumSize
                                  contentMode:PHImageContentModeAspectFit
                                      options:nil];
    
    NSMutableArray *phdata = [[NSMutableArray alloc]init];
    PHImageManager *phManager= [PHImageManager defaultManager];
    for (PHAsset *asset in assetAry) {
        // 过滤非图片
        if (asset.mediaType != PHAssetMediaTypeImage) continue;
////         图片原尺寸
//        CGSize targetSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
////         请求图片
//        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            NSLog(@"图片：%@", result);
//            [phdata addObject:result];
//        }];
//
        [phManager requestImageDataForAsset:asset
                                    options:imageOptions
                              resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            [phdata addObject:imageData];
        }];
      
    }
    return phdata;
}

/** 校验是否有相机权限 */
+ (void)zb_checkCameraAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted
{
    AVAuthorizationStatus videoAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
    switch (videoAuthStatus) {
            // 已授权
        case AVAuthorizationStatusAuthorized:
        {
            permissionGranted(YES);
        }
            break;
            // 未询问用户是否授权
        case AVAuthorizationStatusNotDetermined:
        {
            // 提示用户授权
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                permissionGranted(granted);
            }];
        }
            break;
            // 用户拒绝授权或权限受限
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在”设置-隐私-相机”选项中，允许访问你的相机" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            permissionGranted(NO);
        }
            break;
        default:
            break;
    }
}

/** 校验是否有相册权限 */
+ (void)zb_checkAlbumAuthorizationStatusWithGrand:(void(^)(BOOL granted))permissionGranted {
    
    PHAuthorizationStatus photoAuthStatus = [PHPhotoLibrary authorizationStatus];
    switch (photoAuthStatus) {
            // 已授权
        case PHAuthorizationStatusAuthorized:
        {
            permissionGranted(YES);
        }
            break;
            // 未询问用户是否授权
        case PHAuthorizationStatusNotDetermined:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                permissionGranted(status == PHAuthorizationStatusAuthorized);
            }];
        }
            break;
            // 用户拒绝授权或权限受限
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
        {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在”设置-隐私-相片”选项中，允许访问你的相册" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            permissionGranted(NO);
        }
            break;
        default:
            break;
    }
    
}
@end
