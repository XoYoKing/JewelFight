//
//  JewelCell.m
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelCell.h"
#import "JewelBoard.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "JewelController.h"

@implementation JewelCell
@synthesize board,coord,jewelGlobalId,jewelSprite,comingJewelGlobalId;

-(id) initWithJewelBoard:(JewelBoard *)jb coord:(CGPoint)cd
{
    if ((self = [super init]))
    {
        board = jb;
        coord = cd;
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
        return [board getJewelSpriteWithGlobalId:jewelGlobalId];
    }
    
    return nil;
}

-(CGRect) boardRect
{
    return CGRectMake(coord.x * board.cellSize.width, (board.gridSize.height - coord.y -1) * board.cellSize.height, board.cellSize.width, board.cellSize.height);
}

@end
