//
//  StoneController.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneController.h"
#import "StoneVo.h"
#import "Constants.h"

@implementation StoneController

-(id) initWithStonePanel:(StonePanel *)panel
{
    if ((self = [super init]))
    {
        stonePanel = panel;
        stoneGrid = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [stoneGrid release];
    [super dealloc];
}

-(void) setStoneColumn:(CCArray*)stoneVoList
{
}

/// 交换宝石位置并检测是否可以交换,及获得消除宝石队列
-(CCArray*) swapPositionWithStone1:(StoneVo*)stone1 stone2:(StoneVo*)stone2
{
    return nil;
}

-(StoneVo*) getStoneVoAtCoordX:(int)coordX coordY:(int)coordY
{
    return [[stoneGrid objectForKey:[NSNumber numberWithInt:coordX]] objectForKey:[NSNumber numberWithInt:coordY]];
}

/// 检查水平方向的可消除的宝石
-(CCArray*) checkHorizontalDisposeableStones:(StoneVo*)stone
{
    CCArray *checkList = [[CCArray alloc] initWithCapacity:10];
    [checkList addObject:stone];
    StoneVo *specialStone;
    
    // 检查特殊宝石
    if (stone.special >= kStoneSpecialExplode)
    {
        if(specialStone == nil || specialStone.special < stone.special)
        {
            specialStone = stone;
        }
    }
    
    //
    StoneVo *temp = stone;
    while (temp.x -1 >=0)
    {
        // 获取左侧宝石
        StoneVo *leftStone = [self getStoneVoAtCoordX:temp.x-1 coordY:temp.y];
        
        // 不是相同类型,退出
        if (leftStone.type != stone.type)
        {
            break;
        }
        
        // 检查特殊宝石
        if (leftStone.special >= kStoneSpecialExplode)
        {
            if (specialStone == nil || specialStone.special < leftStone.special)
            {
                specialStone = leftStone;
            }
        }
        
        [checkList insertObject:leftStone atIndex:0];
        temp = leftStone;
    }
    
    temp = stone;
    while (temp.x + 1 <5)
    {
        StoneVo *rightStone= [self getStoneVoAtCoordX:temp.x + 1 coordY:temp.y];
        if (rightStone.type!=stone.type)
        {
            break;
        }
        
        if (rightStone.special >= kStoneSpecialExplode)
        {
            if (specialStone == nil || specialStone.special < rightStone.special)
            {
                specialStone = rightStone;
            }
        }
        
        [checkList addObject:rightStone];
        temp = rightStone;
    }
    
    // 至少3个相同类型的宝石才能消除
    if (checkList.count >= 3)
    {
        BOOL isBoo;
        for (StoneVo *disposeSv in checkList)
        {
            disposeSv.hDispose = checkList.count; // 横向消除数量
            if (disposeSv.lt)
            {
                isBoo = YES;
                [self resetDisposeTop:disposeSv];
            }
        }
        
        if (checkList.count >= kStoneSpecialExplode && isBoo == NO)
        {
            [[checkList lastObject] setDisposeRight:YES];
        }
        
        return checkList;
    }
    
    return nil;
}

/// 检查垂直方向的可消除的宝石
-(CCArray*) checkVerticalDisposeableStones:(StoneVo*)stone
{
    CCArray *checkList = [[CCArray alloc] initWithCapacity:10];
    [checkList addObject:stone];
    StoneVo *specialStone;
    
    // 检查特殊宝石
    if (stone.special >= kStoneSpecialExplode)
    {
        if(specialStone == nil || specialStone.special < stone.special)
        {
            specialStone = stone;
        }
    }
    
    //
    StoneVo *temp = stone;
    while (temp.y-1 >=0)
    {
        // 获取上方宝石
        StoneVo *upStone = [self getStoneVoAtCoordX:temp.x coordY:temp.y-1];
        
        // 不是相同类型,退出
        if (upStone.type != stone.type)
        {
            break;
        }
        
        // 检查特殊宝石
        if (upStone.special >= kStoneSpecialExplode)
        {
            if (upStone == nil || specialStone.special < upStone.special)
            {
                specialStone = upStone;
            }
        }
        
        [checkList insertObject:upStone atIndex:0];
        temp = upStone;
    }
    
    temp = stone;
    while (temp.y + 1 <8)
    {
        StoneVo *downStone= [self getStoneVoAtCoordX:temp.x coordY:temp.y + 1];
        if (downStone.type!=stone.type)
        {
            break;
        }
        
        if (downStone.special >= kStoneSpecialExplode)
        {
            if (specialStone == nil || specialStone.special < downStone.special)
            {
                specialStone = downStone;
            }
        }
        
        [checkList addObject:downStone];
        temp = downStone;
    }
    
    // 至少3个相同类型的宝石才能消除
    if (checkList.count >= 3)
    {
        BOOL isBoo;
        for (StoneVo *disposeSv in checkList)
        {
            disposeSv.hDispose = checkList.count; // 横向消除数量
            if (disposeSv.lt)
            {
                isBoo = YES;
                [self resetDisposeRight:disposeSv];
            }
        }
        
        if (checkList.count >= kStoneSpecialExplode && isBoo == NO)
        {
            [[checkList lastObject] setDisposeRight:YES];
        }
        
        return checkList;
    }
    
    return nil;
}

/// 重置
-(void) resetDispose
{
    for (NSDictionary *rows in stoneGrid)
    {
        for (StoneVo *stoneVo in rows)
        {
            stoneVo.disposeRight = NO;
            stoneVo.disposeTop = NO;
            stoneVo.hDispose = 0;
            stoneVo.vDispose = 0;
        }
    }
}

/// 检查所有宝石中能被消除的宝石
-(CCArray*) checkAllCanDispose
{
    [self resetDispose];
    
}

///???
-(void) resetDisposeTop:(StoneVo*)stone
{
    StoneVo *temp = stone;
    while(temp.y - 1 >= 0)
    {
        StoneVo *upStone = [self getStoneVoAtCoordX:temp.x coordY:temp.y -1];
        if (upStone.type != stone.type)
        {
            break;
        }
        
        upStone.disposeTop = NO;
        temp = upStone;
    }
    temp = stone;
    while (temp.y+1 <8)
    {
        StoneVo *downStone = [self getStoneVoAtCoordX:temp.x coordY:temp.y +  1];
        if (downStone.type != stone.type)
        {
            break;
        }
        
        downStone.disposeTop = YES;
        temp = downStone;
    }
}

-(void) resetDisposeRight:(StoneVo*)stone
{
    StoneVo *temp = stone;
    while(temp.x - 1 >= 0)
    {
        StoneVo *leftStone = [self getStoneVoAtCoordX:temp.x-1 coordY:temp.y];
        if (leftStone.type != stone.type)
        {
            break;
        }
        
        leftStone.disposeTop = NO;
        temp = leftStone;
    }
    temp = stone;
    while (temp.x+1 <5)
    {
        StoneVo *rightStone = [self getStoneVoAtCoordX:temp.x+1 coordY:temp.y];
        if (rightStone.type != stone.type)
        {
            break;
        }
        
        rightStone.disposeTop = YES;
        temp = rightStone;
    }
}

@end
