//
//  GridUtil.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GridUtil.h"

@implementation GridUtil

/// 基于坐标获取对应的像素位置
-(CGPoint) pixelsByCoord:(CGPoint)coord
{
    return CGPointMake(coord.x * gridWidth + gridWidth/2, coord.y * gridHeight + gridHeight/2);
    
}

-(void) resize
{
    
}

@end
