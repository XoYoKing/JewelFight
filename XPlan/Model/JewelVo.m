//
//  JewelVo.m
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelVo.h"

@implementation JewelVo

@synthesize globalId,jewelId,jewelType,coord,toY,time,disposeRight,disposeTop,state,hDispose,yGap;

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


-(int) toY
{
    return yGap + self.coord.y;
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
    yGap = 0;
}

-(BOOL) isLeft
{
    return self.coord.x == 0;
}

-(BOOL) isRight
{
    return self.coord.x == kJewelGridWidth-1;
}

-(BOOL) isBottom
{
    return self.coord.y == 0;
}

-(BOOL) isTop
{
    return self.coord.y == kJewelGridHeight-1;
}

@end
