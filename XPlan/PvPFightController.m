//
//  PvPFightManager.m
//  XPlan
//
//  Created by Hex on 4/10/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightController.h"
#import "PvPController.h"
#import "DoJewelPanel.h"
#import "ViewJewelPanel.h"
#import "PvPFighterPanel.h"
#import "PvPPortraitPanel.h"
#import "PvPLayer.h"
#import "Constants.h"
#import "PvPScene.h"
#import "UserInfo.h"
#import "GameController.h"
#import "GameServer.h"
#import "JewelController.h"
#import "JewelAddAction.h"

@interface PvPFightController()
{
    PvPLayer *pvpLayer; // PVP页面
    DoJewelPanel *playerJewelPanel; // 玩家宝石面板
    ViewJewelPanel *opponentJewelPanel; //对手宝石面板
    PvPFighterPanel *fighterPanel; // PvP战士对战面板
    PvPPortraitPanel *portraitPanel; // pvp战士头像面板
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
    [opponentUser release];
    [playerFighterVos release];
    
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
    }
}

-(void) changeState:(int)s
{
    self.state = self.newState = s;
}


/// 接收玩家出战英雄信息和对手出战英雄信息
-(void) handlePlayerFighters:(CCArray*)pf opponentUser:(UserInfo*)o opponentFighters:(CCArray*)of
{
    // 保存玩家和对手数据
    playerFighterVos = [pf retain];
    opponentUser = [o retain];
    opponentFighterVos = [of retain];
    
    // 设置战士信息
    [pvpLayer.playerJewelPanel setFighter:[playerFighterVos objectAtIndex:0]];
    [pvpLayer.opponentJewelPanel setOpponent:opponentUser];
    [pvpLayer.opponentJewelPanel setFighter:[opponentFighterVos objectAtIndex:0]];
}

-(void) handlePlayerJewels:(CCArray*)ps opponentJewels:(CCArray*)os
{
    [playerJewelController newJewelVoList:ps];
    [opponentJewelController newJewelVoList:os];
}

/// 进入战斗
-(void) initFight
{
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"jewel_resources.plist"];
    
    // 显示战斗层
    pvpLayer = [[PvPLayer alloc] init];
    [controller.scene addChild:pvpLayer z:0 tag:kTagPvPLayer];
    [pvpLayer release];
    
    
    playerJewelController = [[JewelController alloc] initWithJewelPanel:pvpLayer.playerJewelPanel.jewelPanel];
    opponentJewelController = [[JewelController alloc] initWithJewelPanel:pvpLayer.opponentJewelPanel.jewelPanel];
    
}

/// 开始战斗
-(void) startFight
{
    newState = kPvpFightStatePlay;
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
            NSString *jewel1 = [params objectAtIndex:2];
            NSString *jewel2 = [params objectAtIndex:3];
            [self swapJewelWithUserId:userId actionId:actId jewel1:jewel1 jewel2:jewel2];
            break;
        }
            
    }
}


@end
