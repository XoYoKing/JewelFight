//
//  JewelArea.m
//  XPlan
//
//  Created by Hex on 4/16/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelArea.h"
#import "JewelPanel.h"
#import "JewelCell.h"

@implementation JewelArea

+(void) getAreaCellsAroundCell:(CCArray *)areaTiles panel:(JewelPanel *)panel cell:(JewelCell *)cell radius:(int)radius
{
    int startX,startY,width,height;
    startX = max(cell.coord.x - radius, 0);
    startY = max(cell.coord.y - radius, 0);
    width = min(panel.gridSize.width,startX + (2 * radius + 1)) - startX;
    height = min(panel.gridSize.height, startY + (2 * radius + 1)) - startY;
    
    for (int i = 0; i< width; i++)
    {
        for(int j = 0; j< height; j++)
        {
            JewelCell *cell = [panel getCellAtCoord:ccp(startX + i,startY + j)];
            if(cell)
            {
                [areaTiles addObject:cell];
            }
        }
    }
}

@end
