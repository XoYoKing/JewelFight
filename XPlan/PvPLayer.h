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
#import "JewelPanel.h"
#import "PvPPlayerJewelPanel.h"
#import "PvPOpponentJewelPanel.h"
#import "PvPFighterPanel.h"
#import "PvPPortraitPanel.h"

@class PvPScene,PvPHudLayer;

/// 战斗层
@interface PvPLayer : CCLayer
{
    FightArena *arena; // 战斗竞技场
    PvPPlayerJewelPanel *playerJewelPanel; // 玩家宝石面板
    PvPOpponentJewelPanel *opponentJewelPanel; // 对手宝石面板
    PvPPortraitPanel *portraitPanel; // 战士信息面板
    PvPFighterPanel *fighterPanel; // 战士战斗界面
    
}

@property (readonly,nonatomic) PvPPlayerJewelPanel *playerJewelPanel;

@property (readonly,nonatomic) PvPOpponentJewelPanel *opponentJewelPanel;

@property (readonly,nonatomic) PvPPortraitPanel *portraitPanel;

@property (readonly,nonatomic) PvPFighterPanel *fighterPanel;

/// 初始化
-(void) initiaize;

/// 获取所处PvP战斗场景
-(PvPScene*) getFightScene;

/// 获取PvP战斗Hud层
-(PvPHudLayer*) getHudLayer;

@end
