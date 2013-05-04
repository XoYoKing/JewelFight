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
@interface PvPFightCommand : BaseCommand

#pragma mark -
#pragma mark Request

/// 请求开战
-(void) requestStartFight;

/// 请求交换宝石
-(void) requestSwapStoneWithActionId:(long)actionId stoneId1:(NSString*)stoneId1 stoneId2:(NSString*)stoneId2;


/// 死局, 请求新的宝石队列
-(void) requestDeadWithActionId:(long)actionId;

/// 加载完毕,准备战斗
-(void) requestFight;

/// 操作分数
-(void) requestOperate:(double)operate value:(int)value;

/// 请求攻击
-(void) requestAttack:(int)value;

/// 消除宝石
-(void) requestDisposeWithActionId:(long)actionId continueDispose:(int)continueDispose disposeStoneIds:(CCArray*)disposeStoneIds;

/// 请求时装技能
-(void) requestExSkill:(int)skillId;

/// 请求退出战斗
-(void) requestQuitFight;


@end
