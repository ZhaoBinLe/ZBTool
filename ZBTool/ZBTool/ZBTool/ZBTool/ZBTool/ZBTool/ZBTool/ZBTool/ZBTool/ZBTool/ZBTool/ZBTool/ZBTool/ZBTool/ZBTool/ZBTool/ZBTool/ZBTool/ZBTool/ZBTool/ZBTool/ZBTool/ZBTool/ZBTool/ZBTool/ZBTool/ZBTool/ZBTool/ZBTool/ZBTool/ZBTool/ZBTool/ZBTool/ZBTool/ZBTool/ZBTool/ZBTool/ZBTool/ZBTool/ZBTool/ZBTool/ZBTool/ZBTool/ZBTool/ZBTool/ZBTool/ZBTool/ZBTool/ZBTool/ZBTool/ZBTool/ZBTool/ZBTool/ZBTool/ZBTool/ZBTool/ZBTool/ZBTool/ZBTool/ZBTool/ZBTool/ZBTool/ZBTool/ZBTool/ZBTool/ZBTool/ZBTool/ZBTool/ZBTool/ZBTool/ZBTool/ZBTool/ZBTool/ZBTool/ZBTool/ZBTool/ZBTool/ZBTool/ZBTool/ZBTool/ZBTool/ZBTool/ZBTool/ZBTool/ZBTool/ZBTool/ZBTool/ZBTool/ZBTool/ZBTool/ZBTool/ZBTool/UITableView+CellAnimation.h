//
//  UITableView+CellAnimation.h
//  3DGround
//
//  Created by qmap01 on 16/2/19.
//  Copyright © 2016年 xutu_0001. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kBOUNCE_DISTANCE  2

typedef NS_ENUM(NSInteger,CellAnimation) {
    LeftToRightWaveAnimation = -1,
    RightToLeftWaveAnimation = 1
};


@interface UITableView (Wave)

- (void)reloadDataAnimateWithWave:(CellAnimation)animation;


@end