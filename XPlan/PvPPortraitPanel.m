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
    playerFighterLifeBar = [[GPBar alloc] initBarWithBarSprite:playerHp insetSprite:playerHpBg maskSprite:playerHpMask];
    [self addChild:playerFighterLifeBar];
    playerFighterLifeBar.position = ccp(170,23);
    playerFighterLifeBar.progress =70;
    
    opponentFighterLifeBar = [[GPBar alloc] initBarWithBarSprite:opponentHp insetSprite:opponentHpBg maskSprite:opponentHpMask];
    [self addChild:opponentFighterLifeBar];
    opponentFighterLifeBar.position = ccp(594,23);
    opponentFighterLifeBar.progress = 70;
}

-(void) onEnter
{
    playerFighterLifeBar.progress = 30;
    [super onEnter];
}


@end
