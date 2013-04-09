//
//  FightActionQueue.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightActionQueue.h"
#import "FightAction.h"

@implementation FightActionQueue

@synthesize actions;

-(id) init
{
    if ((self = [super init]))
    {
        actions = [[CCArray alloc] initWithCapacity:20];
    }
    
    return self;
}

-(void) dealloc
{
    [actions release];
    [super dealloc];
}

-(void) skipAll
{
    for (FightAction *action in actions)
    {
        [action skip];
    }
}

-(void) reset
{
    [actions removeAllObjects];
}

@end
