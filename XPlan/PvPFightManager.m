//
//  PvPFightManager.m
//  XPlan
//
//  Created by Hex on 4/10/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightManager.h"
#import "PvPController.h"
#import "DoStonePanel.h"
#import "ViewStonePanel.h"
#import "PvPFighterPanel.h"
#import "PvPPortraitPanel.h"
#import "PvPLayer.h"
#import "Constants.h"
#import "PvPScene.h"
#import "UserInfo.h"
#import "GameController.h"
#import "GameServer.h"

@interface PvPFightManager()
{
    PvPLayer *pvpLayer; // PVP页面
    DoStonePanel *playerStonePanel; // 玩家宝石面板
    ViewStonePanel *opponentStonePanel; //对手宝石面板
    PvPFighterPanel *fighterPanel; // PvP战士对战面板
    PvPPortraitPanel *portraitPanel; // pvp战士头像面板
}

@end

@implementation PvPFightManager

-(id) initWithPvPController:(PvPController *)contr
{
    if ((self = [super init]))
    {
        controller = contr;
    }
    
    return self;
}

-(void) dealloc
{
    [opponentUser release];
    [playerFighterVos release];
    [opponentStoneVos release];
    [playerStoneVos release];
    [opponentStoneVos release];
    
    [super dealloc];
}


/// 接收玩家出战英雄信息和对手出战英雄信息
-(void) handlePlayerFighters:(CCArray*)pf opponentUser:(UserInfo*)o opponentFighters:(CCArray*)of
{
    // 保存玩家和对手数据
    playerFighterVos = [pf retain];
    opponentUser = [o retain];
    opponentFighterVos = [of retain];
    
    // 显示战斗页面
    //[self enterFight];
}

-(void) handlePlayerStones:(CCArray*)ps opponentStones:(CCArray*)os
{
    // 保存宝石数据
    playerStoneVos = [ps retain];
    opponentStoneVos = [os retain];
    
    // 初始化玩家宝石列表
    [pvpLayer.playerStonePanel newStones:playerStoneVos];
    
    // 初始化对手宝石列表
    [pvpLayer.opponentStonePanel newStones:opponentStoneVos];
    
}

/// 进入战斗
-(void) enterFight
{
    // 显示战斗层
    pvpLayer = [[PvPLayer alloc] init];
    [controller.scene addChild:pvpLayer z:0 tag:kTagPvPLayer];
    [pvpLayer release];
    pvpLayer = (PvPLayer*)[controller.scene getChildByTag:kTagPvPLayer];
    
    // 设置战士信息
    [pvpLayer.playerStonePanel setFighter:[playerFighterVos objectAtIndex:0]];
    [pvpLayer.opponentStonePanel setOpponent:opponentUser];
    [pvpLayer.opponentStonePanel setFighter:[opponentFighterVos objectAtIndex:0]];
    
    // 设置宝石信息
    
}

-(void) exitFight
{
    
}

-(void) registerServerListener
{
    GameServer *server = [GameController sharedController].server;
    
    
    
    // 侦听交换宝石
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_SWAP_STONES listener:self];
    
    // 侦听添加新宝石
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_ADD_NEW_STONES listener:self];
    
    // 侦听死局
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_DEAD_STONE_COLUMN listener:self];

    // 侦听怒气和血条的改变
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_CHANGE_INFO listener:self];

    // 侦听攻击
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_ATTACK listener:self];
    
    
}

-(void) unregisterServerListener
{
    GameServer *server = [GameController sharedController].server;
    
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_SWAP_STONES listener:self];
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_ADD_NEW_STONES listener:self];
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_DEAD_STONE_COLUMN listener:self];
    
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
        case SERVER_ACTION_PVP_SWAP_STONES:
        {
            CCArray *params = (CCArray*)obj;
            long userId = [[params objectAtIndex:0] longValue];
            long actId = [[params objectAtIndex:1] longValue];
            NSString *stone1 = [params objectAtIndex:2];
            NSString *stone2 = [params objectAtIndex:3];
            [self swapStoneWithUserId:userId actionId:actId stone1:stone1 stone2:stone2];
            break;
        }
            
    }
}


@end
