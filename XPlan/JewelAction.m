//
//  JewelAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelAction.h"
#import "JewelPanel.h"
#import "JewelManager.h"
#import "JewelSprite.h"
#import "JewelVo.h"

@implementation JewelAction

-(id) initWithJewelPanel:(JewelPanel *)panel
{
    if ((self = [super init]))
    {
        jewelPanel = panel;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

@end
