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
    kFighterStateIdle = 0 // 闲置状态
}FighterStates;


@class FighterVo,FightField;

/// 战士Sprite
@interface FighterSprite : CCSprite
{
    FightField *fightField; // 战场
    FighterVo *fighterVo; // 关联战士数据
    NSMutableDictionary *effects; // 宝石效果
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

/// 初始化
-(id) initWithFightField:(FightField*)field fighterVo:(FighterVo*)fv;

#pragma mark -
#pragma mark Status

/// 是否准备移除
-(BOOL) isReadyToBeRemoved;


/// 逻辑更新
-(BOOL) update:(ccTime)delta;

@end
