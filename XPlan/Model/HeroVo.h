//
//  PlayerHeroVo.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// 英雄数据对象
@interface HeroVo : NSObject
{
    NSString *heroId; // 英雄标识
    long userId; // 隶属玩家标识
    NSString *name; // 英雄名称
    int sex; // 性别
    int head; // 头像
    int fashion; // 时装
    int quality; // 品质
    int maxQuality; // 最大品质
    int level; // 等级
    int maxLevel; // 最大等级
    int maxHp; // 最大生命值
    int maxAnger; // 最大怒气值
    int energy; // 体力值
    int maxEnergy; // 最大体力值
    int exp; // 当前经验
    int maxExp; // 最大经验值
    int attackPower; // 攻击力
    BOOL isLeader; // 是否是队长
    BOOL isTeam; // 是否在组队状态
    CGPoint gridPos; // 角色所在格子位置
    NSString *fightPortrait; // 战斗闪电特效头像
}

/// 英雄标识
@property (readwrite,nonatomic,retain) NSString *heroId;

/// 隶属用户标识
@property (readwrite,nonatomic) long userId;

/// 英雄名称
@property (readwrite,nonatomic,retain) NSString *name;

/// 品质
@property (readwrite,nonatomic) int quality;

/// 最大品质
@property (readwrite,nonatomic) int maxQuality;

/// 头部形象
@property (readwrite,nonatomic) int head;

/// 身体形象
@property (readwrite,nonatomic) int fashion;

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

/// 经验值
@property (readwrite,nonatomic) int exp;

/// 最大经验值
@property (readwrite,nonatomic) int maxExp;

/// 是否在组队状态
@property (readwrite,nonatomic) BOOL isTeam;

/// 攻击力
@property (readwrite,nonatomic) int attackPower;

@end
