//
//  PlayerInfo.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PlayerInfo.h"

@implementation PlayerInfo

-(id) init
{
    if ((self = [super init]))
    {
        heroDict = [[NSMutableDictionary alloc] initWithCapacity:5];
        heroList = [[CCArray alloc] initWithCapacity:10];
    }
    
    return self;
}

-(void) dealloc
{
    [heroDict release];
    [heroList release];
    [super dealloc];
}

-(void) addHeroVo:(HeroVo *)hero
{
    [heroDict setObject:hero forKey:hero.heroId];
    [heroList addObject:hero];
}

-(HeroVo*) getHeroVo:(NSString *)heroId
{
    return [heroDict objectForKey:heroId];
}

-(CCArray*) getHeros
{
    return heroList;
}

-(HeroVo*) getHeroLeader
{
    return [self getHeroVo:heroLeaderId];
}

-(CCArray*) getHeroFighters
{
    CCArray *fighters = [[[CCArray alloc] initWithCapacity:5] autorelease];
    for (NSString* heroId in heroFighterIds)
    {
        [fighters addObject:[self getHeroVo:heroId]];
    }
    
    return fighters;
}

@end
