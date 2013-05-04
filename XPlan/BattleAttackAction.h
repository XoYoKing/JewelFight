//
//  BattleAttackAction.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAction.h"

@class BattleActor;

/// 攻击指令
@interface BattleAttackAction : FightAction
{
    
}

-(id) initWithActor:(BattleActor*)_actor target:(BattleActor*)_target move:(int)_move distance:(float)_distance time:(float)_time;



@end
