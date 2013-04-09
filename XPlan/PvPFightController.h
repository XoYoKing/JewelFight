//
//  FightController.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "CommandListener.h"

#define kPvPFightStateLoading 0 // 加载数据中
#define kPvPFightStateFight 1 // 游戏中

@class ViewStonePanel,PvPFightScene,DoStonePanel,UserInfo,HeroVo,PvPFighterPanel,PvPPortraitPanel;

/// 战斗控制器 (MVC框架的C)
@interface PvPFightController : NSObject<CommandListener>
{
    PvPFightScene *scene; // 所处场景
    DoStonePanel *playerStonePanel; // 玩家宝石面板
    ViewStonePanel *opponentStonePanel; //对手宝石面板
    PvPFighterPanel *fighterPanel; // PvP战士对战面板
    PvPPortraitPanel *portraitPanel; // pvp战士头像面板
    
    // 玩家出战英雄信息
    CCArray *playerFighters; // 玩家出战战士集合
    
    // 战斗对手信息
    UserInfo *opponentUser; // 战斗对手用户信息
    CCArray *opponentFighters; // 右边角色所有英雄的信息
    
    int state; // 状态
    int newState; // 新状态
    
}

/// 游戏状态
@property (readwrite,nonatomic) int state;

@property (readwrite,nonatomic) int newState;

/// 玩家宝石面板
@property (readonly,nonatomic) DoStonePanel *playerStonePanel;

/// 对手宝石面板
@property (readonly,nonatomic) ViewStonePanel *opponentStonePanel;

/// 对战面板
@property (readonly,nonatomic) PvPFighterPanel *fighterPanel;

/// 战士头像面板
@property (readonly,nonatomic) PvPPortraitPanel *portraitPanel;

/// 初始化
-(id) initWithScene:(PvPFightScene*)s;

/// 初始化
-(void) initialize;

/// 逻辑更新
-(void) update:(ccTime)delta;

/// 开始加载
-(void) enterLoading;

/// 加载完成
-(void) loadingDone;

/// 准备好战斗
-(void) readyToFight;


@end
