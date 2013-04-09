//
//  BattleAttackAction.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAction.h"

@class PvPFighter;

/// 攻击指令
@interface FightAttackAction : FightAction
{
    
}

-(id) initWithFightGround:(FightArena*)_ground actor:(PvPFighter*)_actor target:(PvPFighter*)_target move:(int)_move distance:(float)_distance time:(float)_time;



@end
