//
//  ActorVo.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HeroVo.h"

/// 战场情况下的实际英雄数据对象 Value Object
@interface FighterVo : NSObject
{
    long globalId; // 唯一标识
    int heroId; // 英雄标识
    int heroType; // 英雄类型
    long userId; // 英雄隶属玩家标识
    NSString *name; // 英雄名称
    int sex; // 英雄性别
    int head; //头部装备?
    int fashion; // 身体装备?
    int hp; // 生命值
    int maxHp; // 最大生命值
    int anger; // 怒气值
    int maxAnger; // 最大怒气值
    int team; // 队伍

}

/// 唯一标识
@property (readwrite,nonatomic) long globalId;

/// 英雄标识
@property (readwrite,nonatomic) int heroId;

/// 英雄类型
@property (readwrite,nonatomic) int heroType;

/// 隶属玩家标识
@property (readwrite,nonatomic) long userId;

/// 名称
@property (readwrite,nonatomic,retain) NSString *name;

/// 头部装备
@property (readwrite,nonatomic) int head;

/// 身体装备
@property (readwrite,nonatomic) int fashion;

/// 生命值
@property (readwrite,nonatomic) int hp;

/// 最大生命值
@property (readwrite,nonatomic) int maxHp;

/// 怒气值
@property (readwrite,nonatomic) int anger;

/// 最大怒气值
@property (readwrite,nonatomic) int maxAnger;

/// 隶属队伍
@property(readwrite,nonatomic) int team;

/// 英雄性别
@property (readwrite,nonatomic) int sex;

/// 素材信息
@property (readonly,nonatomic) KITProfile *profile;


@end
