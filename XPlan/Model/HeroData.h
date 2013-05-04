//
//  PlayerHeroVo.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 英雄数据
@interface HeroData : NSObject
{
    NSString *heroId; // 英雄标识
    int quality; // 品质
    int maxQuality; // 最大品质
    int level; // 等级
    int maxLevel; // 最大等级
    int maxHp; // 最大生命值
    int maxAnger; // 最大怒气值
    int energy; // 体力值
    int maxEnergy; // 最大体力值
    int xp; // 经验值
    int damage; // 攻击力
    BOOL isLeader; // 是否是队长
    BOOL isTeam; // 是否在组队状态
}

/// 英雄标识
@property (readwrite,nonatomic,retain) NSString *heroId;

/// 品质
@property (readwrite,nonatomic) int quality;

/// 最大品质
@property (readwrite,nonatomic) int maxQuality;

/// 等级
@property (readwrite,nonatomic) int level;

/// 能够升级到的最大等级
@property (readwrite,nonatomic) int maxLevel;

/// 最大生命值
@property (readwrite,nonatomic) int maxHp;

/// 最大怒气值
@property (readwrite,nonatomic) int maxAnger;

/// 体力值
@property (readwrite,nonatomic) int energy;

/// 最大体力值
@property (readwrite,nonatomic) int maxEnergy;

@end
