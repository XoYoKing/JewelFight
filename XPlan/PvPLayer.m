//
//  FightLayer.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPLayer.h"
#import "PvPScene.h"
#import "PvPController.h"
#import "CCBReader.h"

@interface PvPLayer()

@end

@implementation PvPLayer

@synthesize playerJewelPanel,opponentJewelPanel,portraitPanel,fighterPanel;

-(id) init
{
    if ((self = [super init]))
    {
        
        
        [self initUI];
    }
    
    return self;
}

- (void) didLoadFromCCB
{
    
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
