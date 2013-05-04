//
//  FighterAttackAction.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FighterAction.h"
#import "Fighter.h"

@interface FighterAttackAction : FighterAction
{
    int move; // 是否需要移动
    CGPoint distance; // 移动距离
    ccTime costTime; // 移动时间
}

/// 初始化
-(id) initWithActor:(Fighter*)_actor target:(Fighter*)_target move:(int)_move distance:(CGPoint)_distance costTime:(int)_costTime;

@end
