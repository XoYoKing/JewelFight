//
//  JewelCell.m
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelCell.h"
#import "JewelController.h"
#import "JewelBoardData.h"
#import "JewelBoard.h"
#import "JewelVo.h"

@implementation JewelCell
@synthesize controller,coord,jewelGlobalId;

-(id) initWithJewelController:(JewelController *)jc coord:(CGPoint)cd
{
    if ((self = [super init]))
    {
        controller = jc;
        coord = cd;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}


-(JewelVo*) jewelVo
{
    if (jewelGlobalId!=0)
    {
        return [controller.boardData getJewelVoByGlobalId:jewelGlobalId];
    }
    
    return nil;
}

-(JewelSprite*) jewelSprite
{
    if (jewelGlobalId!=0)
    {
        return [controller.board getJewelSpriteWithGlobalId:jewelGlobalId];
    }
    
    return nil;
}

@end
