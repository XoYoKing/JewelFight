//
//  PvPLoadingManager.m
//  XPlan
//
//  Created by Hex on 4/10/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPLoadingController.h"
#import "PvPFightController.h"
#import "PvPScene.h"
#import "LoadingLayer.h"
#import "PvPController.h"
#import "GameController.h"
#import "GameServer.h"
#import "Constants.h"

@interface PvPLoadingController()
{
    LoadingLayer *loadingLayer;
    int totalSteps; // 全部步骤
    int step; // 步骤
}

/// 开始加载
-(void) showLoadingLayer;

/// 退出加载
-(void) closeLoadingLayer;

@end

@implementation PvPLoadingController

-(id) initWithPvPController:(PvPController *)contr
{
    if ((self = [super init]))
    {
        controller = contr;
        step = 0;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

/// 开始加载
-(void) enterLoading
{
    // 显示加载场景
    [self showLoadingLayer];

    
    // 注册加载侦听
    [self registerServerListener];
    
    // 发送请求PVP
    [[GameController sharedController].server.pvpCommand requestPvP];
    
    
}

/// 退出加载
-(void) exitLoading
{
    //
    [self closeLoadingLayer];
}




/// 显示加载层
-(void) showLoadingLayer
{
    loadingLayer = [[LoadingLayer alloc] init];
    [controller.scene addChild:loadingLayer z:99 tag:kTagPvPLoadingLayer];
}

/// 关闭加载层
-(void) closeLoadingLayer
{
    // 删掉加载层
    [controller.scene removeChildByTag:kTagPvPLoadingLayer];
    [loadingLayer release];
    loadingLayer = nil;
}

-(void) update:(ccTime)delta
{
    
}

-(void) registerServerListener
{
    GameServer *server = [GameController sharedController].server;
    
    // 侦听获取对手信号
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_OPPONENT_AND_FIGHTERS listener:self];
    
    // 侦听可以战斗信号
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_INIT_JEWELS listener:self];
    
    // 侦听开始战斗信号
    [server.pvpCommand addListenerWithActionId:SERVER_ACTION_PVP_FIGHT_START listener:self];
}

-(void) unregisterServerListener
{
    GameServer *server = [GameController sharedController].server;
    
    // 取消侦听对手信号
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_OPPONENT_AND_FIGHTERS listener:self];
    
    // 取消侦听可以战斗信号
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_INIT_JEWELS listener:self];
    
    // 取消侦听开始战斗信号
    [server.pvpCommand removeListenerWithActionId:SERVER_ACTION_PVP_FIGHT_START listener:self];
}

-(void) responseWithActionId:(int)actionId object:(id)obj
{
    switch (actionId)
    {
        // 收到对手信息和对手英雄信息
        case SERVER_ACTION_PVP_OPPONENT_AND_FIGHTERS:
        {
            NSDictionary *dict = (NSDictionary*)obj;
            CCArray *playerFighters = [dict objectForKey:@"player_fighters"];
            UserInfo *opponentUser = [dict objectForKey:@"opponent_user"];
            CCArray *opponentFighters = [dict objectForKey:@"opponent_fighters"];
            
            // 初始化战斗
            [controller.fightController initFight];
            
            //
            [controller.fightController handlePlayerFighters:playerFighters opponentUser:opponentUser opponentFighters:opponentFighters];
            
            // 加载页面完成,请求战斗
            [[GameController sharedController].server.pvpCommand requestFight];
            
            // 执行到下一步
            step++;
            [loadingLayer setPercent:(float)step/3.0f * 100.0f];
            break;
        }
        // 初始化宝石列表
        case SERVER_ACTION_PVP_INIT_JEWELS:
        {
            NSDictionary *dict = (NSDictionary*)obj;
            CCArray *playerJewels = [dict objectForKey:@"player_jewels"];
            CCArray *opponentJewels = [dict objectForKey:@"opponent_jewels"];
            
            // 设置玩家宝石和对手宝石
            [controller.fightController handlePlayerJewels:playerJewels opponentJewels:opponentJewels];
            
            step++;
            [loadingLayer setPercent:100.0f];
            
            // 请求开始战斗
            [[GameController sharedController].server.pvpCommand requestFightStart];
            
            break;
        }
            
        // 服务器同意开战
        case SERVER_ACTION_PVP_FIGHT_START:
        {
            
            // 关闭加载层
            [self closeLoadingLayer];
            
            // 关闭侦听
            [self unregisterServerListener];
            
            // 变更总控状态为战斗模式
            controller.newState = kPvPStateFight;
            break;
        }
    }
}


/// 全部加载完,才显示
-(void) loadingDone
{
    // 删除加载层,显示战斗层
    [self closeLoadingLayer];
    
    // 变更总控制器状态为战斗状态
    controller.newState = kPvPStateFight;
}


@end

