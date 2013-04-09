//
//  FightGround.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightArena.h"
#import "GameCommand.h"

@implementation FightArena

-(id) init
{
    if ((self = [super init]))
    {
        heros = [[CCArray alloc] initWithCapacity:10];
        actions = [[CCArray alloc] initWithCapacity:10];
        
        
    }
    
    return self;
}

-(void) dealloc
{
    [heros release];
    [actions release];
    
    [super dealloc];
}



@end
