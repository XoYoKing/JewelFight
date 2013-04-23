//
//  AttackData.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 攻击数据
@interface AttackVo : NSObject
{
    int skillId; // 关联技能标识
    BOOL isTarget; // 是否有作用目标, YES:有 NO:目标点
    long actorGlobalId; // 主演英雄标识
    long targetGlobalId; // 目标英雄标识
    CGPoint targetPos; // 目标点坐标
    int combos; // 连击
    int hurt; // 伤害
    BOOL dead; // 是否死亡
    CCArray *damages; // 技能伤害数据
}

/// 关联技能标识
@property (readwrite,nonatomic) int skillId;

/// 是否有作用目标
@property (readwrite,nonatomic) BOOL isTarget;

/// 主演标识
@property (readwrite,nonatomic) long actorGlobalId;

/// 目标标识
@property (readwrite,nonatomic) long targetGlobalId;

/// 目标坐标
@property (readwrite,nonatomic) CGPoint targetPos;

/// 技能伤害数据
@property (readonly,nonatomic) CCArray *damages;

/// 是否死亡
@property (readwrite,nonatomic) BOOL dead;

/// 连击次数
@property (readwrite,nonatomic) int combos;

@property (readwrite,nonatomic) int hurt;


/// 是否是物理攻击
-(BOOL) isPhysicalAttack;

@end
