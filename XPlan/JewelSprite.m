//
//  JewelNode.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "JewelSprite.h"
#import "JewelVo.h"
#import "GameController.h"
#import "JewelCell.h"
#import "JewelPanel.h"
#import "Constants.h"
#import "GameController.h"


@interface JewelSprite()

-(void) updateGraphics;

@end

@implementation JewelSprite

@synthesize globalId, jewelVo,coord,state,newState,jewelPanel,cell,eliminateRight,eliminateTop;

-(id) initWithJewelPanel:(JewelPanel *)thePanel jewelVo:(JewelVo *)sd
{
    id ret = [self initWithSpriteFrameName:[NSString stringWithFormat: @"jewel%d.png",sd.jewelId]];
    
    if (ret!=nil)
    {
        jewelPanel = thePanel; // 设置隶属宝石面板
        jewelVo = sd; // 设置对应宝石数据对象
        state = kJewelStateIdle; // 宝石状态
        effects = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return ret;
}

-(void) dealloc
{
    [effects release];
    [super dealloc];
}

-(int) globalId
{
    return jewelVo.globalId;
}

-(CGPoint) coord
{
    return jewelVo.coord;
}

-(void) setCoord:(CGPoint)value
{
    [jewelVo setCoord:value];
}

-(JewelCell*) cell
{
    return [jewelPanel getCellAtCoord:self.coord];
}

#pragma mark -
#pragma mark Status

/// 是否准备移除
-(BOOL) isReadyToBeRemoved
{
    return self.state == kJewelStateEliminated;
}



/// 获取宝石格子
-(JewelCell*) getCell
{
    return [self.jewelPanel getCellAtPosition:self.position];
}

/// 设置坐标
-(void) setPosition:(CGPoint)position
{
    if (!CGPointEqualToPoint(position, self.position))
    {
        
        CGPoint oldCoord = [self.jewelPanel positionToCellCoord:self.position];
        CGPoint newCoord = [self.jewelPanel positionToCellCoord:position];
        [super setPosition:position];
        
        // 更新格子坐标
        if (!CGPointEqualToPoint(oldCoord, newCoord))
        {
            // 更新坐标
            self.coord = newCoord;
        }
        
        // 更新效果
        for (NSString *key in effects.allKeys)
        {
            EffectSprite *effect = [effects objectForKey:key];
            [effect parentMoved:self.position];
        }
    }
}

/// 变更状态
-(void) changeState:(int)value
{
    self.state = self.newState = value;
}



/*
/// 检查是否是特殊宝石
-(void) checkSpecial
{
    // 清理原有特殊效果
    if (specialClip)
    {
        [specialClip removeFromParentAndCleanup:YES];
        [specialClip release];
        specialClip = nil;
    }
    
    // 检查是否符合特殊宝石条件
    if (jewelVo.disposeNum < kJewelSpecialExplode)
    {
        return;
    }
    
    int max = jewelVo.disposeNum;
    KITProfile *profile = [self getProfile];

    switch(max)
    {
        case kJewelSpecialExplode:
        {
            CCAnimation *explodeAnim = [profile animationForKey:@"explodeJewel"];
            specialClip = [[EffectSprite alloc] initWithSpriteFrame:[explodeAnim.frames objectAtIndex:0]];
            [specialClip animate:explodeAnim tag:kJewelSpecialExplode repeat:YES restore:NO];
            jewelVo.special = kJewelSpecialExplode;
            break;
        }
        case kJewelSpecialFire:
        {
            CCAnimation *fireAnim = [profile animationForKey:@"fireJewel"];
            specialClip = [[EffectSprite alloc] initWithSpriteFrame:[fireAnim.frames objectAtIndex:0]];
            [specialClip animate:fireAnim tag:kJewelSpecialFire repeat:YES restore:NO];
            jewelVo.special = kJewelSpecialFire;
            break;
        }
        case kJewelSpecialLight:
        {
            CCAnimation *lightAnim = [profile animationForKey:@"lightJewel"];
            specialClip = [[EffectSprite alloc] initWithSpriteFrame:[lightAnim.frames objectAtIndex:0]];
            [specialClip animate:lightAnim tag:kJewelSpecialLight repeat:YES restore:NO];
            jewelVo.special = kJewelSpecialLight;
            break;
        }
        case kJewelSpecialBlack:
        {
            CCAnimation *blackAnim = [profile animationForKey:@"blackJewel"];
            specialClip = [[EffectSprite alloc] initWithSpriteFrame:[blackAnim.frames objectAtIndex:0]];
            [specialClip animate:blackAnim tag:kJewelSpecialBlack repeat:YES restore:NO];
            jewelVo.special = kJewelSpecialBlack;
            break;
        }
    }

    [self addChild:specialClip];

    [self showTop];
}
 
 */

/// 设置到最前面
-(void) showTop
{
    if (self.parent)
    {
        self.zOrder = self.parent.children.count;
    }
}


/// 火焰方块燃烧动画
-(void) fire:(int)effectId
{
    // 变更状态
    [self changeState:kJewelStateFiring];
    
    KITProfile *profile = [KITProfile profileWithName:@"jewels_graphics"];
    
    // 变更基本纹理为燃烧状态
    [self setDisplayFrame:[profile spriteFrameForKey:[NSString stringWithFormat:@"jewel%d_fire",jewelVo.jewelId]]];
    
    // 添加燃烧效果
    CCAnimation *fireAnim = [profile animationForKey:[NSString stringWithFormat:@"fire%d",effectId]];
    EffectSprite *fireEffect = [[EffectSprite alloc] initWithSpriteFrame:[fireAnim.frames objectAtIndex:0]];
    [self addEffect:fireEffect withKey:kJewelEffectFire];
    fireEffect.position = self.position; // 覆盖
    [fireEffect runAction:[CCSequence actions:
                     [CCAnimate actionWithAnimation:fireAnim],
                     [CCCallFunc actionWithTarget:self selector:@selector(fireComplete:)]
                      , nil]];
}

/// 效果动画执行完毕
-(void) fireComplete
{
    [self deleteEffectWithKey:kJewelEffectFire];
    
}



/// 火焰方块消失效果
-(void) animateFireElimate:(int)effectId
{
    
    // 清理全部特殊效果
    [self detatchEffects];
    
    KITProfile *profile = [KITProfile profileWithName:@"jewels_graphics"];
    
    // 播放燃烧销毁动画
    CCAnimation *elimateAnim = [profile animationForKey:[NSString stringWithFormat:@"fireElimate%d",effectId]];
    
    EffectSprite *effect = [[EffectSprite alloc] initWithSpriteFrame:[elimateAnim.frames objectAtIndex:0]];
    [self addEffect:effect withKey:kJewelEffectFireElimate];
    effect.position = self.position; // 覆盖
    [effect runAction:[CCSequence actions:
                           [CCAnimate actionWithAnimation:elimateAnim],
                           [CCCallFunc actionWithTarget:self selector:@selector(fireElimateComplete:)]
                           , nil]];
}

// 火焰方块效果完成
-(void) fireElimateComplate
{
    [self deleteEffectWithKey:kJewelEffectFireElimate];
    newState = kJewelStateEliminated; // 标记为删除
}

/// 闪电方块消失特效
-(void) animateLightElimate:(int)effectId
{
    // 清理全部特殊效果
    [self detatchEffects];
    
    KITProfile *profile = [KITProfile profileWithName:@"jewels_graphics"];
    
    // 播放燃烧销毁动画
    CCAnimation *elimateAnim = [profile animationForKey:[NSString stringWithFormat:@"lightElimate%d",effectId]];
    
    EffectSprite *effect = [[EffectSprite alloc] initWithSpriteFrame:[elimateAnim.frames objectAtIndex:0]];
    [self addEffect:effect withKey:kJewelEffectLightElimate];
    effect.position = self.position; // 覆盖
    [effect runAction:[CCSequence actions:
                       [CCAnimate actionWithAnimation:elimateAnim],
                       [CCCallFunc actionWithTarget:self selector:@selector(lightElimateComplete:)]
                       , nil]];

}

-(void) lightElimateComplete
{
    [self deleteEffectWithKey:kJewelEffectLightElimate];
    newState = kJewelStateEliminated; // 标记为删除
}


/// 爆炸方块消失特效
-(void) explodeEliminate:(int)effectId
{
    // 清理全部特殊效果
    [self detatchEffects];
    
    KITProfile *profile = [KITProfile profileWithName:@"jewels_graphics"];
    
    // 播放燃烧销毁动画
    CCAnimation *elimateAnim = [profile animationForKey:[NSString stringWithFormat:@"explodeElimate%d",effectId]];
    
    EffectSprite *effect = [[EffectSprite alloc] initWithSpriteFrame:[elimateAnim.frames objectAtIndex:0]];
    [self addEffect:effect withKey:kJewelEffectExplodeElimate];
    effect.position = self.position; // 覆盖
    [effect runAction:[CCSequence actions:
                       [CCAnimate actionWithAnimation:elimateAnim],
                       [CCCallFunc actionWithTarget:self selector:@selector(explodeEliminateComplete:)]
                       , nil]];
}

-(void) explodeEliminateComplete
{
    [self deleteEffectWithKey:kJewelEffectExplodeElimate];
    newState = kJewelStateEliminated; // 标记为删除
}

/// 执行消除
-(void) eliminate:(int)effectId
{
    // 清理全部特殊效果
    [self detatchEffects];
    
    [self setVisible:NO];
    
    KITProfile *profile = [KITProfile profileWithName:@"jewel_graphics"];
    
    // 播放燃烧销毁动画
    CCAnimation *eliminateAnim = [profile animationForKey:[NSString stringWithFormat:@"eliminate%d",effectId]];
    
    EffectSprite *effect = [[EffectSprite alloc] init];
    [self addEffect:effect withKey:kJewelEffectEliminate];
    effect.position = self.position; // 覆盖
    [effect runAction:[CCSequence actions:
                       [CCAnimate actionWithAnimation:eliminateAnim],
                       [CCCallFunc actionWithTarget:self selector:@selector(eliminateComplete)]
                       , nil]];
}

-(void) eliminateComplete
{
     [self deleteEffectWithKey:kJewelEffectEliminate];   
    newState = kJewelStateEliminated;
}


/// 逻辑更新
-(BOOL) update:(ccTime)delta
{
    if (state!=newState)
    {
        [self changeState:newState];
    }
    
    return NO;
}


/// 掉落
-(void) drop
{
    if (jewelVo.yGap <= 0)
    {
        return;
    }
    newState = kJewelStateDropping;
    
    // 获取掉落坐标
    CGPoint targetPos = [self.jewelPanel cellCoordToPosition:ccp(self.jewelVo.coord.x,self.jewelVo.toY)];
    CCAction *action = [CCSequence actions:
    [CCMoveTo actionWithDuration:jewelVo.time position:targetPos],
    [CCCallFunc actionWithTarget:self selector:@selector(dropComplete)]
                        , nil];
    
    // 执行掉落动作
    [self runAction:action];
}

-(void) dropComplete
{
    newState = kJewelStateIdle;
    jewelVo.yGap = 0; // 重置y轴间隙
}


/// 是否正在下落
-(BOOL) isDropping
{
    return self.state==kJewelStateDropping;
}

/*
/// 死局 下落到最低
-(void) moveToDead
{
    CGPoint targetPos = ccp(coord.x * jewelSize.width, - coord.y * jewelSize.height);
    [self runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:0.6f position:targetPos],
                     [CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)]
                     , nil]];
    
}

/// 移动
-(void) move
{
    CGPoint targetPos = [jewelPanel cellCoordToPosition:self.jewelVo.coord];
    CCAction *action = [CCMoveTo actionWithDuration:0.6f position:targetPos];
    action.tag = kJewelItemActionMove;
    
    [self runAction:action];
}

/// 是否在移动
-(BOOL) isMoving
{
    return [self getActionByTag:kJewelItemActionMove] != nil;
}
 
 */

#pragma mark - 
#pragma mark Effects

-(void) addEffects
{
    // for subclasses to implement
}

-(void) addEffect:(EffectSprite*)effect withKey:(NSString*)key
{
    // 还是添加到宝石面板吧!!
    [self.jewelPanel addEffectSprite:effect];
    
    [effects setValue:effect forKey:key];
}

-(void) deleteEffectWithKey:(NSString*)key
{
    id effect = [effects objectForKey:key];
    [effect removeFromParentAndCleanup:YES];
    [effects removeObjectForKey:key];
}

/// 清除全部特效
-(void) detatchEffects
{
    for (NSString *key in [effects allKeys])
    {
        id effect = [effects objectForKey:key];
        [effect removeFromParentAndCleanup:YES];
    }
}

/*
-(void) swapCoordWithNewCoord:(CGPoint)newCoord back:(BOOL)back
{
    // 如果正在播放,则强制完成
    if (isPlaying)
    {
        [self swapComplete];
    }
    
    isBack = back;
    
    isPlaying = YES;
    
    // 移动宝石到新坐标
    CCAction *action = [CCSequence actions:
                        [CCMoveTo actionWithDuration:0.4f position:ccp(newCoord.x * jewelSize.width,newCoord.y * jewelSize.height)],
                        [CCCallFunc actionWithTarget:self selector:@selector(swapComplete:)],
                        nil];
    action.tag = kJewelItemActionMove;
    [self runAction:action];
}

-(void) swapComplete
{
    // 是否支持回退
    if (isBack)
    {
        // 先停下
        [self stopAllActions];
        
        // 移动宝石回退到原来的坐标
        CCAction *action = [CCSequence actions:
                            [CCMoveTo actionWithDuration:0.4f position:ccp(coord.x * jewelSize.width,coord.y * jewelSize.height)],
                            [CCCallFunc actionWithTarget:self selector:@selector(swapComplete:)],
                            nil];
        action.tag = kJewelItemActionMove;
        [self runAction:action];
    }
    else
    {
        // 
        [self setJewelId:jewelVo.jewelId];
        
        isPlaying = NO;
    }
    
    isBack = NO;
    
}

// 变更为特殊宝石?
-(void) changeSpecial
{
    if (jewelVo == nil || specialClip != nil)
    {
        return;
    }
    
    if (jewelVo.lt == NO && jewelVo.disposeRight == NO && jewelVo.disposeTop == NO)
    {
        return;
    }
    
    [self checkSpecial];
}

/// 清除特殊宝石效果
-(void) clearSpecial
{
    if (specialClip)
    {
        [specialClip removeFromParentAndCleanup:YES];
        [specialClip release];
        specialClip = nil;
    }
}
 
 */



@end
