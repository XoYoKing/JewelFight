//
//  BattleAction.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class FightField,FighterSprite;

/// 战斗指令
@interface FightAction : NSObject
{
    FightField *fightField; // 竞技场
    NSString *name; // 指令名称
    FighterSprite *actor; // 执行者标识
    FighterSprite *target; // 目标标识
    BOOL skipped; // 是否跳过
    int move; // 是否需要移动
    float distance; // 移动距离
    float time; // 移动时间
    
}

/// 名称
@property(readonly,nonatomic) NSString *name;

/// 主角战士
@property (readonly,nonatomic) FighterSprite *actor;

/// 目标战士
@property (readonly,nonatomic) FighterSprite *target;

/// 是否跳过
@property (readonly,nonatomic) BOOL skipped;

/// 初始化战斗指令
-(id) initWithFightField:(FightField*)f name:(NSString*)n;

/// 开始
-(void) start;

/// 是否结束
-(BOOL) isOver;

/// 跳过
-(void) skip;

/// 逻辑更新
-(void) update:(ccTime)delta;

@end
