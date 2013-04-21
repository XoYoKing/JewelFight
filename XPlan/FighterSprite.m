//
//  FighterSprite.m
//  XPlan
//
//  Created by Hex on 4/18/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FighterSprite.h"
#import "FightField.h"
#import "FighterVo.h"
#import "GameController.h"
#import "PlayerInfo.h"

@interface FighterSprite()

@end

@implementation FighterSprite

@synthesize state,newState,team,globalId,fighterVo;

-(id) initWithFightField:(FightField*)field fighterVo:(FighterVo*)fv
{
    // 设置初始化的英雄形象
    KITProfile *profile = [KITProfile profileWithName:[NSString stringWithFormat:@"fighter_%d_graphics",fv.heroId]];
    
    // 初始设置静止素材
    id ret = [self initWithSpriteFrame:[profile spriteFrameForKey:@"idle"]];
    if (ret!=nil)
    {
        fightField = field;
        fighterVo = [fv retain];
        // 设置隶属阵营
        team = fighterVo.userId == [GameController sharedController].player.userId?0:1;
        state = kFighterStateIdle; // 英雄状态
        effects = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return self;
}

-(void) dealloc
{
    [fighterVo release];
    [effects release];
    [super dealloc];
}

-(long) globalId
{
    return fighterVo.globalId;
}

#pragma mark -
#pragma mark Effects

-(void) addEffects
{
    // for subclasses to implement
}

-(void) addEffect:(EffectSprite*)effect withKey:(NSString*)key
{
    // 还是添加到宝石面板吧!!
    [fightField addEffectSprite:effect];
    
    [effects setValue:effect forKey:key];
}

-(void) deleteEffectWithKey:(NSString*)key
{
    id effect = [effects objectForKey:key];
    [effect removeFromParentAndCleanup:YES];
    [effects removeObjectForKey:key];
}

/// 清除全部特效
-(void) detatchEffects
{
    for (NSString *key in [effects allKeys])
    {
        id effect = [effects objectForKey:key];
        [effect removeFromParentAndCleanup:YES];
    }
}


@end
