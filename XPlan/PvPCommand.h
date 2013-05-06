//
//  FightCommand.h
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "BaseCommand.h"

@class FighterVo,AttackVo;

///pvp 对战 命令
@interface PvPCommand : BaseCommand

#pragma mark -
#pragma mark Request

/// 请求开始PvP
-(void) requestPvP;

/// 加载完毕,准备战斗
-(void) requestFight;

/// 请求开战
-(void) requestFightStart;

/// 请求交换宝石
-(void) requestSwapJewelWithActionId:(long)actionId jewelGlobalId1:(int)jewelGlobalId1 jewelGlobalId2:(int)jewelGlobalId2;


/// 死局, 请求新的宝石队列
-(void) requestDeadWithActionId:(long)actionId;


/// 操作分数
-(void) requestOperate:(double)operate value:(int)value;

/// 请求攻击
-(void) requestAttack:(int)value;

/// 消除宝石
-(void) requestEliminateWithActionId:(long)actionId continueEliminate:(int)continueEliminate eliminateGroup:(NSMutableArray*)group;

/// 请求时装技能
-(void) requestExSkill:(int)skillId;

/// 请求退出战斗
-(void) requestQuitFight;


@end
