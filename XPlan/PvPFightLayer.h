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

@class PvPFightScene,PvPFightHudLayer,FighterUI;



/// 战斗层
@interface PvPFightLayer : CCLayer
{
    FightArena *arena; // 战斗竞技场
    FightStonePanel *leftStonePanel; // 左侧宝石面板
    FightStonePanel *rightStonePanel; // 右侧宝石面板
    FighterUI *fighterUI; // 战士战斗界面
    
}

@property (readonly,nonatomic) FightStonePanel *leftStonePanel;

@property (readonly,nonatomic) FightStonePanel *rightStonePanel;

@property (readonly,nonatomic) FighterUI *fighterUI;

/// 初始化
-(void) initiaize;

/// 获取所处PvP战斗场景
-(PvPFightScene*) getFightScene;

/// 获取PvP战斗Hud层
-(PvPFightHudLayer*) getHudLayer;

@end
