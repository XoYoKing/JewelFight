//
//  FightLayer.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "JewelPanel.h"
#import "FightPanel.h"
#import "PvPPlayerJewelPanel.h"
#import "PvPOpponentJewelPanel.h"
#import "FightPortrait.h"

@class PvPScene,PvPHudLayer;

/// 战斗层
@interface PvPLayer : CCLayer
{
    PvPPlayerJewelPanel *player1JewelPanel; // 玩家宝石面板
    PvPOpponentJewelPanel *player2JewelPanel; // 对手宝石面板
    FightPanel *fightPanel; // 战斗面板
}

/// 玩家1宝石面板
@property (readonly,nonatomic) PvPPlayerJewelPanel *player1JewelPanel;

/// 玩家2宝石面板
@property (readonly,nonatomic) PvPOpponentJewelPanel *player2JewelPanel;

/// 战斗面板
@property (readonly,nonatomic) FightPanel *fightPanel;

/// 初始化
-(void) initiaize;

/// 获取所处PvP战斗场景
-(PvPScene*) getFightScene;

/// 获取PvP战斗Hud层
-(PvPHudLayer*) getHudLayer;

@end
