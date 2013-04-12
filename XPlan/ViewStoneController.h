//
//  StoneEffectManager.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneManager.h"

@class StonePanel,PlayerInfo,ActionVo;

/// 查看宝石特效管理器
@interface ViewStoneController : StoneManager
{
    PlayerInfo *playerVo; // 玩家数据
    CCArray *actionVoList; // 动作指令队列
    ActionVo *currentAction; // 当前执行指令对象
    CCArray *stoneVoList; // 维护的宝石列表
}

-(id) initWithStonePanel:(StonePanel*)panel;

-(void) update:(ccTime)delta;


@end
