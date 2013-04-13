//
//  JewelController.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelManager.h"
#import "JewelVo.h"
#import "Constants.h"

@implementation JewelManager

-(id) initWithJewelPanel:(JewelPanel *)panel
{
    if ((self = [super init]))
    {
        jewelPanel = panel;
        jewelGrid = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [jewelGrid release];
    [super dealloc];
}

-(void) setJewelColumn:(CCArray*)jewelVoList
{
}

/// 交换宝石位置并检测是否可以交换,及获得消除宝石队列
-(CCArray*) swapPositionWithJewel1:(JewelVo*)jewel1 jewel2:(JewelVo*)jewel2
{
    return nil;
}

-(JewelVo*) getJewelVoAtCoordX:(int)coordX coordY:(int)coordY
{
    return [[jewelGrid objectForKey:[NSNumber numberWithInt:coordX]] objectForKey:[NSNumber numberWithInt:coordY]];
}

/// 检查水平方向的可消除的宝石
-(CCArray*) checkHorizontalDisposeableJewels:(JewelVo*)jewel
{
    CCArray *checkList = [[CCArray alloc] initWithCapacity:10];
    [checkList addObject:jewel];
    JewelVo *specialJewel;
    
    // 检查特殊宝石
    if (jewel.special >= kJewelSpecialExplode)
    {
        if(specialJewel == nil || specialJewel.special < jewel.special)
        {
            specialJewel = jewel;
        }
    }
    
    //
    JewelVo *temp = jewel;
    while (temp.coord.x -1 >=0)
    {
        // 获取左侧宝石
        JewelVo *leftJewel = [self getJewelVoAtCoordX:temp.coord.x-1 coordY:temp.coord.y];
        
        // 不是相同类型,退出
        if (leftJewel.jewelId != jewel.jewelId)
        {
            break;
        }
        
        // 检查特殊宝石
        if (leftJewel.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.special < leftJewel.special)
            {
                specialJewel = leftJewel;
            }
        }
        
        [checkList insertObject:leftJewel atIndex:0];
        temp = leftJewel;
    }
    
    temp = jewel;
    while (temp.coord.x + 1 <kJewelGridWidth)
    {
        JewelVo *rightJewel= [self getJewelVoAtCoordX:temp.coord.x + 1 coordY:temp.coord.y];
        if (rightJewel.jewelId!=jewel.jewelId)
        {
            break;
        }
        
        if (rightJewel.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.special < rightJewel.special)
            {
                specialJewel = rightJewel;
            }
        }
        
        [checkList addObject:rightJewel];
        temp = rightJewel;
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
        
        if (checkList.count >= kJewelSpecialExplode && isBoo == NO)
        {
            [[checkList lastObject] setDisposeRight:YES];
        }
        
        return checkList;
    }
    
    return nil;
}

/// 检查垂直方向的可消除的宝石
-(CCArray*) checkVerticalDisposeableJewels:(JewelVo*)jewel
{
    CCArray *checkList = [[CCArray alloc] initWithCapacity:10];
    [checkList addObject:jewel];
    JewelVo *specialJewel;
    
    // 检查特殊宝石
    if (jewel.special >= kJewelSpecialExplode)
    {
        if(specialJewel == nil || specialJewel.special < jewel.special)
        {
            specialJewel = jewel;
        }
    }
    
    //
    JewelVo *temp = jewel;
    while (temp.coord.y-1 >=0)
    {
        // 获取上方宝石
        JewelVo *upJewel = [self getJewelVoAtCoordX:temp.coord.x coordY:temp.coord.y-1];
        
        // 不是相同类型,退出
        if (upJewel.jewelType != jewel.jewelType)
        {
            break;
        }
        
        // 检查特殊宝石
        if (upJewel.special >= kJewelSpecialExplode)
        {
            if (upJewel == nil || specialJewel.special < upJewel.special)
            {
                specialJewel = upJewel;
            }
        }
        
        [checkList insertObject:upJewel atIndex:0];
        temp = upJewel;
    }
    
    temp = jewel;
    while (temp.coord.y + 1 <kJewelGridHeight)
    {
        JewelVo *downJewel= [self getJewelVoAtCoordX:temp.coord.x coordY:temp.coord.y + 1];
        if (downJewel.jewelId!=jewel.jewelId)
        {
            break;
        }
        
        if (downJewel.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.special < downJewel.special)
            {
                specialJewel = downJewel;
            }
        }
        
        [checkList addObject:downJewel];
        temp = downJewel;
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
        
        if (checkList.count >= kJewelSpecialExplode && isBoo == NO)
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
    for (NSDictionary *rows in jewelGrid)
    {
        for (JewelVo *jewelVo in rows)
        {
            jewelVo.disposeRight = NO;
            jewelVo.disposeTop = NO;
            jewelVo.hDispose = 0;
            jewelVo.vDispose = 0;
        }
    }
}

/// 检查所有宝石中能被消除的宝石
-(CCArray*) checkAllCanDispose
{
    [self resetDispose];
    
}

///???
-(void) resetDisposeTop:(JewelVo*)jewel
{
    JewelVo *temp = jewel;
    
    // 向上检查
    while(temp.coord.y - 1 >= 0)
    {
        JewelVo *upJewel = [self getJewelVoAtCoordX:temp.coord.x coordY:temp.coord.y -1];
        if (upJewel.jewelId != jewel.jewelId)
        {
            break;
        }
        
        upJewel.disposeTop = NO;
        temp = upJewel;
    }
    temp = jewel;
    
    // 向下检查
    while (temp.coord.y+1 <kJewelGridHeight)
    {
        JewelVo *downJewel = [self getJewelVoAtCoordX:temp.coord.x coordY:temp.coord.y +  1];
        if (downJewel.jewelId != jewel.jewelId)
        {
            break;
        }
        
        downJewel.disposeTop = YES;
        temp = downJewel;
    }
}

-(void) resetDisposeRight:(JewelVo*)jewel
{
    JewelVo *temp = jewel;
    while(temp.coord.x - 1 >= 0)
    {
        JewelVo *leftJewel = [self getJewelVoAtCoordX:temp.coord.x-1 coordY:temp.coord.y];
        if (leftJewel.jewelId != jewel.jewelId)
        {
            break;
        }
        
        leftJewel.disposeTop = NO;
        temp = leftJewel;
    }
    temp = jewel;
    while (temp.coord.x+1 <5)
    {
        JewelVo *rightJewel = [self getJewelVoAtCoordX:temp.coord.x+1 coordY:temp.coord.y];
        if (rightJewel.jewelId != jewel.jewelId)
        {
            break;
        }
        
        rightJewel.disposeTop = YES;
        temp = rightJewel;
    }
}

@end
