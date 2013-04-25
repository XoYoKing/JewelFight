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
    
    // 添加战斗层
    fighterLayer = [[CCLayer alloc] init];
    [self addChild:fighterLayer z:2 tag:kTagFighterLayer];
    
    // 添加效果层
    effectLayer = [[CCLayer alloc] init];
    [self addChild:effectLayer z:3 tag:kTagEffectLayer];
}

-(void) dealloc
{
    [fighterLayer release];
    [effectLayer release];
    [super dealloc];
}


#pragma mark -
#pragma mark FighterSprite

/// 获取FighterSprite
-(FighterSprite*) getFighterSpriteWithGlobalId:(long)globalId
{
    if (leftFighterSprite.globalId == globalId)
    {
        return leftFighterSprite;
    }
    else if (rightFighterSprite.globalId == globalId)
    {
        return rightFighterSprite;
    }
    
    return nil;
}

/// 创建FighterSprite
-(FighterSprite*) createFighterSpriteWithFighterVo:(FighterVo*)fighterVo
{
    FighterSprite *fighterSprite = [[FighterSprite alloc] initWithFightField:self fighterVo:fighterVo];
    
    [self addFighterSprite:fighterSprite];
    
    [fighterSprite release];
    
    return fighterSprite;
}

/// 添加战士Sprite
-(void) addFighterSprite:(FighterSprite*)fighterSprite
{
    // 检查战士的阵营
    if (fighterSprite.team == 0)
    {
        if (leftFighterSprite)
        {
            [leftFighterSprite removeFromParentAndCleanup:YES];
            [leftFighterSprite release];
        }
        leftFighterSprite = fighterSprite;
        [fighterLayer addChild:leftFighterSprite];
    }
    else
    {
        if (rightFighterSprite)
        {
            [rightFighterSprite removeFromParentAndCleanup:YES];
            [rightFighterSprite release];
        }
        rightFighterSprite = fighterSprite;
        [fighterLayer addChild:rightFighterSprite];
    }
    
}

/// 删除战士Sprite
-(void) removeFighterSprite:(FighterSprite*)fighterSprite
{
    [fighterSprite removeFromParentAndCleanup:YES];
    if(leftFighterSprite==fighterSprite)
    {
        [leftFighterSprite release];
        leftFighterSprite = nil;
    }
    else
    {
        [rightFighterSprite release];
        rightFighterSprite = nil;
    }
    
}

/// 删除全部战士
-(void) removeAllFighters
{
    [leftFighterSprite removeFromParentAndCleanup:YES];
    [rightFighterSprite removeFromParentAndCleanup:YES];
    
    [leftFighterSprite release];
    [rightFighterSprite release];
}



@end
