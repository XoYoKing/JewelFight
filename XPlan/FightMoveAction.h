//
//  FightMoveAction.h
//  XPlan
//
//  Created by Hex on 4/22/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAction.h"

@class FighterSprite;

/// 战斗移动动作
@interface FightMoveAction : FightAction
{
    float distance; // 移动距离
    float time; // 移动时间
    int move; // 是否需要移动
}


-(id) initWithFightField:(FightField *)f actor:(FighterSprite*)a move:(int)m distance:(float)d time:(float)t;




@end
