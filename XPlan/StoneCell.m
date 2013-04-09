//
//  StoneCell.m
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneCell.h"
#import "StonePanel.h"
#import "StoneItem.h"
#import "StoneVo.h"
#import "StoneController.h"

@implementation StoneCell
@synthesize panel,coord,stoneId,stoneItem,comingStoneId;

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
    [stoneId release];
    [comingStoneId release];
    [super dealloc];
}

-(StoneItem*) stoneItem
{
    if (stoneId)
    {
        return [panel getStoneItem:stoneId];
    }
    
    return nil;
}

-(void) setStoneItem:(StoneItem *)value
{
    self.stoneId = value.stoneId;
}

@end
