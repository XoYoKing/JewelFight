//
//  FightField.h
//  XPlan
//
//  Created by Hex on 4/19/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "EffectSprite.h"

@class FighterSprite,FighterVo,FightController;

/// 战斗场
@interface FightField : CCLayer
{
    FightController *fightController; // 战斗控制器
    FighterSprite *leftFighterSprite;
    FighterSprite *rightFighterSprite;
    CCLayer *fighterLayer; // 战士层
    CCLayer *effectLayer; // 效果层
    
}

/// 添加效果
-(void) addEffectSprite:(EffectSprite*)effectSprite;

#pragma mark -
#pragma mark FighterSprite

/// 获取FighterSprite
-(FighterSprite*) getFighterSpriteWithGlobalId:(long)globalId;

/// 创建战士
-(FighterSprite*) createFighterSpriteWithFighterVo:(FighterVo*)fighterVo;

-(void) addFighterSprite:(FighterSprite*)fighterSprite;

/// 删除战士
-(void) removeFighterSprite:(FighterSprite*)fighterSprite;

/// 删除全部战士
-(void) removeAllFighters;

@end
