//
//  FighterSprite.h
//  XPlan
//
//  Created by Hex on 4/18/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "EffectSprite.h"
#import "CCBReader.h"

typedef enum _FighterStates
{
    kFighterStateIdle = 0, // 闲置状态
    kFighterStateHurt = 1, // 受伤状态
    kFighterStateProvoke = 2, // 角色挑衅状态
    kFighterStateDied = 3 // 死亡状态
}FighterStates;

#define kTagFighterAnimationIdle 29 // 闲置
#define kTagFighterAnimationWin 30 // 胜利动画标识
#define kTagFighterAnimationFail 31 // 失败动画标识


@class FighterVo,FightField;

/// 战士Sprite
@interface FighterSprite : CCNode
{
    FightField *fightField; // 战场
    FighterVo *fighterVo; // 关联战士数据
    NSMutableDictionary *effects; // 宝石效果
    CCArray *textEffectQueue; // 文字特效队列
    int state; // 状态
    int newState;
    int team; // 阵营
    NSString *runningAnim;
}

/// 全局标识
@property (readonly,nonatomic) long globalId;

/// 战士数据对象
@property (readonly,nonatomic) FighterVo *fighterVo;

/// 状态
@property (readwrite,nonatomic) int state;

/// 新状态
@property (readwrite,nonatomic) int newState;

/// 阵营
@property (readonly,nonatomic) int team;

/// 对应素材管理器
@property (readonly,nonatomic) KITProfile *profile;

@property (readwrite,nonatomic) int life;

@property (readonly,nonatomic) int maxLife;

/// 正在执行的动画
@property (readonly,nonatomic) NSString *runningAnim;

/// 初始化
-(id) initWithFightField:(FightField*)field fighterVo:(FighterVo*)fv;

#pragma mark -
#pragma mark Status

/// 是否准备移除
-(BOOL) isReadyToBeRemoved;

/// 是否存活
-(BOOL) isAlive;

/// 逻辑更新
-(BOOL) update:(ccTime)delta;

/// 获取对目标的伤害
-(int) getDamageTo:(FighterSprite*)target;

/// 降低生命值
-(void) reduceLife:(int)damage;

#pragma mark -
#pragma mark Animation

/// 设置动画
-(void) setAnimation:(NSString *)name;

/// 检查给定的动画名称确认是否正在播放
-(BOOL) isAnimationRunning:(NSString*)name;


@end
