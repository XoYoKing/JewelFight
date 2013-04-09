//
//  FightCommand.m
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightCommand.h"
#import "FighterVo.h"
#import "StoneVo.h"
#import "AttackVo.h"

@implementation FightCommand



/// 封装宝石信息
+(void) populateStoneVo:(StoneVo*)stone data:(ServerDataDecoder*)data
{
    stone.stoneId = [data readUTF];
    stone.type = [data readInt16];
    stone.state = [data readInt16];
}

/// 封装战士信息
+(void) populateFighterVo:(FighterVo*)fighter data:(ServerDataDecoder*)data
{
    fighter.heroId = [data readInt64];
    fighter.userId = fighter.heroId;
    fighter.team = [data readInt32];
    [data readByte];
    fighter.name = [data readUTF];
    fighter.sex = [data readInt16];
    fighter.head = fighter.fashion = [data readInt32];
    fighter.maxHp = [data readInt32];
    fighter.maxAnger = [data readInt32];
}

/// 封装攻击信息
+(void) populateAttackVo:(AttackVo*)av data:(ServerDataDecoder*)data
{
    av.actorId = [data readInt64];
    av.targetId = [data readInt64];
    av.skillId = [data readInt32];
    av.combos = [data readInt32];
    av.hurt = [data readInt32];
    av.dead = [data readBoolean];
}

@end
