//
//  LeaderPortrait.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "LeaderPortrait.h"
#import "CCBReader.h"

@implementation LeaderPortrait

-(id) initWithFighterVo:(FighterVo *)fv
{
    if ((self = [super initWithFighterVo:fv]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) initUI
{
    CCNode *ccbNode = [CCBReader nodeGraphFromFile:@"fight_leader_portrait.ccbi" owner:self];
    [self addChild:ccbNode];
    [super initUI];
}

@end
