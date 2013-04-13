//
//  PvPFightManager.h
//  XPlan
//
//  Created by Hex on 4/10/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "CommandListener.h"
#import "PvPController.h"

/// PvP 战斗控制器
@interface PvPFightManager : NSObject<CommandListener>
{
    PvPController *controller;
    
    // 玩家出战英雄信息
    CCArray *playerFighterVos; // 玩家出战战士集合
    CCArray *playerJewelVos; // 玩家宝石集合
    
    // 战斗对手信息
    UserInfo *opponentUser; // 战斗对手用户信息
    CCArray *opponentFighterVos; // 对手角色所有英雄的信息
    CCArray *opponentJewelVos; // 对手宝石集合
}

/// 初始化
-(id) initWithPvPController:(PvPController*)contr;

/// 接收玩家出战英雄信息和对手出战英雄信息
-(void) handlePlayerFighters:(CCArray*)pf opponentUser:(UserInfo*)o opponentFighters:(CCArray*)of;

/// 接收玩家宝石信息和对手宝石信息
-(void) handlePlayerJewels:(CCArray*)ps opponentJewels:(CCArray*)os;

/// 进入战斗
-(void) enterFight;

/// 开始战斗
-(void) startFight;

/// 退出战斗
-(void) exitFight;


/// 逻辑更新
-(void) update:(ccTime)delta;

@end
