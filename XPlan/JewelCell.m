//
//  JewelCell.m
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelCell.h"
#import "JewelPanel.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "JewelManager.h"

@implementation JewelCell
@synthesize panel,coord,jewelId,jewelSprite,comingJewelId;

-(id) initWithJewelPanel:(JewelPanel *)thePanel coord:(CGPoint)theCoord
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
    [comingJewelId release];
    [super dealloc];
}

-(JewelSprite*) jewelSprite
{
    if (jewelId)
    {
        return [panel getJewelSprite:jewelId];
    }
    
    return nil;
}

-(void) setJewelItem:(JewelSprite *)value
{
    self.jewelId = value.jewelId;
}

@end
