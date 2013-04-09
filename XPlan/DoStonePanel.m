//
//  DoStonePanel.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "DoStonePanel.h"
#import "StoneItem.h"
#import "HeroVo.h"
#import "StoneVo.h"
#import "StoneItem.h"
#import "StoneActionQueue.h"
#import "StoneAction.h"
#import "StoneAddAction.h"
#import "StoneCell.h"

@interface DoStonePanel()
{
    StoneItem *selectedStone; // 选中的宝石
    StoneActionQueue *actionQueue; // 操作宝石动作队列
    StoneAction *currentAction; // 当前宝石动作
}


@end

@implementation DoStonePanel

-(id) init
{
    if ((self = [super init]))
    {
        actionQueue = [[StoneActionQueue alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [actionQueue release];
    [super dealloc];
}




-(void) onEnter
{
    [[CCDirector sharedDirector].touchDispatcher addTargetedDelegate:self priority:1 swallowsTouches:NO];
    [super onEnter];
}

-(void) onExit
{
    [[CCDirector sharedDirector].touchDispatcher removeDelegate:self];
    [super onExit];
}

/// 逻辑更新
-(void) update:(ccTime)delta
{
    // 遍历全部的宝石动作
    [self updateStoneActions:delta];
    
    /// 更新宝石
    [self updateStones:delta];
    
}

/// 更新宝石动作
-(void) updateStoneActions:(ccTime)delta
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

-(void) queueAction:(StoneAction*)action top:(BOOL)top
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

-(void) updateStones:(ccTime)delta
{
    CCArray *stonesToRemove = [[CCArray alloc] initWithCapacity:10];
    
    for (StoneItem *stone in allStoneItems)
    {
        BOOL remove = [stone update:delta];
        if (remove)
        {
            [stonesToRemove addObject:stone];
            continue;
        }
        
        // 更新移动
        [stone updateMovement:delta];
        
    }
    
    if (stonesToRemove.count > 0)
    {
        for (StoneItem *stone in stonesToRemove)
        {
            [self removeStoneItem:stone];
        }
    }
    
    [stonesToRemove removeAllObjects];
    
}

/// 创建新的宝石队列
-(void) newStoneColumnWithHeroVo:(HeroVo*)hv stoneVoList:(CCArray*)stoneVoList
{
    // 清理
    [self removeAllStones];
}

-(void) removeAllStones
{
    for (CCNode *node in self.children)
    {
        if ([node isKindOfClass:[StoneItem class]])
        {
            [node removeFromParentAndCleanup:YES];
        }
    }
}

#pragma mark -
#pragma mark Touch

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    return NO;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

- (void)ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

#pragma mark -
#pragma mark Public Methods

-(void) addNewStonesWithActionId:(long)actionId continueDispose:(int)continueDispose voList:(CCArray*)list
{
    if (actionQueue.actions.count < 1)
    {
        [self addNewStonesWithStoneVoList:list];
    }
    else
    {
        StoneAddAction *action = [[StoneAddAction alloc] initWithStonePanel:self continueDispose:continueDispose stoneVoList:list];
        [self queueAction:action top:NO];
    }
}

/// 添加新宝石列表
-(void) addNewStonesWithStoneVoList:(CCArray *)list
{
    for (StoneVo *sv in list)
    {
        [self createStoneItem:sv];
    }
}

@end
