//
//  JewelPanel.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelPanel.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "JewelCell.h"
#import "Constants.h"
#import "GameController.h"
#import "JewelManager.h"

@implementation JewelPanel

@synthesize gridSize,cellSize,continueDispose;
-(id) init
{
    if ((self = [super init]))
    {
        controller = [[JewelManager alloc] initWithJewelPanel:self];
        allJewelSpriteDict = [[NSMutableDictionary alloc] init];
        allJewelSprites = [[CCArray alloc] initWithCapacity:30];
        
        // 设置格子宽高
        gridSize = CGSizeMake(5, 7);
        cellSize = CGSizeMake([KITApp scale:41], [KITApp scale:41]);
        
        // 初始化宝石格子
        int totalCells = gridSize.width * gridSize.height;
        cellGrid = [[CCArray alloc] initWithCapacity:totalCells];
        int n = 0;
        while (n < totalCells)
        {
            JewelCell *cell = [[JewelCell alloc] initWithJewelPanel:self coord:ccp(n %  (int)gridSize.width, n / (int)gridSize.width)];
            [cellGrid addObject:cell];
            [cell release];
            
            n++;
        }
        
        // 添加效果层
        effectLayer = [[CCLayer alloc] init];
        [self addChild:effectLayer z:2 tag:kTagJewelPanelEffectLayer];
    }
    
    
    return self;
}

-(void) dealloc
{
    [cellGrid release];
    [allJewelSpriteDict release];
    [allJewelSprites release];
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

-(void) disposeJewelsWithJewelVoList:(CCArray *)disList specialType:(int)specialType specialJewelVoList:(CCArray *)speList
{
    
}

#pragma mark -
#pragma mark JewelItem

-(JewelSprite*) getJewelSprite:(NSString*)jewelId
{
    return [allJewelSpriteDict objectForKey:jewelId];
}

/// 创建宝石
-(void) createJewelSprite:(JewelVo*)jewelVo
{
    JewelSprite *jewelSprite = [[JewelSprite alloc] initWithJewelPanel:self jewelVo:jewelVo];
    
    [self addJewelSprite:jewelSprite];
    
    // relese because add jewel item has retained it
    [jewelSprite release];
}

/// 添加宝石
-(void) addJewelSprite:(JewelSprite*)jewelSprite
{
    [self addChild:jewelSprite];
    [allJewelSpriteDict setObject:jewelSprite forKey:jewelSprite.jewelId];
    [allJewelSprites addObject:jewelSprite];
    
    // 记录
    JewelCell *cell = [self getCellAtCoord:jewelSprite.jewelVo.coord];
    cell.comingJewelId = jewelSprite.jewelId;
    
}

/// 删除宝石
-(void) removeJewelSprite:(JewelSprite*)jewelSprite
{
    [allJewelSpriteDict removeObjectForKey:jewelSprite.jewelId];
    [allJewelSprites removeObject:jewelSprite];
}

-(void) clearAllJewelSprites
{
    //
    if (allJewelSprites.count == 0)
    {
        return;
    }
    
    for(JewelSprite *jewelSprite in allJewelSprites)
    {
        [jewelSprite moveToDead];
    }
}

#pragma mark -
#pragma mark JewelCell

/// 获取指定坐标的宝石格子
-(JewelCell*) getCellAtCoord:(CGPoint)coord
{
    if (coord.x < 0 || coord.y < 0 || coord.x >= gridSize.width || coord.y >= gridSize.height)
    {
        return nil;
    }
    
    return [cellGrid objectAtIndex:coord.x + coord.y * gridSize.width];
}

/// 获取指定像素的宝石格子
-(JewelCell*) getCellAtPosition:(CGPoint)position
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
