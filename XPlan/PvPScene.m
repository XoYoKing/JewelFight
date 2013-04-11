//
//  FightScene.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPScene.h"
#import "GameController.h"
#import "GameServer.h"
#import "Constants.h"
#import "PvPController.h"
#import "UserInfo.h"
#import "HeroVo.h"
#import "LoadingLayer.h"
#import "PvPLayer.h"
#import "PvPHudLayer.h"

@interface PvPScene()

-(void) update:(ccTime)delta;

@end

@implementation PvPScene

@synthesize oppFightHeroList,oppUser,controller;

-(id) init
{
    if ((self = [super init]))
    {
        controller = [[PvPController alloc] initWithScene:self];
        state = 0;
        
        // schedule an update
        [self schedule:@selector(update:) interval:[[CCDirector sharedDirector] animationInterval]];
    }
    
    return self;
}

-(void) dealloc
{
    [controller release];
    [oppUser release];
    [oppFightHeroList release];
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    [controller update:delta];
}

-(CCArray*) oppFightHeroList
{
    if (oppFightHeroList == nil)
    {
        oppFightHeroList = [[CCArray alloc] initWithCapacity:5];
    }
    
    return oppFightHeroList;
}

-(void) onEnter
{
    [super onEnter];
}

-(void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
}




@end
