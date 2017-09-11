//
//  NSArray+SplitAry.m
//  ZBTool
//
//  Created by qmap01 on 2017/9/11.
//  Copyright © 2017年 Zhaobin. All rights reserved.
//

#import "NSArray+SplitAry.h"

@implementation NSArray (SplitAry)
- (NSArray *)createSubAryWithsplitArraywithSubSize:(int)subSize {
    unsigned long count = self.count % subSize == 0 ? (self.count / subSize) : (self.count / subSize + 1);
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 0; i < count; i ++) {
        int index = i * subSize;
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        [arr1 removeAllObjects];
        
        int j = index;
        
        while (j < subSize*(i + 1) && j < self.count) {
            [arr1 addObject:[self objectAtIndex:j]];
            j += 1;
        }
        
        [arr addObject:[arr1 copy]];
    }
    return [arr copy];
}
@end
