//
//  FightController.m
//  XPlan
//
//  Created by Hex on 4/19/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightController.h"
#import "FightAction.h"
#import "FightActionQueue.h"
#import "FightField.h"
#import "FightPanel.h"
#import "FighterVo.h"

@interface FightController()

@end

@implementation FightController


-(id) initWithFightPanel:(FightPanel*)fp
{
    if ((self = [super init]))
    {
        fightPanel = fp;
        
        allFighterVoDict = [[NSMutableDictionary alloc] initWithCapacity:8];
        leftFighterVoList = [[CCArray alloc] initWithCapacity:5];
        rightFighterVoList = [[CCArray alloc] initWithCapacity:5];
    }
    
    return self;
}

-(void) dealloc
{
    [allFighterVoDict release];
    [leftFighterVoList release];
    [rightFighterVoList release];
    [super dealloc];
}

-(FightField*) fightField
{
    return fightPanel.fightField;
}

-(FightPortrait*) portrait
{
    return fightPanel.portrait;
}

-(void) update:(ccTime)delta
{
    [self updateFightActions:delta];
    [[self fightField] update:delta];
}

/// 设置战斗场景
-(void) setFightStreet:(int)sId
{
    streetId = sId;
    
    [fightPanel setFightStreet:streetId];
}

-(void) setLeftFighterVos:(CCArray *)leftList rightFighterVos:(CCArray *)rightList
{
    [allFighterVoDict removeAllObjects];
    [leftFighterVoList removeAllObjects];
    [rightFighterVoList removeAllObjects];
    
    [leftFighterVoList addObjectsFromArray:leftList];
    [rightFighterVoList addObjectsFromArray:rightList];
    for (FighterVo *fv in leftList)
    {
        [allFighterVoDict setObject:fv forKey:[NSNumber numberWithLong:fv.globalId]];
    }
    
    for (FighterVo *fv in rightList)
    {
        [allFighterVoDict setObject:fv forKey:[NSNumber numberWithLong:fv.globalId]];
    }
}

-(void) start
{
    // 第一批战士出战
    // 出战
    [self fighterEnterFightField:[leftFighterVoList objectAtIndex:0] team:0];
    [self fighterEnterFightField:[rightFighterVoList objectAtIndex:0] team:1];
}

/// 战士上场
-(void) fighterEnterFightField:(FighterVo*)fv team:(int)team
{
    if (team == 0)
    {
        [fightPanel.fightField createFighterSpriteWithFighterVo:fv];
    }
    else
    {
        
    }
}

#pragma mark -
#pragma mark FighterVo

/// 添加战士数据
-(void) addFighterVo:(FighterVo*)fv
{
    [allFighterVoDict setObject:fv forKey:[NSNumber numberWithLong:fv.globalId]];
    if (fv.team == 0)
    {
        [leftFighterVoList addObject:fv];
    }
    else
    {
        [rightFighterVoList addObject:fv];
    }
}

/// 删除战士数据
-(void) removeFighterVo:(FighterVo*)fv
{
    if (fv.team == 0)
    {
        [leftFighterVoList removeObject:fv];
    }
    else
    {
        [rightFighterVoList removeObject:fv];
    }
    
    [allFighterVoDict removeObjectForKey:[NSNumber numberWithLong:fv.globalId]];
}

#pragma mark -
#pragma mark Fight Actions

/// 更新英雄动作
-(void) updateFightActions:(ccTime)delta
{
    if (currentAction!=nil)
    {
        [currentAction update:delta];
        
        // 检查战士动作是否完成
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

-(void) queueAction:(FightAction*)action top:(BOOL)top
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


@end
