//
//  FightCommand.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "BaseCommand.h"

@class GemVo,FighterVo,AttackVo;

@interface FightCommand : BaseCommand


/// 封装宝石信息
+(void) populateJewelVo:(GemVo*)jewel data:(ServerDataDecoder*)data;

/// 封装战士信息
+(void) populateFighterVo:(FighterVo*)fighter data:(ServerDataDecoder*)data;

/// 封装攻击信息
+(void) populateAttackVo:(AttackVo*)av data:(ServerDataDecoder*)data;

@end
