//
//  OpponentJewelPanel.m
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPOpponentJewelPanel.h"
#import "FighterVo.h"
#import "UserInfo.h"

@implementation PvPOpponentJewelPanel

@synthesize jewelPanel;

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
