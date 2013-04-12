//
//  StoneAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneAction.h"
#import "StonePanel.h"
#import "StoneManager.h"
#import "StoneSprite.h"
#import "JewelVo.h"

@implementation StoneAction

-(id) initWithStonePanel:(StonePanel *)panel
{
    if ((self = [super init]))
    {
        stonePanel = panel;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

@end
