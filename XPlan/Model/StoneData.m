//
//  StoneVo.m
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneData.h"

@implementation StoneData

@synthesize stoneId,x,y,toY,time;

-(id) init
{
    if ((self = [super init]))
    {
        yGap = 0;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) setStoneId:(NSString *)value
{
    [stoneId release];
    stoneId = [value retain];
    
    // 设置坐标
    NSArray *arr = [stoneId componentsSeparatedByString:@"_"];
    x = [[arr objectAtIndex:0] intValue];
    y = [[arr objectAtIndex:1] intValue];
}

-(int) toY
{
    return yGap + y;
}

-(void) newId
{
    // 释放之前的地址,避免泄露
    [stoneId release];
    
    // 重新赋值
    stoneId = [NSString stringWithFormat:@"%d_%d",x,toY];
    yGap = 0;
}

/// 消除数量
-(int) disposeNum
{
    return hDispose + vDispose;
}

-(BOOL) lt
{
    return hDispose >0 && vDispose > 0;
}


-(float) time
{
    int temp = abs(yGap);
    if (temp == 0)
    {
        return 0;
    }
    else if (temp == 1)
    {
        return 0.14f;
    }
    else
    {
        return 0.3f;
    }
}



-(void) addYGap
{
    yGap--;
}

-(BOOL) isLeft
{
    return self.x == 0;
}

-(BOOL) isRight
{
    return self.x == 4;
}

-(BOOL) isBottom
{
    return self.y == 0;
}

-(BOOL) isTop
{
    return self.y == 7;
}

@end
