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
    NSMutableDictionary *allFighterSpriteDict; // 全部战士字典
    CCArray *leftFighterSprites; // 左方战士标识集合
    CCArray *rightFighterSprites; // 右方战士标识集合
    CCLayer *fighterLayer; // 战士层
    CCLayer *effectLayer; // 效果层
    
}

/// 添加效果
-(void) addEffectSprite:(EffectSprite*)effectSprite;

#pragma mark -
#pragma mark FighterSprite

/// 获取战士Sprite
-(FighterSprite*) getFighterSpriteWithGlobalId:(long)globalId;

/// 创建战士
-(FighterSprite*) createFighterSpriteWithFighterVo:(FighterVo*)fighterVo;

/// 添加战士
-(void) addFighterSprite:(FighterSprite*)fighterSprite;

/// 删除战士
-(void) removeFighterSprite:(FighterSprite*)fighterSprite;

/// 删除全部宝石
-(void) removeAllFighters;

@end
