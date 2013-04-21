//
//  FightController.h
//  XPlan
//
//  Created by Hex on 4/19/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FightField,FightAction,FighterVo,FightActionQueue;

@class FighterVoCollection;

/// 战斗控制器
@interface FightController : NSObject
{
    // action
    FightActionQueue *actionQueue; // 操作英雄动作队列
    FightAction *currentAction; // 当前英雄动作
    
    FightField *fightField; // 战斗场景
    
    FighterVoCollection *leftFighterVoCollection; // 左侧战士集合
    FighterVoCollection *rightFighterVoCollection; // 右侧战士集合
}

@property (readonly,nonatomic) FighterVoCollection *leftFighterVoColelction;

@property (readonly,nonatomic) FighterVoCollection *rightFighterVoCollection;


#pragma mark -
#pragma mark Fight Actions

-(void) update:(ccTime)delta;

/// 更新英雄动作
-(void) updateFightActions:(ccTime)delta;

-(void) queueAction:(FightAction*)action top:(BOOL)top;

-(void) resetActions;


@end
