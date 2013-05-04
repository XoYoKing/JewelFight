//
//  PersonVo.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 玩家信息
@interface UserData : NSObject
{
    long userId; // 用户标识
    int level; // 用户级别
    NSString *name; // 用户名
    NSString *currentMap; // 角色
    int sex; // 性别
    int head; // 头像
    int silver; // 银币数量
    int gold; // 金币数量
    int diamond; // 钻石数量
    int fashion; // 时装
    BOOL isTeam; // 是否在组队状态
    BOOL isLeader; // 是否是队长
    int maxHp; // 当前拥有的总血量
    int maxAnger; // 当前拥有的总怒气
    
    NSString *avatar; // 角色头像
    
    int teamId; // 队伍标识
    
    CGPoint gridPos; // 角色所在格子位置
    
    NSString *fightPortrait; // 战斗闪电特效头像
    
    int energy; // 当前体力
    int maxEnergy; // 最大体力
    int xp; // 当前经验
    int maxXp; // 最大经验值
}

/// 用户唯一标识
@property (readonly,nonatomic) long userId;

/// 用户级别
@property (readwrite,nonatomic) int level;

/// 用户名称
@property (readwrite,nonatomic,retain) NSString *name;

/// 当前所处地图
@property (readwrite,nonatomic,retain) NSString *currentMap;

/// 性别
@property (readwrite,nonatomic) int sex;

/// 头像
@property (readwrite,nonatomic) int head;

/// 银币数量
@property (readwrite,nonatomic) int silver;

/// 金币数量
@property (readwrite,nonatomic) int gold;

/// 最大生命值
@property (readwrite,nonatomic) int maxHp;

/// 最大怒气值
@property (readwrite,nonatomic) int maxAnger;



/// 构造函数
-(id) initWithUserId:(long)_userId;

@end
