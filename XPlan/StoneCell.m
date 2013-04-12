//
//  StoneCell.m
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneCell.h"
#import "StonePanel.h"
#import "StoneSprite.h"
#import "JewelVo.h"
#import "StoneManager.h"

@implementation StoneCell
@synthesize panel,coord,jewelId,stoneItem,comingStoneId;

-(id) initWithStonePanel:(StonePanel *)thePanel coord:(CGPoint)theCoord
{
    if ((self = [super init]))
    {
        panel = thePanel;
        coord = theCoord;
    }
    
    return self;
}

-(void) dealloc
{
    [jewelId release];
    [comingStoneId release];
    [super dealloc];
}

-(StoneSprite*) stoneSprite
{
    if (jewelId)
    {
        return [panel getStoneSprite:jewelId];
    }
    
    return nil;
}

-(void) setStoneItem:(StoneSprite *)value
{
    self.jewelId = value.jewelId;
}

@end
