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
#import "GameMessageListener.h"

#define kPvPFightStateLoading 0 // 加载中
#define kPvpFightStatePlay 1 // 游戏中

@class JewelController;

/// PvP 战斗控制器
@interface PvPFightController : NSObject<CommandListener,GameMessageListener>
{
    PvPController *controller; // 隶属总控
    JewelController *playerJewelController; // 玩家宝石控制器
    JewelController *opponentJewelController; // 对手宝石控制器
    
    // 玩家出战英雄信息
    CCArray *playerFighterVos; // 玩家出战战士集合
    
    // 战斗对手信息
    UserInfo *opponentUser; // 战斗对手用户信息
    CCArray *opponentFighterVos; // 对手出战战士集合
    CCArray *initOpponentJewelVos; // 对手宝石集合
    
    int state;
    int newState;
}

@property (readwrite,nonatomic) int state;
@property (readwrite,nonatomic) int newState;

/// 初始化
-(id) initWithPvPController:(PvPController*)contr;

/// 接收玩家出战英雄信息和对手出战英雄信息
-(void) handlePlayerFighters:(CCArray*)pf opponentUser:(UserInfo*)o opponentFighters:(CCArray*)of;

/// 接收玩家宝石信息和对手宝石信息
-(void) handlePlayerJewels:(CCArray*)ps opponentJewels:(CCArray*)os;

/// 初始化战斗
-(void) initFight;

/// 开始战斗
-(void) startFight;

/// 退出战斗
-(void) exitFight;


/// 逻辑更新
-(void) update:(ccTime)delta;

@end
