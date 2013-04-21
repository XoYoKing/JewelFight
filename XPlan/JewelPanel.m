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
#pragma mark JewelSprite

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
        
        [self updateJewelGridInfo];
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
        JewelCell *cell = [self getCellAtCoord:js.jewelVo.coord];
        cell.jewelGlobalId = js.globalId;
    }
}



/// 检查水平方向的可消除的宝石
-(void) checkHorizontalEliminableJewels:(CCArray*)elimList withJewel:(JewelSprite*)source
{
    CCArray *checkList = [[CCArray alloc] initWithCapacity:10];
    
    // 自身加入进去
    [checkList addObject:source];
    
    JewelSprite *specialJewel; // 特殊宝石
    
    // 检查特殊宝石
    if (source.jewelVo.special >= kJewelSpecialExplode)
    {
        specialJewel = source;
    }
    
    // 向左侧检查
    JewelSprite *temp = source;
    while (temp.coord.x -1 >=0)
    {
        // 获取左侧宝石
        JewelSprite *leftJewel = [self getCellAtCoord:ccp(temp.coord.x-1,temp.coord.y)].jewelSprite;
        
        // 不是相同类型的宝石,退出
        if (leftJewel.jewelVo.jewelId != source.jewelVo.jewelId)
        {
            break;
        }
        
        // 检查特殊宝石
        if (leftJewel.jewelVo.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.jewelVo.special < leftJewel.jewelVo.special)
            {
                specialJewel = leftJewel;
            }
        }
        
        // 添加到相同类型集合中
        [checkList insertObject:leftJewel atIndex:0];
        temp = leftJewel; // 设置下一个
    }
    
    // 向右侧检查
    temp = source;
    while (temp.coord.x + 1 <kJewelGridWidth)
    {
        JewelSprite *rightJewel= [self getCellAtCoord:ccp(temp.coord.x+1,temp.coord.y)].jewelSprite;
        if (rightJewel.jewelVo.jewelId != source.jewelVo.jewelId)
        {
            break;
        }
        
        if (rightJewel.jewelVo.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.jewelVo.special < rightJewel.jewelVo.special)
            {
                specialJewel = rightJewel;
            }
        }
        
        // 添加到检查列表
        [checkList addObject:rightJewel];
        temp = rightJewel;
    }
    
    // 至少3个相同类型的宝石才能消除
    if (checkList.count >= 3)
    {
        BOOL isBoo; // 爆炸标识
        for (JewelSprite *checkSprite in checkList)
        {
            // 标记参与的横向消除
            checkSprite.jewelVo.hEliminate = checkList.count; // 横向消除数量
            if (checkSprite.jewelVo.lt)
            {
                // 产生一个爆炸
                isBoo = YES;
                [self resetEliminateTop:checkSprite];
            }
        }
        
        if (checkList.count >= kJewelSpecialExplode && isBoo == NO)
        {
            [[checkList lastObject] setEliminateRight:YES];
        }
        
        // 加入消除列表
        [elimList addObjectsFromArray:checkList];
    }
    
    [checkList release];
}

/// 检查垂直方向的可消除的宝石
-(void) checkVerticalEliminableJewels:(CCArray*)elimList withJewel:(JewelSprite*)source
{
    // 创建一个检查列表
    CCArray *checkList = [[CCArray alloc] initWithCapacity:10];
    [checkList addObject:source];
    
    JewelSprite *specialJewel;
    
    // 检查特殊宝石
    if (source.jewelVo.special >= kJewelSpecialExplode)
    {
        specialJewel = source;
    }
    
    // 上方检查
    JewelSprite *temp = source;
    while (temp.coord.y-1 >=0)
    {
        // 获取上方宝石
        JewelSprite *upJewel = [self getCellAtCoord:ccp(temp.coord.x,temp.coord.y-1)].jewelSprite;
        
        // 不是相同类型,退出
        if (upJewel.jewelVo.jewelId != source.jewelVo.jewelId)
        {
            break;
        }
        
        // 检查特殊宝石
        if (upJewel.jewelVo.special >= kJewelSpecialExplode)
        {
            if (upJewel == nil || specialJewel.jewelVo.special < upJewel.jewelVo.special)
            {
                specialJewel = upJewel;
            }
        }
        
        // 符合条件,加入检查列表
        [checkList insertObject:upJewel atIndex:0];
        temp = upJewel;
    }
    
    // 检测下方
    temp = source;
    while (temp.coord.y + 1 <kJewelGridHeight)
    {
        JewelSprite *downJewel= [self getCellAtCoord:ccp(temp.coord.x,temp.coord.y + 1)].jewelSprite;
        if (downJewel.jewelVo.jewelId!=source.jewelVo.jewelId)
        {
            break;
        }
        
        if (downJewel.jewelVo.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.jewelVo.special < downJewel.jewelVo.special)
            {
                specialJewel = downJewel;
            }
        }
        
        // 符合条件,加入检查列表
        [checkList addObject:downJewel];
        temp = downJewel;
    }
    
    // 至少3个相同类型的宝石才能消除
    if (checkList.count >= kJewelEliminateMinNeed)
    {
        BOOL isBoo;
        for (JewelSprite *checkSprite in checkList)
        {
            checkSprite.jewelVo.hEliminate = checkList.count; // 横向消除数量
            if (checkSprite.jewelVo.lt)
            {
                isBoo = YES;
                [self resetEliminateRight:checkSprite];
            }
        }
        
        if (checkList.count >= kJewelSpecialExplode && isBoo == NO)
        {
            [[checkList lastObject] setEliminateTop:YES];
        }
        
        // 加入消除列表
        [elimList addObjectsFromArray:checkList];
    }
    
    [checkList release];
}

/// 重置上方消除状态
-(void) resetEliminateTop:(JewelSprite*)source
{
    // 向上检查
    JewelSprite *temp = source;
    while(temp.coord.y - 1 >= 0)
    {
        JewelSprite *upJewel = [self getCellAtCoord:ccp(temp.coord.x,temp.coord.y -1)].jewelSprite;
        if (upJewel.jewelVo.jewelId != source.jewelVo.jewelId)
        {
            break;
        }
        
        upJewel.jewelVo.eliminateTop = NO;
        temp = upJewel;
    }
    
    
    // 向下检查
    temp = source;
    while (temp.coord.y+1 <kJewelGridHeight)
    {
        JewelSprite *downJewel = [self getCellAtCoord:ccp(temp.coord.x,temp.coord.y +  1)].jewelSprite;
        if (downJewel.jewelVo.jewelId != source.jewelVo.jewelId)
        {
            break;
        }
        
        downJewel.jewelVo.eliminateTop = YES;
        temp = downJewel;
    }
}

/// 重置右侧消除状态
-(void) resetEliminateRight:(JewelSprite*)source
{
    // 左边
    JewelSprite *temp = source;
    while(temp.coord.x - 1 >= 0)
    {
        JewelSprite *leftJewel = [self getCellAtCoord:ccp(temp.coord.x-1,temp.coord.y)].jewelSprite;
        if (leftJewel.jewelVo.jewelId != source.jewelVo.jewelId)
        {
            break;
        }
        
        leftJewel.jewelVo.eliminateRight = NO;
        temp = leftJewel;
    }
    
    // 右侧
    temp = source;
    while (temp.coord.x+1 < kJewelGridWidth)
    {
        JewelSprite *rightJewel = [self getCellAtCoord:ccp(temp.coord.x+1,temp.coord.y)].jewelSprite;
        if (rightJewel.jewelVo.jewelId != source.jewelVo.jewelId)
        {
            break;
        }
        
        rightJewel.jewelVo.eliminateRight = NO;
        temp = rightJewel;
    }
}


/// 检查死局
-(BOOL) checkDead
{
    for (JewelSprite *js in allJewelSprites)
    {
        if ([self checkLifeVerticalWithJewelSprite:js])
        {
            return NO;
        }
        
        if ([self checkLifeHorizontalWithJewelSprite:js])
        {
            return NO;
        }
    }
    
    return YES;
}

/// 检测水平方向死局
-(BOOL) checkLifeVerticalWithJewelSprite:(JewelSprite*)center
{
    CCArray *topList = [[CCArray alloc] initWithCapacity:kJewelGridWidth];
    CCArray *middleList = [[CCArray alloc] initWithCapacity:kJewelGridWidth];
    CCArray *bottomList = [[CCArray alloc] initWithCapacity:kJewelGridWidth];
    
    int skipCount = 0;
    [middleList addObject:center];
    
    // 向上检测
    JewelSprite *check = [self getCellAtCoord:ccp(center.coord.x,center.coord.y-1)].jewelSprite;
    while (check!=nil)
    {
        if (check.jewelVo.jewelId != center.jewelVo.jewelId)
        {
            skipCount++;
            if (skipCount>1)
            {
                break;
            }
            
            // 检测水平方向是否有相同类型的宝石
            if ([self checkHorizontalEqualJewelsWithJewelSprite:check jewelId:center.jewelVo.jewelId])
            {
                [topList addObject:check];
            }
        }
        else
        {
            if (skipCount == 0)
            {
                [middleList addObject:check];
            }
            else if (skipCount == 1)
            {
                [topList addObject:check];
            }
        }
        
        check = [self getCellAtCoord:ccp(check.coord.x,check.coord.y-1)].jewelSprite;
    }
    
    // 向下检测
    skipCount = 0;
    check = [self getCellAtCoord:ccp(center.coord.x,center.coord.y+1)].jewelSprite;
    while (check!=nil)
    {
        if (check.jewelVo.jewelId != center.jewelVo.jewelId)
        {
            skipCount++;
            if (skipCount>1)
            {
                break;
            }
            
            // 检测水平方向是否有相同类型的宝石
            if ([self checkHorizontalEqualJewelsWithJewelSprite:check jewelId:center.jewelVo.jewelId])
            {
                [bottomList addObject:check];
            }
        }
        else
        {
            if (skipCount == 0)
            {
                [middleList addObject:check];
            }
            else if (skipCount == 1)
            {
                [bottomList addObject:check];
            }
        }
        
        check = [self getCellAtCoord:ccp(check.coord.x,check.coord.y+1)].jewelSprite;
    }
    
    BOOL life = middleList.count>=kJewelEliminateMinNeed || topList.count + middleList.count >= kJewelEliminateMinNeed || bottomList.count + middleList.count >= kJewelEliminateMinNeed;
    [middleList release];
    [topList release];
    [bottomList release];

    return life;
}

/// 检查水平方向是否有指定标志的宝石
-(BOOL) checkHorizontalEqualJewelsWithJewelSprite:(JewelSprite*)js jewelId:(int)jewelId
{
    JewelCell *leftCell = [self getCellAtCoord:ccp(js.coord.x-1,js.coord.y)];
    if (leftCell && leftCell.jewelSprite.jewelVo.jewelId == jewelId)
    {
        return YES;
    }
    JewelCell *rightCell = [self getCellAtCoord:ccp(js.coord.x+1,js.coord.y)];
    if (rightCell && rightCell.jewelSprite.jewelVo.jewelId == jewelId)
    {
        return YES;
    }
    
    return NO;
}

/// 检查垂直方向是否有指定标志的宝石
-(BOOL) checkVerticalEqualJewelsWithJewelSprite:(JewelSprite*)js jewelId:(int)jewelId
{
    JewelCell *topCell = [self getCellAtCoord:ccp(js.coord.x,js.coord.y-1)];
    if (topCell && topCell.jewelSprite.jewelVo.jewelId == jewelId)
    {
        return YES;
    }
    JewelCell *bottomCell = [self getCellAtCoord:ccp(js.coord.x,js.coord.y+1)];
    if (bottomCell && bottomCell.jewelSprite.jewelVo.jewelId == jewelId)
    {
        return YES;
    }
    
    return NO;
}

-(BOOL) checkLifeHorizontalWithJewelSprite:(JewelSprite*)center
{
    CCArray *leftList = [[CCArray alloc] initWithCapacity:kJewelGridHeight];
    CCArray *middleList = [[CCArray alloc] initWithCapacity:kJewelGridHeight];
    CCArray *rightList = [[CCArray alloc] initWithCapacity:kJewelGridHeight];
    
    int skipCount = 0;
    [middleList addObject:center];
    
    // 向左检测
    JewelSprite *check = [self getCellAtCoord:ccp(center.coord.x-1,center.coord.y)].jewelSprite;
    while (check!=nil)
    {
        if (check.jewelVo.jewelId != center.jewelVo.jewelId)
        {
            skipCount++;
            if (skipCount>1)
            {
                break;
            }
            
            // 检测垂直方向是否有相同类型的宝石
            if ([self checkVerticalEqualJewelsWithJewelSprite:check jewelId:center.jewelVo.jewelId])
            {
                [leftList addObject:check];
            }
        }
        else
        {
            if (skipCount == 0)
            {
                [middleList addObject:check];
            }
            else if (skipCount == 1)
            {
                [leftList addObject:check];
            }
        }
        
        check = [self getCellAtCoord:ccp(check.coord.x-1,check.coord.y)].jewelSprite;
    }
    
    // 向右检测
    skipCount = 0;
    check = [self getCellAtCoord:ccp(center.coord.x+1,center.coord.y)].jewelSprite;
    while (check!=nil)
    {
        if (check.jewelVo.jewelId != center.jewelVo.jewelId)
        {
            skipCount++;
            if (skipCount>1)
            {
                break;
            }
            
            // 检测垂直方向是否有相同类型的宝石
            if ([self checkVerticalEqualJewelsWithJewelSprite:check jewelId:center.jewelVo.jewelId])
            {
                [rightList addObject:check];
            }
        }
        else
        {
            if (skipCount == 0)
            {
                [middleList addObject:check];
            }
            else if (skipCount == 1)
            {
                [rightList addObject:check];
            }
        }
        
        check = [self getCellAtCoord:ccp(check.coord.x+1,check.coord.y)].jewelSprite;
    }
    
    BOOL life = middleList.count>=kJewelEliminateMinNeed || leftList.count + middleList.count >= kJewelEliminateMinNeed || rightList.count + middleList.count >= kJewelEliminateMinNeed;
    [middleList release];
    [leftList release];
    [rightList release];
    
    return life;
}

/// 宝石是否满的
-(BOOL) isFull
{
    return allJewelSprites.count == gridSize.width * gridSize.height;
}


@end
