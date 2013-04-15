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
#import "JewelController.h"

@implementation JewelCell
@synthesize panel,coord,jewelGlobalId,jewelSprite,comingJewelGlobalId;

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
    [super dealloc];
}

-(JewelSprite*) jewelSprite
{
    if (jewelGlobalId!=0)
    {
        return [panel getJewelSprite:jewelGlobalId];
    }
    
    return nil;
}

@end