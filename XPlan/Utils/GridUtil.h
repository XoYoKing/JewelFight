//
//  GridUtil.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 格子工具类
@interface GridUtil : NSObject
{
    float gridWidth; // 格子宽度
    float gridHeight; // 格子高度
    int totalWidth;
    int totalHeight;
}

+(GridUtil*) sharedUtil;



@end
