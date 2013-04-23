//
//  PVPOpponentAndFightersCommandData.m
//  XPlan
//
//  Created by Hex on 4/23/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PVPOpponentAndFightersCommandData.h"

@implementation PVPOpponentAndFightersCommandData

@synthesize playerTeam,playerFighters,opponentTeam,opponentUserInfo,opponentFighters,streetId;

-(CCArray*) playerFighters
{
    if (playerFighters == nil)
    {
        playerFighters = [[CCArray alloc] initWithCapacity:5];
    }
    
    return playerFighters;
}

-(UserInfo*) opponentUserInfo
{
    if (opponentUserInfo == nil)
    {
        opponentUserInfo = [[UserInfo alloc] init];
    }
    
    return opponentUserInfo;
}

-(CCArray*) opponentFighters
{
    if (opponentFighters == nil)
    {
        opponentFighters = [[CCArray alloc] initWithCapacity:5];
    }
    
    return opponentFighters;
}

-(void) dealloc
{
    [playerFighters release];
    [opponentFighters release];
    [opponentUserInfo release];
    [super dealloc];
}

@end
