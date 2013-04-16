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
#import "JewelArea.h"
#import "Constants.h"
#import "GameController.h"
#import "JewelController.h"
#import "JewelSwapAction.h"

@interface JewelPanel()
{
    BOOL registeredWithDispatcher; //
    
    BOOL touchInProgress; //
    BOOL isPressDown; // 是否按下
    CGPoint touchDistance;
    JewelSprite *selectedJewel; // 选中的宝石全局标识
}

-(void) registerWithTouchDispatcher;

-(void) unregisterWithTouchDispatcher;

@end

@implementation JewelPanel

@synthesize gridSize,cellSize,continueDispose,isControlEnabled,jewelController,team;

-(id) init
{
    if ((self = [super init]))
    {
       
    }
    
    
    return self;
}

-(void) didLoadFromCCB
{
    allJewelSpriteDict = [[NSMutableDictionary alloc] init];
    allJewelSprites = [[CCArray alloc] initWithCapacity:30];
    
    // 设置格子宽高
    gridSize = CGSizeMake(5, 7);
    cellSize = CGSizeMake(60,60);
    
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
    
    // 添加BatchNode
    
    jewelBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"jewel_resources.png"];
    [self addChild:jewelBatchNode z:1 tag:-1];
    
    // 添加效果层
    effectLayer = [[CCLayer alloc] init];
    [self addChild:effectLayer z:2 tag:kTagEffectLayer];
}

-(void) dealloc
{
    [cellGrid release];
    [allJewelSpriteDict release];
    [allJewelSprites release];
    [effectLayer release];
    [super dealloc];
}

#pragma mark -
#pragma mark Touch

-(void) active
{
    self.touchEnabled = YES;
    [[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:1 swallowsTouches:NO];
}

-(void) deactive
{
    self.touchEnabled = NO;
    [[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
}

/// 判断是否点击了指定节点
-(BOOL) touch:(UITouch*)touch hitNode:(CCNode*)node
{
    CGRect r = node.boundingBox;
    CGPoint local = [self convertTouchToNodeSpace:touch];
    return CGRectContainsPoint(r, local);
}


-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!isControlEnabled)
    {
        return NO;
    }
   
        // 获取触摸点坐标
    CGPoint local = [self convertTouchToNodeSpace:touch];
    JewelSprite *js = [self getCellAtPosition:local].jewelSprite;
    if (js!=nil)
    {
        // 记录已经选中
        if (selectedJewel != nil && selectedJewel!=js)
        {
            if (ccpDistance(js.coord, selectedJewel.coord)==1)
            {
                // 交换宝石
                [self doSwapJewel1:selectedJewel withJewel2:js];
                [self unselectJewel];
                return NO;
            }
        }
        
        [self selectJewel:js];
        return YES;
    }
    
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (selectedJewel!=nil)
    {
        // 获取触摸点坐标
        CGPoint touchPos = [self convertTouchToNodeSpace:touch];
        JewelCell *cell = [self getCellAtPosition:touchPos];
        if (cell && ccpDistance(cell.coord, selectedJewel.coord)==1)
        {
            [self doSwapJewel1:selectedJewel withJewel2:cell.jewelSprite];
            [self unselectJewel];
        }
    }
}


-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    
}

-(void) ccTouchCancelled:(UITouch *)touch withEvent:(UIEvent *)event
{
}

-(void) selectJewel:(JewelSprite*)js
{
    [self unselectJewel];
    
    selectedJewel = js;
    
    // 显示选中效果
    KITProfile *profile = [KITProfile profileWithName:@"jewel_graphics"];
    CCAnimation *selectedAnim = [profile animationForKey:@"jewelSelected"];
    EffectSprite *selectedEffect = [[EffectSprite alloc] init];
    [selectedEffect animate:selectedAnim tag:-1 repeat:YES restore:NO];
    selectedEffect.position = js.position;
    [js addEffect:selectedEffect withKey:kJewelEffectSelected];
    [selectedEffect release];
    
}

-(void) unselectJewel
{
    if (selectedJewel)
    {
        [selectedJewel deleteEffectWithKey:kJewelEffectSelected];
        selectedJewel = nil;
    }
}

-(void) doSwapJewel1:(JewelSprite*)jewel1 withJewel2:(JewelSprite*)jewel2
{
   JewelSwapAction *action = [[JewelSwapAction alloc] initWithJewelController:jewelController jewel1:jewel1 jewel2:jewel2];//
    [self.jewelController queueAction:action top:NO];
    [action release];
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

-(JewelSprite*) getJewelSpriteWithGlobalId:(int)globalId
{
    return [allJewelSpriteDict objectForKey:[NSNumber numberWithInt:globalId]];
}

/// 创建宝石
-(JewelSprite*) createJewelSpriteWithJewelVo:(JewelVo*)jewelVo
{
    JewelSprite *jewelSprite = [[JewelSprite alloc] initWithJewelPanel:self jewelVo:jewelVo];
    
    [self addJewelSprite:jewelSprite];
    
    // release because add jewel sprite has retained it
    [jewelSprite release];
    
    return jewelSprite;
}

/// 添加宝石
-(void) addJewelSprite:(JewelSprite*)jewelSprite
{
    // 添加宝石到ewelsBatchNode
    [jewelBatchNode addChild:jewelSprite];
    // 添加到字典
    [allJewelSpriteDict setObject:jewelSprite forKey:[NSNumber numberWithInt:jewelSprite.globalId]];
    // 添加到集合
    [allJewelSprites addObject:jewelSprite];
    
    // 记录
    JewelCell *cell = [self getCellAtCoord:jewelSprite.jewelVo.coord];
    cell.comingJewelGlobalId = jewelSprite.globalId;
    
}

/// 删除宝石
-(void) removeJewelSprite:(JewelSprite*)jewelSprite
{
    // 删除对应数据
    [self.jewelController removeJewelVo:jewelSprite.jewelVo];
    
    // 删除表现物
    [allJewelSpriteDict removeObjectForKey:[NSNumber numberWithInt:jewelSprite.globalId]];
    [allJewelSprites removeObject:jewelSprite];
    [jewelBatchNode removeChild:jewelSprite cleanup:YES];
}

/// 删除全部宝石
-(void) removeAllJewels
{
    for (JewelSprite *js in allJewelSprites)
    {
        [jewelBatchNode removeChild:js cleanup:YES];
    }
    
    [allJewelSpriteDict removeAllObjects];
    [allJewelSprites removeAllObjects];
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


-(void) update:(ccTime)delta
{
    [self updateJewelSprites:delta];
}

-(void) updateJewelSprites:(ccTime)delta
{
    CCArray *jewelsToRemove = [[CCArray alloc] initWithCapacity:10];
    for (JewelSprite *js in allJewelSprites)
    {
        [js update:delta];
        if ([js isReadyToBeRemoved])
        {
            [jewelsToRemove addObject:js];
        }
    }
    
    if (jewelsToRemove.count>0)
    {
        for (JewelSprite *jr in jewelsToRemove)
        {
            // 清除JewelSprite
            [self removeJewelSprite:jr];
        }
    }
    [jewelsToRemove release];
}

/**
 * clip this view so that outside of the visible bounds can be hidden.
 */
-(void)beforeDraw {

		
		// TODO: This scrollview should respect parents' positions
		CGPoint screenPos = [self convertToWorldSpace:CGPointZero];
        
        glEnable(GL_SCISSOR_TEST);
        float s = [self scale];
#ifdef __CC_PLATFORM_IOS
        CCDirectorIOS *director = (CCDirectorIOS *) [CCDirector sharedDirector];
        s *= [director contentScaleFactor];
#endif
        
        glScissor(screenPos.x*s, screenPos.y*s, self.contentSize.width*s, self.contentSize.height*s);
		
}
/**
 * retract what's done in beforeDraw so that there's no side effect to
 * other nodes.
 */
-(void)afterDraw {
        glDisable(GL_SCISSOR_TEST);
}
-(void) visit
{
	// quick return if not visible
	if (!visible_)
		return;
	
	kmGLPushMatrix();
	
    //	glPushMatrix();
	
	if ( grid_ && grid_.active) {
		[grid_ beforeDraw];
		[self transformAncestors];
	}
	[self transform];
    [self beforeDraw];
	if(children_) {
		ccArray *arrayData = children_->data;
		NSUInteger i=0;
		
		// draw children zOrder < 0
		for( ; i < arrayData->num; i++ ) {
			CCNode *child =  arrayData->arr[i];
			if ( [child zOrder] < 0 ) {
				[child visit];
			} else
				break;
		}
		
		// self draw
		[self draw];
		
		// draw children zOrder >= 0
		for( ; i < arrayData->num; i++ ) {
			CCNode *child =  arrayData->arr[i];
			[child visit];
		}
        
	} else
		[self draw];
	
    [self afterDraw];
	if ( grid_ && grid_.active)
		[grid_ afterDraw:self];
	
	kmGLPopMatrix();
	
    //	glPopMatrix();
}

-(void) updateJewelGridInfo
{
    // 清理
    for (JewelCell *cell in cellGrid)
    {
        cell.jewelGlobalId = 0;
    }
    
    // 设置
    for (JewelSprite *js in allJewelSprites)
    {
        JewelCell *cell = [self getCellAtPosition:js.position];
        cell.jewelGlobalId = js.globalId;
    }
}

@end
