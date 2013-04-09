//
//  FightScene.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "BaseCommand.h"

#define kPvPFightStateLoading 0 // PvP战斗状态: 加载数据
#define kPvPFightStatePlay 1 // PvP战斗状态: 游戏模式
#define kTagPvPFightLoadingLayer 100 // pvp加载层
#define kTagPvPFightLayer 101 // pvp战斗层
#define kTagPvPHudLayer 102 // pvp Hud层

@class PvPFightController,UserInfo;

/// 战斗场景
@interface PvPFightScene : CCScene
{
    PvPFightController *controller; // 控制器
    UserInfo *oppUser; // 对手用户
    CCArray *oppFightHeroList; // 对手出战英雄
    int state;
}

/// pvp战斗控制器
@property (readonly,nonatomic) PvPFightController *controller;

/// 对手用户信息
@property (readwrite,nonatomic,retain) UserInfo *oppUser;

/// 对手出战英雄
@property (readonly,nonatomic) CCArray *oppFightHeroList;

-(void) initialize;

/// 变更状态
-(void) changeState:(int)newState;

/// 开始加载
-(void) enterLoading;

/// 开始战斗
-(void) enterFight;

@end
