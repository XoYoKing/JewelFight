//
//  JewelController.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelController.h"
#import "JewelVo.h"
#import "Constants.h"
#import "JewelPanel.h"
#import "JewelActionQueue.h"
#import "JewelAction.h"
#import "JewelInitAction.h"

@interface JewelController()

@end

@implementation JewelController

@synthesize jewelPanel;

-(id) initWithJewelPanel:(JewelPanel *)panel
{
    if ((self = [super init]))
    {
        jewelPanel = panel;
        jewelPanel.jewelController = self;
        
        jewelVoDict = [[NSMutableDictionary alloc] init];
        jewelVoList = [[CCArray alloc] initWithCapacity:60];
        actionQueue = [[JewelActionQueue alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [actionQueue release];
    [jewelVoDict release];
    [jewelVoList release];
    
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    [self updateJewelActions:delta];
    [self.jewelPanel update:delta];
}

#pragma mark -
#pragma mark Jewel Actions

/// 更新宝石动作
-(void) updateJewelActions:(ccTime)delta
{
    if (currentAction!=nil)
    {
        [currentAction update:delta];
        
        // 检查宝石动作是否完成
        if ([currentAction isOver])
        {
            currentAction = nil;
        }
    }
    
    if (currentAction == nil)
    {
        if (actionQueue.actions.count > 0)
        {
            currentAction = [[actionQueue.actions objectAtIndex:0] retain];
            [actionQueue.actions removeObjectAtIndex:0];
            [currentAction start];
        }
    }
}

-(void) queueAction:(JewelAction*)action top:(BOOL)top
{
    if (top)
    {
        [actionQueue.actions insertObject:action atIndex:0];
    }
    else
    {
        [actionQueue.actions addObject:action];
    }
}

-(void) resetActions
{
    [actionQueue.actions removeAllObjects];
    currentAction = nil;
}

-(void) newJewelVoList:(CCArray *)list
{
    // 清除原来的全部宝石
    [self removeAllJewels];
    
    // Action
    JewelInitAction *action = [[JewelInitAction alloc] initWithJewelController:self jewelVoList:list];
    [self queueAction:action top:NO];
    [action release];
    
}

-(void) addNewJewelsWithActionId:(long)actionId voList:(CCArray*)list
{
    
    JewelInitAction *action = [[JewelInitAction alloc] initWithJewelController:self jewelVoList:list];
    [self queueAction:action top:NO];
}


/// 添加宝石数据
-(void) addJewelVo:(JewelVo*)jv
{
    // 添加JewelVo
    if (![jewelVoDict.allKeys containsObject:[NSNumber numberWithInt:jv.globalId]])
    {
        [jewelVoDict setObject:jv forKey:[NSNumber numberWithInt:jv.globalId]];
        [jewelVoList addObject:jv];
    }
}

/// 删除宝石数据
-(void) removeJewelVo:(JewelVo*)jv
{
    [jewelVoDict removeObjectForKey:[NSNumber numberWithInt:jv.globalId]];
    [jewelVoList removeObject:jv];
}

-(void) removeAllJewels
{
    // 清除Jewel Sprite
    [self.jewelPanel removeAllJewels];
    
    // 清除
    [jewelVoDict removeAllObjects];
    [jewelVoList removeAllObjects];
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
-(void) resetElimate
{
}

/// 检查所有宝石中能被消除的宝石
-(CCArray*) checkAllCanDispose
{
    [self resetElimate];
    
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
