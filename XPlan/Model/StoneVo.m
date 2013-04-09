//
//  StoneVo.m
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneVo.h"

@implementation StoneVo

@synthesize stoneId,type,x,y,toY,time,disposeRight,disposeTop,state;

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

/// 重新设置标识
-(void) newId
{
    [self setStoneId:[NSString stringWithFormat:@"%d_%d",x,toY]];
    yGap = 0;
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
