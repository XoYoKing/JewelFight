//
//  PlayerjewelBoard.m
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPPlayerJewelPanel.h"
#import "JewelBoard.h"
#import "FighterVo.h"
#import "PlayerInfo.h"
#import "GameController.h"

@implementation PvPPlayerJewelPanel

@synthesize jewelBoard;

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




@end
