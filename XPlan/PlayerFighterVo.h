//
//  PlayerFighterVo.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "Fighter.h"

/// 玩家对手展示对象
@interface PlayerFighterVo : Fighter
{
    NSString *fighterId; // 战士标识
    NSString *userId; // 隶属用户标识
    
}
@end
