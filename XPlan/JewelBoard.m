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
#import "Constants.h"
#import "GameController.h"
#import "PlayerInfo.h"
#import "JewelController.h"
#import "JewelSwapAction.h"
#import "JewelBoardData.h"

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

@synthesize cellSize,continueDispose,isControlEnabled,jewelController,team,lastMoveTime;

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(void) didLoadFromCCB
{
    // 添加闪烁层
    shimmerLayer = [CCLayer node];
    [self addChild:shimmerLayer z:-1];
    
    // 添加JewelLayer
    jewelLayer = [CCSpriteBatchNode batchNodeWithFile:@"jewel_resources.png"];
    [self addChild:jewelLayer z:0 tag:-1];
    
    particleLayer = [CCParticleBatchNode batchNodeWithFile:@"taken_jewel.png" capacity:250];
    [self addChild:particleLayer z:1 tag:kTagParticleLayer];
    
    // 添加效果层
    effectLayer = [CCLayer node];
    [self addChild:effectLayer z:2 tag:kTagEffectLayer];
    
    
    // 添加提示层
    hintLayer = [CCLayer node];
    [self addChild:hintLayer z:3 tag:kTagHintLayer];
    
    [self setupBoard];
    _isDisplayingHint = NO; // 设置显示提示状态
    
    lastMoveTime = [[NSDate date] timeIntervalSince1970];
    
    [self setupShimmer];
}

/// 初始化宝石面板
-(void) setupBoard
{
    // 设置宝石精灵字典和列表
    allJewelSpriteDict = [[NSMutableDictionary alloc] init];
    allJewelSprites = [[CCArray alloc] initWithCapacity:30];
    
    boardWidth = kJewelBoardWidth;
    boardHeight = kJewelBoardHeight;
    
    // 设置格子宽高
    cellSize = CGSizeMake(40,40);
}

-(void) dealloc
{
    [allJewelSpriteDict release];
    [allJewelSprites release];
    [super dealloc];
}

-(void) onEnter
{
    [self loadSounds];
    [super onEnter];
}

-(void) onExit
{
    [self unloadSounds];
    [super onExit];
}

#pragma mark -
#pragma mark Sound

-(void) loadSounds
{
    // 预加载音效
    [[KITSound sharedSound] loadSound:@"tap-1.wav"];
    [[KITSound sharedSound] loadSound:@"tap-2.wav"];
    [[KITSound sharedSound] loadSound:@"tap-3.wav"];
    [[KITSound sharedSound] loadSound:@"tap-0.wav"];
}

-(void) unloadSounds
{
    [[KITSound sharedSound] unloadSound:@"tap-1.wav"];
    [[KITSound sharedSound] unloadSound:@"tap-2.wav"];
    [[KITSound sharedSound] unloadSound:@"tap-3.wav"];
    [[KITSound sharedSound] unloadSound:@"tap-0.wav"];
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
    int touchJewelGlobalId = [self getCellAtPosition:local].jewelGlobalId;
    JewelSprite *js = [self getJewelSpriteWithGlobalId:touchJewelGlobalId];
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
            [self doSwapJewel1:selectedJewel withJewel2:[self getJewelSpriteWithGlobalId:cell.jewelGlobalId]];
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
    selectedEffect.anchorPoint = ccp(0,0);
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

-(void) addParticle:(CCParticleSystem *)particle
{
    [particleLayer addChild:particle];
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
    jewelSprite.anchorPoint = ccp(0,0);
    
    // 添加宝石到ewelsBatchNode
    [jewelLayer addChild:jewelSprite];
    // 添加到字典
    [allJewelSpriteDict setObject:jewelSprite forKey:[NSNumber numberWithInt:jewelSprite.globalId]];
    // 添加到集合
    [allJewelSprites addObject:jewelSprite];
}

/// 删除宝石
-(void) removeJewelSprite:(JewelSprite*)jewelSprite
{    
    // 删除表现物
    [allJewelSpriteDict removeObjectForKey:[NSNumber numberWithInt:jewelSprite.globalId]];
    [allJewelSprites removeObject:jewelSprite];
    [jewelLayer removeChild:jewelSprite cleanup:YES];
    
    // 删除数据对象
    [jewelController.boardData removeJewelVo:jewelSprite.jewelVo];
}

/// 删除全部宝石
-(void) removeAllJewels
{
    for (JewelSprite *js in allJewelSprites)
    {
        [jewelLayer removeChild:js cleanup:YES];
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

-(JewelCell*) getCellAtCoord:(CGPoint)coord
{
    return [jewelController.boardData getCellAtCoord:coord];
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
    int coordY = pos.y / cellSize.height;
    return ccp(coordX,coordY);
}

-(CGPoint) cellCoordToPosition:(CGPoint)coord
{
    return ccp(coord.x * cellSize.width, coord.y * cellSize.height);
}


-(void) update:(ccTime)delta
{
    /// 更新宝石自身逻辑
    [self updateJewelSprites:delta];
    
    // 宝石闪耀效果
    [self updateSparkle];
}

/// 更新提示信息
-(void) updateHint
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



/// 显示宝石消除提示
-(void) displayHint
{
    CCArray *jewels = [self.jewelController.boardData findPossibleEliminateJewels];
        _isDisplayingHint = YES;
        
    for (JewelVo *jv in jewels)
    {
        JewelSprite *js = [self getJewelSpriteWithGlobalId:jv.globalId];
        CCAction *action = [CCRepeatForever actionWithAction:[CCSequence actions:
                             [CCFadeIn actionWithDuration:0.5f],
                             [CCFadeOut actionWithDuration:0.5f],
                            nil]];
        EffectSprite *hintSprite = [[EffectSprite alloc] initWithFile:@"hint.png"];
        hintSprite.position = js.position;
        hintSprite.anchorPoint = ccp(0,0);
        [hintLayer addChild:hintSprite];
        [hintSprite runAction:action];
    }
}

/// 更新闪烁 (宝石反光效果)
-(void) updateSparkle
{
    /// 有概率
    if (CCRANDOM_0_1() > 0.1f)
    {
        return;
    }
    // 随机获取一个宝石
    JewelSprite *js = [allJewelSprites randomObject];
    EffectSprite *effect = [[EffectSprite alloc] initWithFile:@"jewel_sparkle.png"];
    [effect runAction:[CCRepeatForever actionWithAction:[CCRotateBy actionWithDuration:3 angle:360]]];
    [effect setOpacity:0];
    [effect runAction:[CCSequence actions:
                       [CCFadeIn actionWithDuration:0.5f],
                       [CCFadeOut actionWithDuration:2.0f],
                       [CCCallFunc actionWithTarget:effect selector:@selector(removeFromParent)],
                       nil]];
    [effect setPosition:ccp(js.position.x + cellSize.width/2.0f * 2.0/6.0, js.position.y + cellSize.height/2.0f * 4.0/6.0)];
    [self addEffectSprite:effect];
    [effect release];
}

-(void) setupShimmer
{
    // 预加载
    [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"shimmer.plist"];
    for (int i = 0; i < 2; i++)
    {
        EffectSprite *sprt = [[EffectSprite alloc] initWithSpriteFrameName:[NSString stringWithFormat:@"bg-shimmer-%d.png",i]];
        
        CCAction *seqRot = nil;
        CCAction *seqMov = nil;
        CCAction *seqSca = nil;
        
        for (int j = 0; j< 10; j++)
        {
            float time = CCRANDOM_0_1() * 10 + 5;
            float x = boardWidth * cellSize.width/2.0f;
            float y = CCRANDOM_0_1() * boardHeight * cellSize.height;
            
            float rot = CCRANDOM_0_1() * 180 - 90;
            float scale = CCRANDOM_0_1() * 3 + 3;
            
            CCAction *actionRot = [CCEaseInOut actionWithAction:[CCRotateTo actionWithDuration:time angle:rot] rate:2];
            CCAction *actionMov = [CCEaseInOut actionWithAction:[CCMoveTo actionWithDuration:time position:ccp(x,y)] rate:2];
            CCAction *actionSca = [CCScaleTo actionWithDuration:time scale:scale];
            
            if (!seqRot)
            {
                seqRot = actionRot;
                seqMov = actionMov;
                seqSca = actionSca;
            }
            else
            {
                seqRot = [CCSequence actionOne:seqRot two:actionRot];
                seqMov = [CCSequence actionOne:seqMov two:actionMov];
                seqSca = [CCSequence actionOne:seqSca two:actionSca];
            }
        }
        
        int x = boardWidth * cellSize.width / 2.0f;
        int y = CCRANDOM_0_1() * boardHeight * cellSize.height;
        float rot = CCRANDOM_0_1() * 180 - 90;
        [sprt setPosition:ccp(x,y)];
        [sprt setRotation:rot];
        
        [sprt setPosition:ccp(boardWidth * cellSize.width / 2.0f, boardHeight * cellSize.height / 2.0f)];
        [sprt setBlendFunc:(ccBlendFunc){GL_SRC_ALPHA,GL_ONE}];
        [sprt setScale:3.0f];
        
        [shimmerLayer addChild:sprt];
        [sprt setOpacity:0];
        [sprt runAction:[CCRepeatForever actionWithAction:seqRot]];
        [sprt runAction:[CCRepeatForever actionWithAction:seqMov]];
        [sprt runAction:[CCRepeatForever actionWithAction:seqSca]];
        
        [sprt runAction:[CCFadeIn actionWithDuration:2.0f]];
    }
}

-(void) removeShimmer
{
    CCArray *children = [shimmerLayer children];
    for (int i = 0; i < children.count; i++)
    {
        [[children objectAtIndex:i] runAction:[CCFadeOut actionWithDuration:1.0f]];
    }
}


@end
