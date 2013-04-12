//
//  OpponentStonePanel.m
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPOpponentStonePanel.h"
#import "FighterVo.h"
#import "ViewStonePanel.h"
#import "UserInfo.h"

@implementation PvPOpponentStonePanel

-(id) init
{
    if ((self = [super init]))
    {
        
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

-(void) setOpponent:(UserInfo *)opp
{
    [nameLabel setString: opp.name];
}

-(void) setFighter:(FighterVo *)fv
{
    
}

@end
