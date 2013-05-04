//
//  PvPPortraitPanel.m
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPPortraitPanel.h"


@implementation PvPPortraitPanel



-(void) dealloc
{
    [playerFighterLifeBar release];
    [opponentFighterLifeBar release];
    [super dealloc];
}

-(void) didLoadFromCCB
{
    [self initUI];
}

-(void) initUI
{
    playerFighterLifeBar = [[HonsterBar alloc] initBarWithBarSprite:playerHp insetSprite:playerHpBg maskSprite:playerHpMask direction:kBarDirectionLeft];
    [self addChild:playerFighterLifeBar];
    playerFighterLifeBar.anchorPoint = ccp(0.5,0.5);
    playerFighterLifeBar.position = ccp(170,23);
    playerFighterLifeBar.progress =10;
    
    opponentFighterLifeBar = [[HonsterBar alloc] initBarWithBarSprite:opponentHp insetSprite:opponentHpBg maskSprite:opponentHpMask direction:kBarDirectionRight];
    [self addChild:opponentFighterLifeBar];
    opponentFighterLifeBar.anchorPoint = ccp(0.5,0.5);
    opponentFighterLifeBar.position = ccp(594,23);
    opponentFighterLifeBar.progress = 10;
}

-(void) onEnter
{
    playerFighterLifeBar.progress = 50;
    
    
    [super onEnter];
}


@end
