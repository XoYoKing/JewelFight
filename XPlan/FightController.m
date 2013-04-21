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
#import "FighterVo.h"
#import "FighterVoCollection.h"

@interface FightController()

@end

@implementation FightController

@synthesize leftFighterVoColelction,rightFighterVoCollection;

-(id) init
{
    if ((self = [super init]))
    {
        leftFighterVoColelction = [[FighterVoCollection alloc] init];
        rightFighterVoCollection = [[FighterVoCollection alloc] init];
    }
    
    return self;
}

-(void) update:(ccTime)delta
{
    [self updateFightActions:delta];
    [fightField update:delta];
}

#pragma mark -
#pragma mark Fight Actions

/// 更新英雄动作
-(void) updateFightActions:(ccTime)delta
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
