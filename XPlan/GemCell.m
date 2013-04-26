//
//  JewelCell.m
//  XPlan
//
//  Created by Hex on 4/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GemCell.h"
#import "JewelBoard.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "JewelController.h"

@implementation GemCell
@synthesize board,coord,gemGlobalId,gemSprite,comingGemGlobalId;

-(id) initWithJewelPanel:(JewelBoard *)thePanel coord:(CGPoint)theCoord
{
    if ((self = [super init]))
    {
        board = thePanel;
        coord = theCoord;
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(JewelSprite*) gemSprite
{
    if (gemGlobalId!=0)
    {
        return [board getJewelSpriteWithGlobalId:gemGlobalId];
    }
    
    return nil;
}

-(CGRect) panelRect
{
    return CGRectMake(coord.x * board.cellSize.width, (board.gridSize.height - coord.y -1) * board.cellSize.height, board.cellSize.width, board.cellSize.height);
}

@end
