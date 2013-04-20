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

/// 战士精灵
@interface FighterSprite : CCSprite
{
    FightField *fightField; // 战场
    FighterVo *fighterVo; // 关联战士数据
    NSMutableDictionary *effects; // 宝石效果
    int state; // 状态
    int newState;
    int team; // 阵营
}

@property (readonly,nonatomic) int globalId;

@property (readonly,nonatomic) FighterVo *fighterVo;

@property (readwrite,nonatomic) int state;

@property (readwrite,nonatomic) int newState;

/// 阵营
@property (readonly,nonatomic) int team;

#pragma mark -
#pragma mark Status

/// 是否准备移除
-(BOOL) isReadyToBeRemoved;


/// 逻辑更新
-(BOOL) update:(ccTime)delta;

@end
