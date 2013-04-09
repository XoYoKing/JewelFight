//
//  BattleAttackAction.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAttackAction.h"

@interface FightAttackAction()
{
    int state; // 游戏状态
    int newState; // 新游戏状态
}

@end

@implementation FightAttackAction

-(id) initWithFightGround:(FightArena *)_ground actor:(FighterUI *)_actor target:(FighterUI *)_target move:(int)_move distance:(float)_distance time:(float)_time
{
    if ((self = [super initWithFightGround:_ground name:@"Attack"]))
    {
        actor = _actor;
        target = _target;
        move = _move;
        distance = _distance;
        time = _time;
    }
    
    return self;
}

-(void) start
{
    
}

@end
