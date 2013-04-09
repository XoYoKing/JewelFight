//
//  FightController.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightController.h"
#import "GameController.h"
#import "PvPFightScene.h"
#import "PvPFightLayer.h"
#import "PvPFightHudLayer.h"
#import "GameController.h"
#import "PlayerInfo.h"
#import "FighterVo.h"
#import "GameServer.h"
#import "Constants.h"
#import "DoStonePanel.h"
#import "ViewStonePanel.h"
#import "HeroVo.h"
#import "FighterVo.h"
#import "FighterUI.h"

@interface PvPFightController()
{
}

@end

@implementation PvPFightController

@synthesize state,newState;

-(id) initWithScene:(PvPFightScene *)s
{
    if ((self = [super init]))
    {
        scene = s;
        state = -1;
        newState = -1;
        
        [self initialize];
    }
    
    return self;
}

-(void) dealloc
{
    [self unregisterFightListener];
    [playerFighters release];
    [opponentUser release];
    [opponentFighters release];
    [super dealloc];
}

-(void) initialize
{
    // 开始加载
    [self enterLoading];
}

#pragma mark -
#pragma mark Loading

/// 开始加载
-(void) enterLoading
{
    self.state = kPvPFightStateLoading;
    
    // 显示加载页面
    [scene startLoading];
    
    // 注册加载侦听
    [self registerLoadingListener];
    
   }

/// 加载完成
-(void) loadingDone
{
    // 离线模式
    if (OFFLINE_MODE == 1)
    {
        // 离线模式,测试用
        //
        [self enterFight];
        return;
    }
    /// 加载完成,请求战斗
    [[GameController sharedController].server.fightCommand requestStartFight];
}

-(void) registerLoadingListener
{
    GameServer *server = [GameController sharedController].server;
    
    // 侦听获取对手信号
    [server.fightCommand addListenerWithActionId:SERVER_ACTION_ID_PVP_OPPONENT_AND_FIGHTERS listener:self];
    
    // 侦听可以战斗信号
    [server.fightCommand addListenerWithActionId:SERVER_ACTION_ID_PVP_START_ENABLE listener:self];
    
    // 侦听开始战斗信号
    [server.fightCommand addListenerWithActionId:SERVER_ACTION_ID_PVP_START_FIGHT listener:self];
}

-(void) unregisterLoadingListener
{
    GameServer *server = [GameController sharedController].server;
    
    // 取消侦听对手信号
    [server.fightCommand removeListenerWithActionId:SERVER_ACTION_ID_PVP_OPPONENT_AND_FIGHTERS listener:self];
    
    // 取消侦听可以战斗信号
    [server.fightCommand removeListenerWithActionId:SERVER_ACTION_ID_PVP_START_ENABLE listener:self];
    
    // 取消侦听开始战斗信号
    [server.fightCommand removeListenerWithActionId:SERVER_ACTION_ID_PVP_START_FIGHT listener:self];
}

#pragma mark -
#pragma mark Fight

/// 开始战斗
-(void) enterFight
{
    // 取消加载侦听
    [self unregisterLoadingListener];
    
    // 显示战斗画面
    [scene startFight];
    
    // 侦听战斗信号
    [self registerFightListener];
}



-(void) update:(ccTime)delta
{
    
}

/// 处理玩家出战英雄信息和对手出战英雄信息
-(void) handlePlayerFighters:(CCArray*)pf opponentUser:(UserInfo*)o opponentFighters:(CCArray*)of
{
    // 保存信息
    playerFighters = [pf retain];
    opponentUser = [o retain];
    opponentFighters = [of retain];
    
}


/// 准备战斗
-(void) readyToFight
{
    // 关联面板引用
    playerStonePanel = (DoStonePanel*)[self getFightLayer].leftStonePanel.stonePanel;
    opponentStonePanel = (ViewStonePanel*)[self getFightLayer].rightStonePanel.stonePanel;
    
    // 关联战斗UI
    fighterUI = (FighterUI*)[self getFightLayer].fighterUI;
    
    // 初始化宝石面板
    
    // 向服务器请求开始战斗
    
}

-(PvPFightLayer*) getFightLayer
{
    return (PvPFightLayer*)[scene getChildByTag:kTagPvPFightLayer];
}

-(PvPFightHudLayer*) getHudLayer
{
    return (PvPFightHudLayer*)[scene getChildByTag:kTagPvPHudLayer];
}


-(void) changeState:(int)value
{
    state = newState = value;
}

/// 加载资源
-(void) loadResources
{
    // 向服务器请求开战
    
    // 预加载资源
}




// 注册侦听
-(void) registerFightListener
{
    GameServer *server = [GameController sharedController].server;
    [server.gameCommand addListenerWithActionId:SERVER_ACTION_ID_STONE_COLUMN listener:self];
    
    
}

// 取消侦听
-(void) unregisterFightListener
{
    // 取消侦听
    [[GameController sharedController].server.gameCommand removeListenerWithActionId:SERVER_ACTION_ID_STONE_COLUMN listener:self];
    
}

-(void) responseWithActionId:(int)actionId object:(id)obj
{
    switch (actionId)
    {
        // 获取所有战斗英雄信息
        case SERVER_ACTION_ID_PVP_OPPONENT_AND_FIGHTERS:
        {
            // 转化为字典
            NSDictionary *data = (NSDictionary*)obj;
            CCArray *fighters = [data objectForKey:@"player_fighters"];
            UserInfo *oppUser = [data objectForKey:@"opponent_user"];
            CCArray *oppFighters = [data objectForKey:@"opponent_fighters"];
            [self handlePlayerFighters:fighters opponentUser:oppUser opponentFighters:oppFighters];
            break;
        }
            
        // PVP战斗服务器端准备完毕信号
        case SERVER_ACTION_ID_PVP_START_ENABLE:
        {
            // 请求开始战斗
            [[GameController sharedController].server.fightCommand requestStartFight];
            break;
        }
        case SERVER_ACTION_ID_PVP_START_FIGHT:
        {
            [self enterFight];
            break;
        }
        // 交换宝石
        case SERVER_ACTION_ID_SWAP_STONES:
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


/// 交换宝石
-(void) swapStoneWithUserId:(long)userId actionId:(long)actionId stone1:(NSString *)stone1 stone2:(NSString *)stone2
{
}

/// 开始战斗
-(void) initFight
{
    /*
    // 初始化顶层表现
    [topPortrait initPortraitWithLeftFighters:leftFighters rightFighters:rightFighters];
    [bottomUI initWithLeftFighter:leftFighters rightFighters:rightFighters];
    [fighterUI initWithLeftFighters:leftFighters rightFighters:rightFighters];
     */
}


@end
