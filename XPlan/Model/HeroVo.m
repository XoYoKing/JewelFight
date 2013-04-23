//
//  PlayerHeroVo.m
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "HeroVo.h"

@implementation HeroVo

@synthesize userId,heroId,name,quality,maxQuality,head,fashion,level,maxLevel,maxHp,energy,maxEnergy,exp,maxExp,isTeam,attackPower,maxAnger;

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

@end
