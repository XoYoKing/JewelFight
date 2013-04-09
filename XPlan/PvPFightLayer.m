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
#import "CCBReader.h"

@interface PvPFightLayer()

@end

@implementation PvPFightLayer

@synthesize leftStonePanel,rightStonePanel,portraitPanel,fighterPanel;

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
    CCNode *node = [CCBReader nodeGraphFromFile:@"pvp_main.ccbi" owner:self];
    [self addChild:node];
    
}

-(void) initiaize
{
    
}

@end
