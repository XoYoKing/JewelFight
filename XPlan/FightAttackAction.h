//
//  BattleAttackAction.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAction.h"

// 攻击状态
#define kFightAttackStatePrepare 0 // 移动前动画
#define kFightAttackStateMoving 1 // 移到攻击位置
#define kFightAttackStateLighting 2 // 闪烁状态
#define kFightAttackStateBeforeAttack 3 // 攻击准备
#define kFightAttackStateAttacking 4 // 攻击
#define kFightAttackStateWin 5 // 胜利状态
#define kFightAttackStateRetreat 6 // 撤退,返回移动前位置
#define kFightAttackStateOver 7 // 攻击结束

@class FighterSprite,AttackVo;

/// 攻击指令
@interface FightAttackAction : FightAction
{
    AttackVo *attackVo; // 攻击数据对象
    int skillId; // 技能标识
    int state; // 状态
    int newState; // 新状态
}

/// 初始化攻击
-(id) initWithFightField:(FightField *)f attackVo:(AttackVo*)av;





@end
