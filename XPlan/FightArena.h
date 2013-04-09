//
//  FightGround.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class PvPFighter;
/// 战斗场地
@interface FightArena : CCNode
{
    CCArray *heros; // 所有英雄的信息
    CCArray *actions; // 所有攻击指令
    
}

/// 基于标识获取战场演员
-(PvPFighter*) getActorById:(NSString*)actorId;


@end
