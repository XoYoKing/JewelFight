//
//  BattleAttackAction.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAction.h"

// 攻击状态
#define kFightAttackStatePrepare 0
#define kFightAttackStateRunning 1 //  奔跑中
#define kFightAttackStateAttacking 2 // 攻击中
#define kFightAttackStateAttacked 3 // 攻击完毕
#define kFightAttackStateBack 4 // 回到原位
#define kFightAttackStateOver 5 // 攻击结束

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
