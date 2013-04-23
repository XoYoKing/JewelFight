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

typedef enum _FighterStates
{
    kFighterStateIdle = 0, // 闲置状态
    kFighterStateDying = 4, // 正在死亡
    kFighterStateDied = 5 // 死掉了
}FighterStates;

#define kTagFighterAnimationWin 30 // 胜利动画标识
#define kTagFighterAnimationFail 31 // 失败动画标识


@class FighterVo,FightField;

/// 战士Sprite
@interface FighterSprite : CCSprite
{
    FightField *fightField; // 战场
    FighterVo *fighterVo; // 关联战士数据
    NSMutableDictionary *effects; // 宝石效果
    CCArray *textEffectQueue; // 文字特效队列
    int state; // 状态
    int newState;
    int team; // 阵营
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
-(void) setAnimation:(NSString *)animKey tag:(int)actionTag repeat:(BOOL)repeat restore:(BOOL)restore;

/// 设置动画
-(void) setAnimation:(NSString *)animKey tag:(int)actionTag repeat:(BOOL)repeat restore:(BOOL)restore cleanOthers:(BOOL)clean;

-(BOOL) isAnimationPlaying:(int)actionTag;

/// 胜利动画
-(void) winAnimation;

/// 胜利动画是否正在播放
-(BOOL) isWinAnimationPlaying;

/// 失败动画
-(void) failAnimation;

/// 失败动画是否正在播放
-(BOOL) isFailAnimationPlaying;

@end
