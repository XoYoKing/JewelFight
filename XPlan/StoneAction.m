//
//  StoneAction.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneAction.h"
#import "StonePanel.h"
#import "StoneController.h"
#import "StoneItem.h"
#import "StoneVo.h"

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
