//
//  FightController.h
//  XPlan
//
//  Created by Hex on 4/19/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FightField,FightAction,FighterVo,FightActionQueue,FightPortrait,FightPanel;

@class FighterVoCollection;

/// 战斗控制器
@interface FightController : NSObject
{
    // action
    FightActionQueue *actionQueue; // 操作英雄动作队列
    FightAction *currentAction; // 当前英雄动作
    FightPanel *fightPanel; // 战斗面板
    int streetId; // 战斗地点标识
    NSMutableDictionary *allFighterVoDict; // 全部战士数据对象字典
    CCArray *leftFighterVoList;
    CCArray *rightFighterVoList;
}

/// 战斗区域
@property (readonly,nonatomic) FightField *fightField;

/// 头像
@property (readonly,nonatomic) FightPortrait *portrait;

/// 初始化
-(id) initWithFightPanel:(FightPanel*)fp;

/// 设置战斗地点
-(void) setFightStreet:(int)sId;

/// 初始化设置左侧战士集合和右侧战士集合
-(void) setLeftFighterVos:(CCArray*)leftList rightFighterVos:(CCArray*)rightList;

#pragma mark -
#pragma mark FighterVo

/// 添加战士数据
-(void) addFighterVo:(FighterVo*)fv;

/// 删除战士数据
-(void) removeFighterVo:(FighterVo*)fv;



#pragma mark -
#pragma mark Fight Actions

-(void) update:(ccTime)delta;

/// 更新英雄动作
-(void) updateFightActions:(ccTime)delta;

-(void) queueAction:(FightAction*)action top:(BOOL)top;

-(void) resetActions;


@end
