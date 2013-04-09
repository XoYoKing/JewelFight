//
//  FightHudLayer.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightHudLayer.h"
#import "CCBReader.h"

@implementation PvPFightHudLayer

-(id) init
{
    if ((self = [super init]))
    {
        [self initUI];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) initUI
{
    CCNode *node = [CCBReader nodeGraphFromFile:@"fight_hud.ccbi" owner:self];
    [self addChild:node];
    
    
}


@end
