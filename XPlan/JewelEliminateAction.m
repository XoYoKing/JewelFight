//
//  JewelElimateAction.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelEliminateAction.h"
#import "JewelController.h"
#import "JewelCell.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "Constants.h"
#import "JewelFallAction.h"
#import "JewelBoard.h"
#import "JewelEliminateMessageData.h"
#import "GameMessageDispatcher.h"
#import "JewelBoardData.h"
#import "EliminateEffectAction.h"
#import "ExplodeEliminateEffectAction.h"
#import "FireEliminateEffectAction.h"
#import "BlackEliminateEffectAction.h"

@interface JewelEliminateAction()
{
    NSMutableSet *eliminatedGlobalIds; // 消除的宝石标识集合
    CCArray *effectActionQueue;// 消除效果序列
    EliminateEffectAction *currentEffectAction; // 当前消除效果
}

@end

@implementation JewelEliminateAction

-(id) initWithJewelController:(JewelController *)contr connectedGroup:(CCArray *)group
{
    if ((self = [super initWithJewelController:contr name:@"JewelEliminateAction"]))
    {
        // 待消除宝石序列组
        connectedGroup = [group retain];
        eliminatedGlobalIds = [[NSMutableSet alloc] initWithCapacity:20];
        effectActionQueue = [[CCArray alloc] initWithCapacity:5];
    }
    
    return self;
}

-(void) dealloc
{
    [eliminatedGlobalIds release];
    [connectedGroup release];
    [effectActionQueue release];
    [super dealloc];
}

-(void) start
{
    // 检查是否跳过动作
    if (skipped)
    {
        return;
    }
    
    // 宝石面板设置为不可操作
    [jewelController.board setIsControlEnabled:NO];
    
    // 初始化宝石消除完成标记
    allJewelsEliminated = NO;
    
    // 在动画执行前发送准备消除消息
    JewelEliminateMessageData *msg = [JewelEliminateMessageData dataWithUserId:jewelController.userId eliminateGroups:connectedGroup];
    [[GameMessageDispatcher sharedDispatcher] dispatchWithSender:jewelController message:JEWEL_MESSAGE_ELIMINATE_JEWELS object:msg];
    
    // 分析宝石序列组
    for (CCArray *connectedList in connectedGroup)
    {
        // 分析消除宝石序列
        [self analyze:connectedList];
    }
    
}


-(void) analyze:(CCArray*)connectedList
{
    JewelBoard *board = jewelController.board;
    
    // 先点燃特殊宝石
    // 自下向上寻找特殊宝石,并点燃
    BOOL hasSpecial = NO;
    for (JewelVo *jv in connectedList)
    {
        jv.eliminateType = 0; // 默认为0
        
        if (jv.special>0)
        {
            hasSpecial = YES;
            switch (jv.special)
            {
                // 爆炸效果
                case kJewelSpecialExplode:
                {
                    
                    // 移除水平方向的宝石
                    for (int xRemove = 0; xRemove < board.boardWidth; xRemove++)
                    {
                        JewelCell *jc = [board getCellAtCoord:ccp(xRemove,jv.coord.y)];
                        if (jc.jewelGlobalId>0 && (jc.jewelVo.special==0 || jc.jewelGlobalId == jv.globalId))
                        {
                            jc.jewelSprite.jewelVo.eliminateType = kJewelSpecialExplode;
                        }
                    }
                    
                    // 移除垂直方向的宝石
                    for (int yRemove = 0; yRemove < board.boardHeight; yRemove++)
                    {
                        JewelCell *jc = [board getCellAtCoord:ccp(jv.coord.x,yRemove)];
                        if (jc.jewelGlobalId>0 && (jc.jewelVo.special==0 || jc.jewelGlobalId == jv.globalId))
                        {
                            jc.jewelSprite.jewelVo.eliminateType = kJewelSpecialExplode;
                        }
                    }
                    
                    // 爆炸动作
                    ExplodeEliminateEffectAction *effect = [[ExplodeEliminateEffectAction alloc] initWithJewelController:jewelController eliminateAction:self jewel:jv];
                    [effectActionQueue addObject:effect];
                    [effect release];
                    break;
                }
            }
        }
    }
    
    if (!hasSpecial && connectedList.count >= kJewelSpecialExplode)
    {
        switch (connectedList.count)
        {
            case kJewelSpecialExplode:
            {
                // 最上方最左侧的宝石变成特殊宝石
                [[connectedList objectAtIndex:0] setSpecial:kJewelSpecialExplode];
                
                // 将特殊宝石从连接列表中清除
                [connectedList removeObjectAtIndex:0];
                break;
            }
            default:
            {
                // 最上方最左侧的宝石变成特殊宝石
                [[connectedList objectAtIndex:0] setSpecial:kJewelSpecialExplode];
                
                // 将特殊宝石从连接列表中清除
                [connectedList removeObjectAtIndex:0];
                break;
            }
        }
    }
    
    // 执行普通消除
    for (JewelVo *jv in connectedList)
    {
        if (jv.eliminateType==0)
        {
            // 普通消除,每个宝石100得分
            [jewelController addScore:100];
            [[jewelController.board getJewelSpriteWithGlobalId:jv.globalId] eliminate:0];
        }
    }
}


-(BOOL) isOver
{
    if (skipped)
    {
        return YES;
    }
    
    return allJewelsEliminated;
}

-(void) update:(ccTime)delta
{
    if (currentEffectAction != nil)
    {
        // 更新当前播放效果
        [currentEffectAction update:delta];
        
        // 检查宝石动作是否完成
        if ([currentEffectAction isOver])
        {
            [currentEffectAction release];
            currentEffectAction = nil;
        }
    }
    
    if (currentEffectAction == nil)
    {
        // 检查效果队列是否包含需要执行的效果
        if (effectActionQueue.count > 0)
        {
            currentEffectAction = [[effectActionQueue objectAtIndex:0] retain];
            [effectActionQueue removeObjectAtIndex:0];
            [currentEffectAction start];
        }
        else
        {
            // 标记全部完成
            allJewelsEliminated = YES;
            [self execute];
        }
    }
}


-(void) execute
{
    
    [jewelController.boardData updateJewelGridInfo];
    
    // 清理已经标记为删除的宝石
    [jewelController.boardData removeMarkedJewels];
    
    
    // 玩家操作的情况下, 处理下落逻辑,否则是等待
    if ([jewelController isPlayerControl])
    {

            
        // TODO:补充缺失的宝石
        
        // 宝石下落
        JewelFallAction *dropAction = [[JewelFallAction alloc] initWithJewelController:jewelController addList:nil];
        [jewelController queueAction:dropAction top:YES];
        [dropAction release];
        
    }
    
    
}

/// 检查全部宝石是否消除完毕
-(BOOL) isAllJewelEliminated
{
    BOOL eliminated = YES;
    for (JewelVo * elimVo in connectedGroup)
    {
        JewelSprite *elimSprite = [jewelController.board getJewelSpriteWithGlobalId:elimVo.globalId];
        if (elimSprite && elimSprite.state!=kJewelStateEliminated)
        {
            eliminated = NO;
            break;
        }
    }
    
    return eliminated;
}


@end
