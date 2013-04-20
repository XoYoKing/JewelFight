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

@implementation FighterSprite

@synthesize state,newState,team,globalId;

-(id) initWithFightField:(FightField*)field fighterVo:(FighterVo*)fv
{
    if ((self = [super init]))
    {
        fightField = field;
        fighterVo = fv;
        
        // 设置隶属阵营
        team = fighterVo.userId == [GameController sharedController].player.userId?0:1;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(int) globalId
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
