//
//  BattleAction.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAction.h"
#import "FighterUI.h"
#import "FightArena.h"

@implementation FightAction

@synthesize name,actor,target,skipped;

-(id) initWithFightGround:(FightArena *)_ground name:(NSString *)_name
{
    if ((self = [super init]))
    {
        ground = _ground;
        name = _name;
    }
    
    return self;
}


-(BOOL) isSkipped
{
    return NO;
}



@end
