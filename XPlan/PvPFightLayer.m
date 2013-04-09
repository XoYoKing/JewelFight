//
//  FightLayer.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightLayer.h"
#import "FightStonePanel.h"
#import "PvPFightScene.h"
#import "PvPFightController.h"

@interface PvPFightLayer()

@end

@implementation PvPFightLayer

@synthesize leftStonePanel,rightStonePanel,fighterUI;

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
    CGSize winSize = [KITApp winSize];
    
    // 设置玩家面板
    leftStonePanel = [[FightStonePanel alloc] initWithTeam:0];
    [self addChild:leftStonePanel z:0 tag:kTagLeftStonePanel];
    leftStonePanel.anchorPoint = ccp(0,0);
    leftStonePanel.position = ccp(0,[KITApp scale:20]);
    
    rightStonePanel = [[FightStonePanel alloc] initWithTeam:1];
    [self addChild:rightStonePanel z:0 tag:kTagRightStonePanel];
    rightStonePanel.position = ccp(winSize.height - rightStonePanel.width, [KITApp scale:20]);
    rightStonePanel.anchorPoint = ccp(0,0);
}

-(FighterUI*) fighterUI
{
    
}

-(void) initiaize
{
    
}

@end
