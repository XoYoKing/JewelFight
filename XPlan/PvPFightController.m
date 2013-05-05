//
//  PvPFightManager.m
//  XPlan
//
//  Created by Hex on 4/10/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightController.h"
#import "PvPController.h"
#import "FightPortrait.h"
#import "PvPLayer.h"
#import "PlayerInfo.h"
#import "Constants.h"
#import "PvPScene.h"
#import "UserInfo.h"
#import "GameController.h"
#import "GameServer.h"
#import "JewelController.h"
#import "FightController.h"
#import "JewelSwapMessageData.h"
#import "JewelEliminateMessageData.h"
#import "GameMessageDispatcher.h"
#import "NewJewelsCommandData.h"
#import "DeadJewelsCommandData.h"
#import "AttackVo.h"
#import "FightAttackAction.h"

@interface PvPFightController()
{
    PvPLayer *pvpLayer; // PVP页面

    // 请求后台
    double requestTotalCost; // 请求后台所花总时间
    double requestStartTime; // 请求后台开始时间
}

@end

@implementation PvPFightController

@synthesize state,newState;

-(id) initWithPvPController:(PvPController *)contr
{
    if ((self = [super init]))
    {
        controller = contr;
        state = 0;
        newState = 0;
    }
    
    return self;
}

-(void) dealloc
{
    [self exitFight];
    [opponentUser release];
    
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    if (state!=newState)
    {
        [self changeState:newState];
    }
    
    if (self.state == kPvpFightStatePlay)
    {
        [playerJewelController update:delta];
        [opponentJewelController update:delta];
        [fightController update:delta];
    }
}

-(void) changeState:(int)s
{
    self.state = self.newState = s;
}


/// 接收玩家出战英雄信息和对手出战英雄信息
-(void) setupWithPlayerFighters:(CCArray*)pf opponentUser:(UserInfo*)o opponentFighters:(CCArray*)of
{
    // 保存对手苏虎踞
    opponentUser = [o retain];
    
    // 设置用户信息
    [pvpLayer.player2JewelPanel setOpponent:opponentUser];
    
    // 设置战士信息
    if (playerTeam == 0)
    {
        [fightController setLeftFighterVos:pf rightFighterVos:of];
    }
    else
    {
        [fightController setLeftFighterVos:of rightFighterVos:pf];
    }
    
}

-(void) handlePlayerJewels:(CCArray*)ps opponentJewels:(CCArray*)os
{
    [playerJewelController newJewelVoList:ps];
    [opponentJewelController newJewelVoList:os];
}

/// 初始化战斗
-(void) initFightWithPlayerTeam:(int)team street:(int)streetId
{
    // 预加载宝石素材
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"jewel_resources.plist"];
    
    // 显示战斗层
    pvpLayer = [[PvPLayer alloc] init];
    [controller.scene addChild:pvpLayer z:0 tag:kTagPvPLayer];
    [pvpLayer release];
    
    playerTeam = team;
    
    // 设置玩家操控区域
    if (playerTeam == 0)
    {
        playerJewelController = [[JewelController alloc] initWithJewelBoard:pvpLayer.player1JewelPanel.jewelBoard operatorUserId:[GameController sharedController].player.userId];
        [playerJewelController.board active];
        
        // 设置对手操控区域
        opponentJewelController = [[JewelController alloc] initWithJewelBoard:pvpLayer.player2JewelPanel.jewelBoard operatorUserId:opponentUser.userId];
    }
    else
    {
        playerJewelController = [[JewelController alloc] initWithJewelBoard:pvpLayer.player2JewelPanel.jewelBoard operatorUserId:[GameController sharedController].player.userId];
        [playerJewelController.board active];
        
        // 设置对手操控区域
        opponentJewelController = [[JewelController alloc] initWithJewelBoard:pvpLayer.player1JewelPanel.jewelBoard operatorUserId:opponentUser.userId];
    }

    // 显示战斗场景
    fightController = [[FightController alloc] initWithFightPanel:pvpLayer.fightPanel];
    
    // 设置战斗背景
    [fightController setFightStreet:streetId];
    
}

/// 开始战斗
-(void) startFight
{
    newState = kPvpFightStatePlay;
    
    [self registerServerListener];
    [self registerMessageListener];
    
    // 开始
    [fightController start];
}

-(void) exitFight
{
    [self unregisterServerListener];
    [self unregisterMessageListener];
}

#pragma mark -
#pragma mark Server Command Listener

-(void) registerServerListener
{
    GameServer *server = [GameController sharedController].server;
    
    // 侦听交换宝石
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_SWAP_JEWELS listener:self];
    
    // 侦听添加新宝石
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_ADD_NEW_JEWELS listener:self];
    
    // 侦听死局
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_DEAD_JEWELS listener:self];

    // 侦听怒气和血条的改变
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_CHANGE_INFO listener:self];

    // 侦听攻击
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_ATTACK listener:self];
    
}

-(void) unregisterServerListener
{
    GameServer *server = [GameController sharedController].server;
    
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_SWAP_JEWELS listener:self];
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_ADD_NEW_JEWELS listener:self];
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_DEAD_JEWELS listener:self];
    
    // 取消侦听怒气和血条的改变
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_CHANGE_INFO listener:self];
    
    // 取消侦听攻击
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_ATTACK listener:self];
}


-(void) responseWithActionId:(int)actionId object:(id)obj
{
    switch (actionId)
    {
            
            // 交换宝石
        case SERVER_ACTION_PVP_SWAP_JEWELS:
        {
            CCArray *params = (CCArray*)obj;
            long userId = [[params objectAtIndex:0] longValue];
            long actId = [[params objectAtIndex:1] longValue];
            NSString *jewel1 = [params objectAtIndex:2];
            NSString *jewel2 = [params objectAtIndex:3];
            [self swapJewelWithUserId:userId actionId:actId jewel1:jewel1 jewel2:jewel2];
            break;
        }
        // 添加新宝石
        case SERVER_ACTION_PVP_ADD_NEW_JEWELS:
        {
            NewJewelsCommandData *data = (NewJewelsCommandData*)obj;
            if (data.userId == playerJewelController.userId)
            {
                [playerJewelController addJewelVoList:data.jewelVoList];
                
                // 记录从请求消除宝石到响应宝石所花总时间
                requestTotalCost = [[NSDate date] timeIntervalSince1970] - requestStartTime;
            }
            else
            {
                [opponentJewelController newJewelVoList:data.jewelVoList];
            }
            break;
        }
        case SERVER_ACTION_PVP_DEAD_JEWELS:
        {
            DeadJewelsCommandData *data = (DeadJewelsCommandData*)obj;
            if (data.userId == playerJewelController.userId)
            {
                [playerJewelController newJewelVoList:data.jewelVoList];
            }
            else
            {
                [opponentJewelController newJewelVoList:data.jewelVoList];
            }
            
            break;
        }
            
    }
}

#pragma mark -
#pragma mark Message Listener

/// 注册消息侦听
-(void) registerMessageListener
{
    GameMessageDispatcher *messageDispatcher = [GameMessageDispatcher sharedDispatcher];
    [messageDispatcher addListenerWithMessageId:JEWEL_MESSAGE_SWAP_JEWELS listener:self];
    [messageDispatcher addListenerWithMessageId:JEWEL_MESSAGE_ELIMINATE_JEWELS listener:self];
    [messageDispatcher addListenerWithMessageId:JEWEL_MESSAGE_DEAD listener:self];
    
    
    
}

/// 取消消息侦听
-(void) unregisterMessageListener
{
    GameMessageDispatcher *messageDispatcher = [GameMessageDispatcher sharedDispatcher];
    [messageDispatcher removeListenerWithMessageId:JEWEL_MESSAGE_SWAP_JEWELS listener:self];
    [messageDispatcher removeListenerWithMessageId:JEWEL_MESSAGE_ELIMINATE_JEWELS listener:self];
    [messageDispatcher removeListenerWithMessageId:JEWEL_MESSAGE_DEAD listener:self];
    
}

-(void) handleMessageWithSender:(id)sender messageId:(int)messageId object:(id)obj
{
    switch (messageId)
    {
            
        // 交换宝石
        case JEWEL_MESSAGE_SWAP_JEWELS:
        {
            JewelSwapMessageData *data = (JewelSwapMessageData*)obj;
            
            // 通知服务器端
            [[GameController sharedController].server.pvpCommand requestSwapJewelWithActionId:1 jewelGlobalId1:data.jewelGlobalId1 jewelGlobalId2:data.jewelGlobalId2];
            break;
        }
        // 宝石消除
        case JEWEL_MESSAGE_ELIMINATE_JEWELS:
        {
            JewelEliminateMessageData *data = (JewelEliminateMessageData*)obj;
            
            // 通知服务器端消除宝石
            if (data.userId == [GameController sharedController].player.userId)
            {
                // 记录请求时间
                requestTotalCost = 0;
                requestStartTime = [[NSDate date] timeIntervalSince1970];
                
                [[GameController sharedController].server.pvpCommand requestEliminateWithActionId:1 continueEliminate:0 eliminateGroup:data.eliminateGroup];
                
                // 做个弊,测试下攻击
                AttackVo *av = [[[AttackVo alloc] init] autorelease];
                av.skillId = 1;
                av.actorGlobalId = 1;
                av.targetGlobalId = 4;
                FightAttackAction *action = [[FightAttackAction alloc] initWithFightField:fightController.fightField attackVo:av];
                [fightController queueAction:action top:NO];
                [action release];
            }
            
            break;
        }
        // 宝石死局
        case JEWEL_MESSAGE_DEAD:
        {
            JewelMessageData *data = (JewelMessageData*)obj;
            
            // 通知服务器端死局宝石
            if (data.userId == [GameController sharedController].player.userId)
            {
                long actionId = [[NSDate date] timeIntervalSince1970];
                [[GameController sharedController].server.pvpCommand requestDeadWithActionId:actionId];
            }
            
            break;
        }
    }
}




@end
