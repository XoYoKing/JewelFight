//
//  JewelController.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelController.h"
#import "JewelVo.h"
#import "JewelCell.h"
#import "JewelSprite.h"
#import "Constants.h"
#import "JewelBoard.h"
#import "JewelActionQueue.h"
#import "JewelAction.h"
#import "JewelFallAction.h"
#import "JewelFactory.h"
#import "GameMessageDispatcher.h"
#import "JewelMessageData.h"
#import "Constants.h"
#import "GameController.h"
#import "PlayerInfo.h"
#import "JewelBoardData.h"

@interface JewelController()
{
}
@end

@implementation JewelController

@synthesize board,boardData,userId,boardWidth,boardHeight;

-(id) initWithJewelBoard:(JewelBoard *)jb operatorUserId:(long)uId
{
    if ((self = [super init]))
    {
        board = jb;
        board.jewelController = self;
        userId = uId;
        
        // 设置格子宽高
        boardWidth = kJewelBoardWidth;
        boardHeight = kJewelBoardHeight;
        
        boardData = [[JewelBoardData alloc] initWithJewelController:self];
        
        actionQueue = [[JewelActionQueue alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [actionQueue release];
    [boardData release];
    [super dealloc];
}

-(void) update:(ccTime)delta
{    
    [self updateJewelActions:delta];
    [self.board update:delta];
    
    
    // 针对玩家自身
    if (self.userId == [GameController sharedController].player.userId)
    {
        // 没有动作的时候才更新
        if (actionQueue.actions.count == 0)
        {
            [board updateHint];
        }
    }
}

/// 检查连续消除
-(void) checkContinue
{
    
}

#pragma mark -
#pragma mark Status

-(BOOL) isPlayerControl
{
    return self.userId == [GameController sharedController].player.userId;
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

#pragma mark -
#pragma mark JewelVo

-(void) newJewelVoList:(CCArray *)list
{
    // 清除原来的全部宝石
    [self removeAllJewels];
    
    [self addJewelVoList:list];
}


/// 添加宝石数据
-(void) addJewelVo:(JewelVo*)jv
{
    [boardData addJewelVo:jv];
}

/// 删除宝石数据
-(void) removeJewelVo:(JewelVo*)jv
{
    [boardData removeJewelVo:jv];
}

-(void) removeAllJewels
{
    // 清除宝石面板的全部宝石Sprite
    [self.board removeAllJewels];
    
    // 清除全部数据
    [boardData removeAllJewelVos];
}


/// 添加宝石队列
-(void) addJewelVoList:(CCArray*)list
{
    // 执行下落动作
    JewelFallAction *action = [[JewelFallAction alloc] initWithJewelController:self addList:list];
    [self queueAction:action top:NO];
    [action release];
}

/// 执行爆炸效果
-(void) doExplodeEffectWithJewelVoList:(CCArray*)jewelVoList
{
    
}

/// 执行闪电消除效果
-(void) doLightEffectWithJewelVoList:(CCArray*)jewelVoList
{
    
}




@end
