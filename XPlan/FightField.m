//
//  FightField.m
//  XPlan
//
//  Created by Hex on 4/19/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightField.h"
#import "FighterSprite.h"

@implementation FightField


#pragma mark -
#pragma mark FighterSprite

/// 获取FighterSprite
-(FighterSprite*) getFighterSpriteWithGlobalId:(long)globalId
{
    return [allFighterSpriteDict objectForKey:[NSNumber numberWithInt:globalId]];
}

/// 创建FighterSprite
-(FighterSprite*) createFighterSpriteWithFighterVo:(FighterVo*)fighterVo
{
    FighterSprite *fighterSprite = [[FighterSprite alloc] initWithFightField:self fighterVo:fighterVo];
    
    [self addFighterSprite:fighterSprite];
    
    [fighterSprite release];
    
    return fighterSprite;
}

/// 添加宝石
-(void) addFighterSprite:(FighterSprite*)fighterSprite
{
    // 判断Fighter的阵营
    if (fighterSprite.team == 0)
    {
        [fighter1BatchNode addChild:fighterSprite];
    }
    else
    {
        [fighter2BatchNode addChild:fighterSprite];
    }
    
    // 添加到字典
    [allFighterSpriteDict setObject:fighterSprite forKey:[NSNumber numberWithInt:fighterSprite.globalId]];
    // 添加到集合
    [allFighterSpriteList addObject:fighterSprite];
    
}

/// 删除宝石
-(void) removeFighterSprite:(FighterSprite*)fighterSprite
{
    // 删除对应数据
    [fightController removeFighterVo:fighterSprite.fighterVo];
    
    // 删除表现物
    [allFighterSpriteDict removeObjectForKey:[NSNumber numberWithInt:fighterSprite.globalId]];
    [allFighterSpriteList removeObject:fighterSprite];
    [fighterSprite removeFromParentAndCleanup:YES];
}

/// 删除全部宝石
-(void) removeAllFighters
{
    for (FighterSprite *fs in allFighterSpriteList)
    {
        [fs removeFromParentAndCleanup:YES];
    }
    
    [allFighterSpriteDict removeAllObjects];
    [allFighterSpriteList removeAllObjects];
}




@end
