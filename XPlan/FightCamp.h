//
//  FighterCamp.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class FightArena,Fighter;

/// 战斗阵营
@interface FightCamp : NSObject
{
    FightArena *arena; // 所处竞技场
    CCArray *heroList; // 出阵英雄列表
    NSString *fightingHeroId; // 正在战斗的英雄
    int side; // 所处位置
}


/// 正在出战的英雄
@property (readonly,nonatomic) Fighter *fightingHero;

@end
