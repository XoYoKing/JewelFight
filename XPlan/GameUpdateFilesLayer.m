//
//  GameLoadingLayer.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GameUpdateFilesLayer.h"
#import "GameController.h"

@interface GameUpdateFilesLayer()
{
    BOOL initialized;
}

@end

@implementation GameUpdateFilesLayer

-(id) init
{
    if ((self = [super init]))
    {
        // schedule an update
        [self schedule:@selector(update:) interval:[[CCDirector sharedDirector] animationInterval]];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    if (!initialized)
    {
        initialized = YES;
        
        // 加载完成
        [self loadDone];
    }
}

-(void) loadDone
{
    [[GameController sharedController] runPvPFightScene];
}

@end
