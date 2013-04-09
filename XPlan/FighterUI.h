//
//  BattleActor.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "FightArena.h"

@class FighterVo;

#define kFighterStateIdle 0 // 空闲

#define kFighterSideLeft 0 // 站在左侧
#define kFighterSideRight 1 // 站在右侧

/// 战场战士 (英雄)
@interface FighterUI : CCNode
{
    NSString *actorId; // 战士标识
    FighterVo *vo; // 战士数据对象
    FightArena *arena; // 战场
    int side; // 站立位置
    int state; // 状态
}

@property (readonly,nonatomic) NSString *actorId;

/// 战士数据
@property (readonly,nonatomic) FighterVo *vo;

-(id) initWithArena:(FightArena*)theArena;


/// 攻击目标
-(void) attack:(FighterUI*)target;



@end
