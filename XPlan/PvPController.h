//
//  FightController.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

#define kPvPStateLoading 0 // 加载数据中
#define kPvPStateFight 1 // 游戏中

@class PvPScene,UserInfo,HeroVo,PvPLoadingController,PvPFightController;

/// PvP战斗总控制器 (MVC框架的C)
@interface PvPController : NSObject
{
    PvPScene *scene; // 所处场景
    PvPLoadingController *loadingController; // 加载管理器
    PvPFightController *fightController; // 战斗管理器
    
    int state; // 状态
    int newState; // 新状态
    
}

/// 所处场景
@property (readonly,nonatomic) PvPScene *scene;

/// 加载控制器
@property(readonly,nonatomic) PvPLoadingController *loadingController;

/// 战斗控制器
@property (readonly,nonatomic) PvPFightController *fightController;

/// 游戏状态
@property (readwrite,nonatomic) int state;

@property (readwrite,nonatomic) int newState;

/// 初始化
-(id) initWithScene:(PvPScene*)s;

/// 初始化
-(void) initialize;

/// 逻辑更新
-(void) update:(ccTime)delta;

#pragma mark -
#pragma mark Loading

/// 开始加载
-(void) enterLoading;

@end
