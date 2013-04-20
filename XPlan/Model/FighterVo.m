//
//  ActorVo.m
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FighterVo.h"
#import "HeroVo.h"

/// 战斗者数据对象
@implementation FighterVo

@synthesize globalId,heroId,heroType,userId,name,sex,head,fashion,team,maxAnger,maxHp,hp,anger;

-(id) init
{
    if ((self = [super init]))
    {
    }
    
    return self;
}

@end
