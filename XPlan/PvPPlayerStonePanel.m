//
//  PlayerStonePanel.m
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPPlayerStonePanel.h"
#import "DoJewlPanel.h"
#import "FighterVo.h"
#import "PlayerInfo.h"
#import "GameController.h"

@implementation PvPPlayerStonePanel

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

- (void) didLoadFromCCB
{
    [nameLabel setString:[GameController sharedController].player.name];
}

-(void) dealloc
{
    [super dealloc];
}

-(void) setFighter:(FighterVo *)fv
{
    
}



@end
