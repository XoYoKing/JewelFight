//
//  FightCommand.m
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightCommand.h"
#import "FighterVo.h"
#import "JewelVo.h"
#import "AttackVo.h"

@implementation FightCommand



/// 封装宝石信息
+(void) populateJewelVo:(JewelVo*)jewel data:(ServerDataDecoder*)data
{
    jewel.globalId = [data readInt32];
    jewel.jewelId = [data readInt32];
    jewel.jewelType = [data readInt32];
    jewel.special = [data readInt32];
    int coordX = [data readInt32];
    int coordY = [data readInt32];
    jewel.coord = ccp(coordX,coordY);
    jewel.state = [data readInt16];
}

/// 封装战士信息
+(void) populateFighterVo:(FighterVo*)fighter data:(ServerDataDecoder*)data
{    
    fighter.globalId = [data readInt64];
    fighter.heroId = [data readInt64];
    fighter.heroType = [data readInt32]; // 英雄类型
    fighter.userId = [data readInt64];
    fighter.team = [data readInt32];
    fighter.name = [data readUTF];
    fighter.sex = [data readInt16];
    fighter.head = [data readInt32];
    fighter.fashion = [data readInt32];
    fighter.maxLife = [data readInt32];
    fighter.maxAnger = [data readInt32];
}

/// 封装攻击信息
+(void) populateAttackVo:(AttackVo*)av data:(ServerDataDecoder*)data
{
    av.actorGlobalId = [data readInt64]; // 攻击者标识
    av.targetGlobalId = [data readInt64]; // 被攻击者标识
    av.skillId = [data readInt32]; // 技能标识
    av.combos = [data readInt32]; // 连击计算
    av.hurt = [data readInt32]; // 伤害值
    av.dead = [data readBoolean]; // 是否死亡
}

@end
