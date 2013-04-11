//
//  FightLayer.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "FightArena.h"
#import "StonePanel.h"
#import "FightStonePanel.h"
#import "PvPPlayerStonePanel.h"
#import "PvPOpponentStonePanel.h"
#import "PvPFighterPanel.h"
#import "PvPPortraitPanel.h"

@class PvPScene,PvPHudLayer;

/// 战斗层
@interface PvPLayer : CCLayer
{
    FightArena *arena; // 战斗竞技场
    PvPPlayerStonePanel *playerStonePanel; // 玩家宝石面板
    PvPOpponentStonePanel *opponentStonePanel; // 对手宝石面板
    PvPPortraitPanel *portraitPanel; // 战士信息面板
    PvPFighterPanel *fighterPanel; // 战士战斗界面
    
}

@property (readonly,nonatomic) PvPPlayerStonePanel *playerStonePanel;

@property (readonly,nonatomic) PvPOpponentStonePanel *opponentStonePanel;

@property (readonly,nonatomic) PvPPortraitPanel *portraitPanel;

@property (readonly,nonatomic) PvPFighterPanel *fighterPanel;

/// 初始化
-(void) initiaize;

/// 获取所处PvP战斗场景
-(PvPScene*) getFightScene;

/// 获取PvP战斗Hud层
-(PvPHudLayer*) getHudLayer;

@end
