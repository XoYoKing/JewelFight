//
//  BattleAttackAction.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAction.h"

@class FighterSprite;

/// 攻击指令
@interface FightAttackAction : FightAction
{
    int skillId; // 使用技能标识
    int state;
    int newState;
}

-(id) initWithFightField:(FightField *)f actor:(FighterSprite*)a;





@end
