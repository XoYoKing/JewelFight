//
//  FightField.m
//  XPlan
//
//  Created by Hex on 4/19/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightField.h"
#import "FightController.h"
#import "FighterSprite.h"
#import "EffectSprite.h"
#import "CCBReader.h"

@implementation FightField

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

- (void) didLoadFromCCB
{
    allFighterSpriteDict = [[NSMutableDictionary alloc] initWithCapacity:7];
    leftFighterSprites = [[CCArray alloc] initWithCapacity:5];
    rightFighterSprites = [[CCArray alloc] initWithCapacity:5];
    
    // 添加战斗层
    fighterLayer = [[CCLayer alloc] init];
    [self addChild:fighterLayer z:2 tag:kTagFighterLayer];
    
    // 添加效果层
    effectLayer = [[CCLayer alloc] init];
    [self addChild:effectLayer z:3 tag:kTagEffectLayer];
}

-(void) dealloc
{
    [allFighterSpriteDict release];
    [leftFighterSprites release];
    [rightFighterSprites release];
    [fighterLayer release];
    [effectLayer release];
    [super dealloc];
}


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
    // 添加到字典
    [allFighterSpriteDict setObject:fighterSprite forKey:[NSNumber numberWithInt:fighterSprite.globalId]];
    
    
    // 判断Fighter的阵营
    if (fighterSprite.team == 0)
    {
        [fighterLayer addChild:fighterSprite];
        
        // 添加到左侧集合
        [leftFighterSprites addObject:fighterSprite];
    }
    else
    {
        [fighterLayer addChild:fighterSprite];
        
        // 添加到右侧集合
        [rightFighterSprites addObject:fighterSprite.globalId];
    }
    
}

/// 删除战士Sprite
-(void) removeFighterSprite:(FighterSprite*)fighterSprite
{
    // 删除对应数据
    [fightController removeFighterVo:fighterSprite.fighterVo];
    
    // 删除表现物
    [allFighterSpriteDict removeObjectForKey:[NSNumber numberWithInt:fighterSprite.globalId]];
    if (fighterSprite.team == 0)
    {
        [leftFighterSprites removeObject:fighterSprite];
    }
    else
    {
        [rightFighterSprites removeObject:fighterSprite];
    }
    [fighterSprite removeFromParentAndCleanup:YES];
}

/// 删除全部战士
-(void) removeAllFighters
{
    for (FighterSprite *fs in allFighterSpriteDict.allValues)
    {
        [fs removeFromParentAndCleanup:YES];
    }
    [allFighterSpriteDict removeAllObjects];
    [leftFighterSprites removeAllObjects];
    [rightFighterSprites removeAllObjects];
}



@end
