//
//  DoJewelPanel.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "DoJewlPanel.h"
#import "JewelSprite.h"
#import "HeroVo.h"
#import "JewelVo.h"
#import "JewelSprite.h"
#import "JewelActionQueue.h"
#import "JewelAction.h"
#import "JewelAddAction.h"
#import "JewelCell.h"

@interface DoJewlPanel()
{
    JewelSprite *selectedJewel; // 选中的宝石
    JewelActionQueue *actionQueue; // 操作宝石动作队列
    JewelAction *currentAction; // 当前宝石动作
}


@end

@implementation DoJewlPanel

-(id) init
{
    if ((self = [super init]))
    {
        actionQueue = [[JewelActionQueue alloc] init];
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
    [self updateJewelActions:delta];
    
    /// 更新宝石
    [self updateJewels:delta];
    
}

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

-(void) updateJewels:(ccTime)delta
{
    CCArray *jewelsToRemove = [[CCArray alloc] initWithCapacity:10];
    
    for (JewelSprite *jewel in allJewelItems)
    {
        BOOL remove = [jewel update:delta];
        if (remove)
        {
            [jewelsToRemove addObject:jewel];
            continue;
        }
        
        // 更新移动
        [jewel updateMovement:delta];
        
    }
    
    if (jewelsToRemove.count > 0)
    {
        for (JewelSprite *jewel in jewelsToRemove)
        {
            [self removeJewelItem:jewel];
        }
    }
    
    [jewelsToRemove removeAllObjects];
    
}

/// 创建新的宝石队列
-(void) newJewelColumnWithHeroVo:(HeroVo*)hv jewelVoList:(CCArray*)jewelVoList
{
    // 清理
    [self removeAllJewels];
}

-(void) removeAllJewels
{
    for (CCNode *node in self.children)
    {
        if ([node isKindOfClass:[JewelSprite class]])
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

-(void) addNewJewelsWithActionId:(long)actionId continueDispose:(int)continueDispose voList:(CCArray*)list
{
    if (actionQueue.actions.count < 1)
    {
        [self addNewJewelsWithJewelVoList:list];
    }
    else
    {
        JewelAddAction *action = [[JewelAddAction alloc] initWithJewelPanel:self continueDispose:continueDispose jewelVoList:list];
        [self queueAction:action top:NO];
    }
}

/// 添加新宝石列表
-(void) addNewJewelsWithJewelVoList:(CCArray *)list
{
    for (JewelVo *sv in list)
    {
        [self createJewelSprite:sv];
    }
}

@end
