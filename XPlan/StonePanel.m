//
//  StonePanel.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StonePanel.h"
#import "StoneSprite.h"
#import "JewelVo.h"
#import "StoneCell.h"
#import "Constants.h"
#import "GameController.h"
#import "StoneManager.h"

@implementation StonePanel

@synthesize gridSize,cellSize,continueDispose;
-(id) init
{
    if ((self = [super init]))
    {
        controller = [[StoneManager alloc] initWithStonePanel:self];
        allStoneSpriteDict = [[NSMutableDictionary alloc] init];
        allStoneItems = [[CCArray alloc] initWithCapacity:30];
        
        // 设置格子宽高
        gridSize = CGSizeMake(5, 7);
        cellSize = CGSizeMake([KITApp scale:41], [KITApp scale:41]);
        
        // 初始化宝石格子
        int totalCells = gridSize.width * gridSize.height;
        cellGrid = [[CCArray alloc] initWithCapacity:totalCells];
        int n = 0;
        while (n < totalCells)
        {
            StoneCell *cell = [[StoneCell alloc] initWithStonePanel:self coord:ccp(n %  (int)gridSize.width, n / (int)gridSize.width)];
            [cellGrid addObject:cell];
            [cell release];
            
            n++;
        }
        
        // 添加效果层
        effectLayer = [[CCLayer alloc] init];
        [self addChild:effectLayer z:2 tag:kTagStonePanelEffectLayer];
    }
    
    
    return self;
}

-(void) dealloc
{
    [cellGrid release];
    [allStoneSpriteDict release];
    [allStoneItems release];
    [effectLayer release];
    [super dealloc];
}

-(int) continueDispose
{
    return continueDispose;
}

-(void) setContinueDispose:(int)value
{
    continueDispose = value;
    
    
}

-(void) addEffectSprite:(EffectSprite*)effectSprite
{
    [effectLayer addChild:effectSprite];
}

-(void) disposeStonesWithStoneVoList:(CCArray *)disList specialType:(int)specialType specialStoneVoList:(CCArray *)speList
{
    
}

#pragma mark -
#pragma mark StoneItem

-(StoneSprite*) getStoneSprite:(NSString*)jewelId
{
    return [allStoneSpriteDict objectForKey:jewelId];
}

/// 创建宝石
-(void) createStoneSprite:(JewelVo*)stoneVo
{
    StoneSprite *stoneItem = [[StoneSprite alloc] initWithStonePanel:self stoneVo:stoneVo];
    
    [self addStoneSprite:stoneItem];
    
    // relese because add stone item has retained it
    [stoneItem release];
}

/// 添加宝石
-(void) addStoneSprite:(StoneSprite*)stoneSprite
{
    [self addChild:stoneSprite];
    [allStoneSpriteDict setObject:stoneSprite forKey:stoneSprite.jewelId];
    [allStoneItems addObject:stoneSprite];
    
    // 记录
    StoneCell *cell = [self getCellAtCoord:stoneSprite.stoneVo.coord];
    cell.comingStoneId = stoneSprite.jewelId;
    
}

/// 删除宝石
-(void) removeStoneItem:(StoneSprite*)stoneItem
{
    [allStoneSpriteDict removeObjectForKey:stoneItem.jewelId];
    [allStoneItems removeObject:stoneItem];
}

-(void) clearAllStoneSprites
{
    //
    if (allStoneItems.count == 0)
    {
        return;
    }
    
    for(StoneSprite *stoneSprite in allStoneItems)
    {
        [stoneSprite moveToDead];
    }
}

#pragma mark -
#pragma mark StoneCell

/// 获取指定坐标的宝石格子
-(StoneCell*) getCellAtCoord:(CGPoint)coord
{
    if (coord.x < 0 || coord.y < 0 || coord.x >= gridSize.width || coord.y >= gridSize.height)
    {
        return nil;
    }
    
    return [cellGrid objectAtIndex:coord.x + coord.y * gridSize.width];
}

/// 获取指定像素的宝石格子
-(StoneCell*) getCellAtPosition:(CGPoint)position
{
    CGPoint coord = [self positionToCellCoord:position];
    return [self getCellAtCoord:coord];
}

/// 将像素转变为坐标
-(CGPoint) positionToCellCoord:(CGPoint)pos
{
    int coordX = pos.x / cellSize.width;
    int coordY = ((gridSize.height * cellSize.height) - pos.y) / cellSize.height;
    return ccp(coordX,coordY);
}

-(CGPoint) cellCoordToPosition:(CGPoint)coord
{
    return ccp(coord.x * cellSize.width + cellSize.width/2, ((gridSize.height - coord.y -1) * cellSize.height) + cellSize.height/2);
}





@end
