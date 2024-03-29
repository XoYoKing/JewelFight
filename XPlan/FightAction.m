//
//  BattleAction.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAction.h"
#import "FighterSprite.h"
#import "FightField.h"

@implementation FightAction

@synthesize name,actor,target,skipped;

-(id) initWithFightField:(FightField *)f name:(NSString *)n
{
    if ((self = [super init]))
    {
        fightField = f;
        name = [n retain];
    }
    
    return self;
}

-(void) dealloc
{
    [name release];
    [super dealloc];
}

-(FighterSprite*) actor
{
    if (actorFighterGlobalId > 0)
    {
        return [fightField getFighterSpriteWithGlobalId:actorFighterGlobalId];
    }
    return nil;
}

-(FighterSprite*) target
{
    if (targetFighterGlobalId > 0)
    {
        return [fightField getFighterSpriteWithGlobalId:targetFighterGlobalId];
    }
    
    return nil;
}

-(void) start
{
    if (skipped)
    {
        return;
    }
}

-(void)skip
{
    skipped = YES;
}

-(BOOL) isOver
{
    return YES;
}



@end
