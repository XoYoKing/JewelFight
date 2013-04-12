//
//  StoneController.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneManager.h"
#import "JewelVo.h"
#import "Constants.h"

@implementation StoneManager

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
-(CCArray*) swapPositionWithStone1:(JewelVo*)stone1 stone2:(JewelVo*)stone2
{
    return nil;
}

-(JewelVo*) getStoneVoAtCoordX:(int)coordX coordY:(int)coordY
{
    return [[stoneGrid objectForKey:[NSNumber numberWithInt:coordX]] objectForKey:[NSNumber numberWithInt:coordY]];
}

/// 检查水平方向的可消除的宝石
-(CCArray*) checkHorizontalDisposeableStones:(JewelVo*)stone
{
    CCArray *checkList = [[CCArray alloc] initWithCapacity:10];
    [checkList addObject:stone];
    JewelVo *specialStone;
    
    // 检查特殊宝石
    if (stone.special >= kStoneSpecialExplode)
    {
        if(specialStone == nil || specialStone.special < stone.special)
        {
            specialStone = stone;
        }
    }
    
    //
    JewelVo *temp = stone;
    while (temp.coord.x -1 >=0)
    {
        // 获取左侧宝石
        JewelVo *leftStone = [self getStoneVoAtCoordX:temp.coord.x-1 coordY:temp.coord.y];
        
        // 不是相同类型,退出
        if (leftStone.jewelId != stone.jewelId)
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
    while (temp.coord.x + 1 <kStoneGridWidth)
    {
        JewelVo *rightStone= [self getStoneVoAtCoordX:temp.coord.x + 1 coordY:temp.coord.y];
        if (rightStone.jewelId!=stone.jewelId)
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
        for (JewelVo *disposeSv in checkList)
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
-(CCArray*) checkVerticalDisposeableStones:(JewelVo*)stone
{
    CCArray *checkList = [[CCArray alloc] initWithCapacity:10];
    [checkList addObject:stone];
    JewelVo *specialStone;
    
    // 检查特殊宝石
    if (stone.special >= kStoneSpecialExplode)
    {
        if(specialStone == nil || specialStone.special < stone.special)
        {
            specialStone = stone;
        }
    }
    
    //
    JewelVo *temp = stone;
    while (temp.coord.y-1 >=0)
    {
        // 获取上方宝石
        JewelVo *upStone = [self getStoneVoAtCoordX:temp.coord.x coordY:temp.coord.y-1];
        
        // 不是相同类型,退出
        if (upStone.jewelType != stone.jewelType)
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
    while (temp.coord.y + 1 <kStoneGridHeight)
    {
        JewelVo *downStone= [self getStoneVoAtCoordX:temp.coord.x coordY:temp.coord.y + 1];
        if (downStone.jewelId!=stone.jewelId)
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
        for (JewelVo *disposeSv in checkList)
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
        for (JewelVo *stoneVo in rows)
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
-(void) resetDisposeTop:(JewelVo*)stone
{
    JewelVo *temp = stone;
    
    // 向上检查
    while(temp.coord.y - 1 >= 0)
    {
        JewelVo *upStone = [self getStoneVoAtCoordX:temp.coord.x coordY:temp.coord.y -1];
        if (upStone.jewelId != stone.jewelId)
        {
            break;
        }
        
        upStone.disposeTop = NO;
        temp = upStone;
    }
    temp = stone;
    
    // 向下检查
    while (temp.coord.y+1 <kStoneGridHeight)
    {
        JewelVo *downStone = [self getStoneVoAtCoordX:temp.coord.x coordY:temp.coord.y +  1];
        if (downStone.jewelId != stone.jewelId)
        {
            break;
        }
        
        downStone.disposeTop = YES;
        temp = downStone;
    }
}

-(void) resetDisposeRight:(JewelVo*)stone
{
    JewelVo *temp = stone;
    while(temp.coord.x - 1 >= 0)
    {
        JewelVo *leftStone = [self getStoneVoAtCoordX:temp.coord.x-1 coordY:temp.coord.y];
        if (leftStone.jewelId != stone.jewelId)
        {
            break;
        }
        
        leftStone.disposeTop = NO;
        temp = leftStone;
    }
    temp = stone;
    while (temp.coord.x+1 <5)
    {
        JewelVo *rightStone = [self getStoneVoAtCoordX:temp.coord.x+1 coordY:temp.coord.y];
        if (rightStone.jewelId != stone.jewelId)
        {
            break;
        }
        
        rightStone.disposeTop = YES;
        temp = rightStone;
    }
}

@end
