//
//  BattleActor.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class FighterVo;

#define kFighterStateIdle 0 // 空闲

/// 战场战士 (英雄)
@interface FightActor : CCNode
{
    NSString *actorId; // 战士标识
    FighterVo *vo; // 战士数据对象
    
    int state; // 状态
}

@property (readonly,nonatomic) NSString *actorId;

/// 战士数据
@property (readonly,nonatomic) FighterVo *vo;



@end
