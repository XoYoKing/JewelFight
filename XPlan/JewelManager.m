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
#import "JewelPanel.h"
#import "JewelActionQueue.h"
#import "JewelAction.h"
#import "JewelInitAction.h"

@interface JewelManager()

@end

@implementation JewelManager

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



/// 重置
-(void) resetElimate
{
}

/// 检查所有宝石中能被消除的宝石
-(CCArray*) checkAllCanDispose
{
    [self resetElimate];
    
}


@end
