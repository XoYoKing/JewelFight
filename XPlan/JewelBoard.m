//
//  jewelBoard.m
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelBoard.h"
#import "JewelSprite.h"
#import "JewelVo.h"
#import "JewelCell.h"
#import "JewelArea.h"
#import "Constants.h"
#import "GameController.h"
#import "PlayerInfo.h"
#import "JewelController.h"
#import "JewelSwapAction.h"

#define kDelayBeforeHint 3 // 提示前等待时间

@interface JewelBoard()
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

@implementation JewelBoard

@synthesize gridSize,cellSize,continueDispose,isControlEnabled,jewelController,team,lastMoveTime;

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(void) didLoadFromCCB
{
    // 添加BatchNode
    jewelBatchNode = [CCSpriteBatchNode batchNodeWithFile:@"jewel_resources.png"];
    [self addChild:jewelBatchNode z:1 tag:-1];
    
    // 添加效果层
    effectLayer = [CCLayer node];
    [self addChild:effectLayer z:2 tag:kTagEffectLayer];
    
    // 添加提示层
    hintLayer = [CCLayer node];
    [self addChild:hintLayer z:3 tag:kTagHintLayer];
    
    [self setupBoard];
    _isDisplayingHint = NO; // 设置显示提示状态
    
    lastMoveTime = [[NSDate date] timeIntervalSince1970];
    
}

/// 初始化宝石面板
-(void) setupBoard
{
    allJewelSpriteDict = [[NSMutableDictionary alloc] init];
    allJewelSprites = [[CCArray alloc] initWithCapacity:30];
    
    // 设置格子宽高
    gridSize = CGSizeMake(kJewelBoardWidth, kJewelBoardHeight);
    cellSize = CGSizeMake(41,41);
    
    // 初始化宝石格子
    int totalCells = gridSize.width * gridSize.height;
    cellGrid = [[CCArray alloc] initWithCapacity:totalCells];
    int n = 0;
    while (n < totalCells)
    {
        JewelCell *cell = [[JewelCell alloc] initWithJewelBoard:self coord:ccp(n %  (int)gridSize.width, n / (int)gridSize.width)];
        [cellGrid addObject:cell];
        [cell release];
        
        n++;
    }

    // 
    numJewelsInColumn = [[CCArray alloc] initWithCapacity:gridSize.width];
    timeSinceAddInColumn = [[CCArray alloc] initWithCapacity:gridSize.width];
    for (int i = 0; i< gridSize.width; i++)
    {
        [numJewelsInColumn addObject:[NSNumber numberWithInt:0]];
        [timeSinceAddInColumn addObject:[NSNumber numberWithFloat:0]];
    }

    // 下落宝石集合
    fallingJewels = [[CCArray alloc] initWithCapacity:gridSize.width];
    for (int i =0; i< gridSize.width;i++)
    {
        CCArray *list = [[CCArray alloc] initWithCapacity:5];
        [fallingJewels addObject:list];
        [list release];
    }
    boardChangedSinceEvaluation = YES;
    possibleEliminates = [[CCArray alloc] initWithCapacity:5];
}

-(void) dealloc
{
    [cellGrid release];
    [allJewelSpriteDict release];
    [allJewelSprites release];
    [fallingJewels release];
    [numJewelsInColumn release];
    [timeSinceAddInColumn release];
    [possibleEliminates release];
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
    [hintLayer removeAllChildrenWithCleanup:YES];
    _isDisplayingHint = NO; // 设置显示提示状态
    
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
    [hintLayer removeAllChildrenWithCleanup:YES];
    _isDisplayingHint = NO; // 设置显示提示状态
    
   JewelSwapAction *action = [[JewelSwapAction alloc] initWithJewelController:jewelController jewel1:jewel1 jewel2:jewel2];//
    [self.jewelController queueAction:action top:NO];
    [action release];
    
    lastMoveTime = [[NSDate date] timeIntervalSince1970];
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
    JewelSprite *jewelSprite = [[JewelSprite alloc] initWithJewelBoard:self jewelVo:jewelVo];
    
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
    
    if (jewelController.userId == [GameController sharedController].player.userId)
    {
        // 计时器
        NSDate *currentDate = [NSDate date];
        double currentTime = [currentDate timeIntervalSince1970];
        
        // 显示提示
        if (currentTime - lastMoveTime > kDelayBeforeHint && !_isDisplayingHint)
        {
            [self displayHint];
        }
    }
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
	if (!_visible)
		return;
	
	kmGLPushMatrix();
	
    //	glPushMatrix();
	
	if ( _grid && _grid.active) {
		[_grid beforeDraw];
		[self transformAncestors];
	}
	[self transform];
    [self beforeDraw];
	if(_children) {
		ccArray *arrayData = _children->data;
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
	if ( _grid && _grid.active)
		[_grid afterDraw:self];
	
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

#pragma mark -
#pragma mark Eliminate Jewels

/// 检查水平方向的可消除的宝石
-(void) findHorizontalEliminableJewels:(CCArray*)elimList withJewel:(JewelSprite*)source
{
    CCArray *connectedList = [[CCArray alloc] initWithCapacity:10];
    
    // 自身加入进去
    [connectedList addObject:source];
    
    JewelSprite *specialJewel; // 特殊宝石
    
    // 检查特殊宝石
    if (source.jewelVo.special >= kJewelSpecialExplode)
    {
        specialJewel = source;
    }
    
    // 向左侧检查
    JewelSprite *leftJewel = [self getCellAtCoord:ccp(source.coord.x-1,source.coord.y)].jewelSprite;
    while (leftJewel!=nil && leftJewel.jewelVo.jewelId == source.jewelVo.jewelId)
    {
        // 检查特殊宝石
        if (leftJewel.jewelVo.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.jewelVo.special < leftJewel.jewelVo.special)
            {
                specialJewel = leftJewel;
            }
        }
        
        // 添加到相同类型集合中
        [connectedList insertObject:leftJewel atIndex:0];
        leftJewel = [self getCellAtCoord:ccp(leftJewel.coord.x-1,leftJewel.coord.y)].jewelSprite;
    }
    
    // 向右侧检查
    JewelSprite *rightJewel= [self getCellAtCoord:ccp(source.coord.x+1,source.coord.y)].jewelSprite;
    while (rightJewel!=nil && rightJewel.jewelId == source.jewelId)
    {
        if (rightJewel.jewelVo.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.jewelVo.special < rightJewel.jewelVo.special)
            {
                specialJewel = rightJewel;
            }
        }
        
        // 添加到检查列表
        [connectedList addObject:rightJewel];
        rightJewel= [self getCellAtCoord:ccp(rightJewel.coord.x+1,rightJewel.coord.y)].jewelSprite;
    }
    
    // 至少3个相同类型的宝石才能消除
    if (connectedList.count >= kJewelEliminateMinNeed)
    {
        BOOL isBoo = NO; // 爆炸标识
        for (JewelSprite *connectSprite in connectedList)
        {
            // 标记参与的横向消除
            connectSprite.jewelVo.hEliminate = connectedList.count; // 横向消除数量
            if (connectSprite.jewelVo.lt)
            {
                // 产生一个爆炸
                isBoo = YES;
                [self resetEliminateTop:connectSprite];
            }
        }
        
        if (connectedList.count >= kJewelSpecialExplode && isBoo == NO)
        {
            [[connectedList lastObject] setEliminateRight:YES];
        }
        
        // 加入消除列表
        [elimList addObjectsFromArray:connectedList];
    }
    
    [connectedList release];
}

/// 检查垂直方向的可消除的宝石
-(void) findVerticalEliminableJewels:(CCArray*)elimList withJewel:(JewelSprite*)source
{
    // 创建一个检查列表
    CCArray *connectedList = [[CCArray alloc] initWithCapacity:10];
    [connectedList addObject:source];
    
    JewelSprite *specialJewel;
    
    // 检查特殊宝石
    if (source.jewelVo.special >= kJewelSpecialExplode)
    {
        specialJewel = source;
    }
    
    // 上方检查
    // 获取上方宝石
    JewelSprite *upJewel = [self getCellAtCoord:ccp(source.coord.x,source.coord.y-1)].jewelSprite;
    while (upJewel!=nil && upJewel.jewelId == source.jewelId)
    {
        // 检查特殊宝石
        if (upJewel.jewelVo.special >= kJewelSpecialExplode)
        {
            if (upJewel == nil || specialJewel.jewelVo.special < upJewel.jewelVo.special)
            {
                specialJewel = upJewel;
            }
        }
        
        // 符合条件,加入检查列表
        [connectedList insertObject:upJewel atIndex:0];
        upJewel = [self getCellAtCoord:ccp(upJewel.coord.x,upJewel.coord.y-1)].jewelSprite;
    }
    
    // 检测下方
    JewelSprite *downJewel= [self getCellAtCoord:ccp(source.coord.x,source.coord.y + 1)].jewelSprite;
    while (downJewel!=nil && downJewel.jewelId == source.jewelId)
    {
        if (downJewel.jewelVo.special >= kJewelSpecialExplode)
        {
            if (specialJewel == nil || specialJewel.jewelVo.special < downJewel.jewelVo.special)
            {
                specialJewel = downJewel;
            }
        }
        
        // 符合条件,加入检查列表
        [connectedList addObject:downJewel];
        downJewel= [self getCellAtCoord:ccp(downJewel.coord.x,downJewel.coord.y + 1)].jewelSprite;
    }
    
    // 至少3个相同类型的宝石才能消除
    if (connectedList.count >= kJewelEliminateMinNeed)
    {
        BOOL isBoo;
        for (JewelSprite *checkSprite in connectedList)
        {
            checkSprite.jewelVo.hEliminate = connectedList.count; // 横向消除数量
            if (checkSprite.jewelVo.lt)
            {
                isBoo = YES;
                [self resetEliminateRight:checkSprite];
            }
        }
        
        if (connectedList.count >= kJewelSpecialExplode && isBoo == NO)
        {
            [[connectedList lastObject] setEliminateTop:YES];
        }
        
        // 加入消除列表
        [elimList addObjectsFromArray:connectedList];
    }
    
    [connectedList release];
}

/// 重置上方消除状态
-(void) resetEliminateTop:(JewelSprite*)source
{
    // 向上检查
    JewelSprite *upJewel = [self getCellAtCoord:ccp(source.coord.x,source.coord.y -1)].jewelSprite;
    while(upJewel!=nil && upJewel.jewelId == source.jewelId)
    {
        upJewel.jewelVo.eliminateTop = NO;
        upJewel = [self getCellAtCoord:ccp(upJewel.coord.x,upJewel.coord.y -1)].jewelSprite;
    }
    
    
    // 向下检查
    JewelSprite *downJewel = [self getCellAtCoord:ccp(source.coord.x,source.coord.y +  1)].jewelSprite;
    while (downJewel!=nil && downJewel.jewelId == source.jewelId)
    {
        downJewel.jewelVo.eliminateTop = YES;
        downJewel = [self getCellAtCoord:ccp(downJewel.coord.x,downJewel.coord.y +  1)].jewelSprite;
    }
}

/// 重置右侧消除状态
-(void) resetEliminateRight:(JewelSprite*)source
{
    // 左边
    JewelSprite *leftJewel = [self getCellAtCoord:ccp(source.coord.x-1,source.coord.y)].jewelSprite;
    while(leftJewel!=nil && leftJewel.jewelId == source.jewelId)
    {   
        leftJewel.jewelVo.eliminateRight = NO;
        leftJewel = [self getCellAtCoord:ccp(leftJewel.coord.x-1,leftJewel.coord.y)].jewelSprite;
    }
    
    // 右侧
    JewelSprite *rightJewel = [self getCellAtCoord:ccp(source.coord.x+1,source.coord.y)].jewelSprite;
    while (rightJewel!=nil && rightJewel.jewelId == source.jewelId)
    {
        rightJewel.jewelVo.eliminateRight = NO;
        rightJewel = [self getCellAtCoord:ccp(rightJewel.coord.x+1,rightJewel.coord.y)].jewelSprite;
    }
}


/// 检查死局
-(BOOL) checkDead
{
    for (JewelSprite *js in allJewelSprites)
    {
        if ([self isVerticalPossibleEliminateWithJewelSprite:js])
        {
            return NO;
        }
        
        if ([self isHorizontalPossibleEliminateWithJewelSprite:js])
        {
            return NO;
        }
    }
    
    return YES;
}

/// 检查水平方向是否有可消除的宝石
-(BOOL) isHorizontalPossibleEliminateWithJewelSprite:(JewelSprite*)center
{
    CCArray *leftList = [[CCArray alloc] initWithCapacity:gridSize.height];
    CCArray *middleList = [[CCArray alloc] initWithCapacity:gridSize.height];
    CCArray *rightList = [[CCArray alloc] initWithCapacity:gridSize.height];
   
    BOOL can = [self isHorizontalPossibleEliminateWithJewelSprite:center leftList:leftList middleList:middleList rightList:rightList];

    [middleList release];
    [leftList release];
    [rightList release];
    
    return can;
}

/// 检查水平方向是否有可消除的宝石并填充相同宝石集合
-(BOOL) isHorizontalPossibleEliminateWithJewelSprite:(JewelSprite*)center leftList:(CCArray*)leftList middleList:(CCArray*)middleList rightList:(CCArray*)rightList
{
    // 获取可消除的宝石集合
    int skipCount = 0;
    
    // 添加自身
    [middleList addObject:center];
    
    // 向左检测
    JewelSprite *check = [self getCellAtCoord:ccp(center.coord.x-1,center.coord.y)].jewelSprite;
    while (check!=nil)
    {
        if (check.jewelId != center.jewelId)
        {
            skipCount++;
            
            // 只能跳过一个
            if (skipCount>1)
            {
                break;
            }
            
            // 检测垂直方向是否有相同类型的宝石
            JewelCell *topCell = [self getCellAtCoord:ccp(check.coord.x,check.coord.y-1)];
            if (topCell && topCell.jewelSprite.jewelId == center.jewelId)
            {
                [leftList addObject:topCell.jewelSprite];
            }
            else
            {
                JewelCell *bottomCell = [self getCellAtCoord:ccp(check.coord.x,check.coord.y+1)];
                if (bottomCell && bottomCell.jewelSprite.jewelId == center.jewelId)
                {
                    [leftList addObject:bottomCell.jewelSprite];
                }
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
    //skipCount = 0;
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
            JewelCell *topCell = [self getCellAtCoord:ccp(check.coord.x,check.coord.y-1)];
            if (topCell && topCell.jewelSprite.jewelId == center.jewelId)
            {
                [rightList addObject:topCell.jewelSprite];
            }
            else
            {
                JewelCell *bottomCell = [self getCellAtCoord:ccp(check.coord.x,check.coord.y+1)];
                if (bottomCell && bottomCell.jewelSprite.jewelId == center.jewelId)
                {
                    [rightList addObject:bottomCell.jewelSprite];
                }
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
    
    return life;
}

/// 检测水平方向死局
-(BOOL) isVerticalPossibleEliminateWithJewelSprite:(JewelSprite*)center
{
    CCArray *topList = [[CCArray alloc] initWithCapacity:gridSize.width];
    CCArray *middleList = [[CCArray alloc] initWithCapacity:gridSize.width];
    CCArray *bottomList = [[CCArray alloc] initWithCapacity:gridSize.width];
    
    BOOL can = [self isVerticalPossibleEliminateWithJewelSprite:center topList:topList middleList:middleList bottomList:bottomList];
    
    [middleList release];
    [topList release];
    [bottomList release];
    
    return can;
}

/// 寻找垂直方向的相同类型的宝石集合并填充相同宝石集合
-(BOOL) isVerticalPossibleEliminateWithJewelSprite:(JewelSprite*)center topList:(CCArray*)topList middleList:(CCArray*)middleList bottomList:(CCArray*)bottomList
{
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
            JewelCell *leftCell = [self getCellAtCoord:ccp(check.coord.x-1,check.coord.y)];
            if (leftCell && leftCell.jewelSprite.jewelId == center.jewelId)
            {
                [topList addObject:leftCell.jewelSprite];
            }
            else
            {
                JewelCell *rightCell = [self getCellAtCoord:ccp(check.coord.x+1,check.coord.y)];
                if (rightCell && rightCell.jewelSprite.jewelId == center.jewelId)
                {
                    [topList addObject:rightCell.jewelSprite];
                }
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
    //skipCount = 0;
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
            JewelCell *leftCell = [self getCellAtCoord:ccp(check.coord.x-1,check.coord.y)];
            if (leftCell && leftCell.jewelSprite.jewelId == center.jewelId)
            {
                [bottomList addObject:leftCell.jewelSprite];
            }
            else
            {
                JewelCell *rightCell = [self getCellAtCoord:ccp(check.coord.x+1,check.coord.y)];
                if (rightCell && rightCell.jewelSprite.jewelId == center.jewelId)
                {
                    [bottomList addObject:rightCell.jewelSprite];
                }
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
    
    return life;
}


/// 宝石是否满的
-(BOOL) isFull
{
    return allJewelSprites.count == gridSize.width * gridSize.height;
}


/// 寻找可消除的宝石
-(CCArray*) findPossibleEliminateJewels
{
    if (!boardChangedSinceEvaluation)
    {
        return possibleEliminates;
    }
    
    // 清理
    [possibleEliminates removeAllObjects];
    
    for (int i = 0; i < gridSize.width; i++)
    {
        for (int j = 0; j < gridSize.height; j++)
        {
            JewelCell *cell = [self getCellAtCoord:ccp(i,j)];
            // 检查是否有宝石
            if (!cell.jewelSprite)
            {
                continue;
            }
            
            // 检查水平方向是否可消除
            CCArray *leftList = [[CCArray alloc] initWithCapacity:5];
            CCArray *middleList = [[CCArray alloc] initWithCapacity:5];
            CCArray *rightList = [[CCArray alloc] initWithCapacity:5];
            
            // 检查水平方向可消除的宝石
            if ([self isHorizontalPossibleEliminateWithJewelSprite:cell.jewelSprite leftList:leftList middleList:middleList rightList:rightList])
            {
                [possibleEliminates addObjectsFromArray:leftList];
                [possibleEliminates addObjectsFromArray:middleList];
                [possibleEliminates addObjectsFromArray:rightList];
            }
            
            [leftList release];
            [middleList release];
            [rightList release];
            
            // 检查可移动宝石是否已经找到
            if (possibleEliminates.count>0)
            {
                return possibleEliminates;
            }
            
            // 检查垂直方向是否可消除
            // 检查水平方向是否可消除
            CCArray *topList = [[CCArray alloc] initWithCapacity:5];
            middleList = [[CCArray alloc] initWithCapacity:5];
            CCArray *bottomList = [[CCArray alloc] initWithCapacity:5];
            
            // 检查垂直方向可消除的宝石
            if ([self isVerticalPossibleEliminateWithJewelSprite:cell.jewelSprite topList:topList middleList:middleList bottomList:rightList])
            {
                [possibleEliminates addObjectsFromArray:topList];
                [possibleEliminates addObjectsFromArray:middleList];
                [possibleEliminates addObjectsFromArray:bottomList];
            }
            
            [topList release];
            [middleList release];
            [bottomList release];
            
            // 检查可移动宝石是否已经找到
            if (possibleEliminates.count > 0)
            {
                return possibleEliminates;
            }
        }
    }
    
    // 未找到
    boardChangedSinceEvaluation = NO;
    [possibleEliminates removeAllObjects];
    return possibleEliminates;
}

/// 显示宝石消除提示
-(void) displayHint
{
    CCArray *jewels = [self findPossibleEliminateJewels];
        _isDisplayingHint = YES;
        
    for (JewelSprite *js in jewels)
    {
        CCAction *action = [CCRepeatForever actionWithAction:[CCSequence actions:
                             [CCFadeIn actionWithDuration:0.5f],
                             [CCFadeOut actionWithDuration:0.5f],
                            nil]];
        EffectSprite *hintSprite = [[EffectSprite alloc] initWithFile:@"hint.png"];
        hintSprite.position = js.position;
        [hintLayer addChild:hintSprite];
        [hintSprite runAction:action];
    }
}

@end
