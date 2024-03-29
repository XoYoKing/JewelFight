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
#import "JewelBoard.h"
#import "JewelController.h"
#import "Constants.h"
#import "GameController.h"


@interface JewelSprite()

-(void) updateGraphics;

@end

@implementation JewelSprite

@synthesize globalId,jewelVo,jewelId,coord,state,newState,jewelBoard,cell,eliminateRight,eliminateTop;

-(id) initWithJewelBoard:(JewelBoard *)thePanel jewelVo:(JewelVo *)sd
{
    id ret = [self initWithSpriteFrameName:[NSString stringWithFormat: @"jewel%d.png",sd.jewelId]];
    
    if (ret!=nil)
    {
        jewelBoard = thePanel; // 设置隶属宝石面板
        jewelVo = sd; // 设置对应宝石数据对象
        special = jewelVo.special;
        state = kJewelStateIdle; // 宝石状态
        effects = [[NSMutableDictionary alloc] initWithCapacity:5];
    }
    
    return ret;
}

-(void) dealloc
{
    [self detachEffects];
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

-(int) jewelId
{
    return jewelVo.jewelId;
}

-(JewelCell*) cell
{
    return [jewelBoard getCellAtCoord:self.coord];
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
    return [self.jewelBoard getCellAtPosition:self.position];
}

/// 设置坐标
-(void) setPosition:(CGPoint)position
{
    if (!CGPointEqualToPoint(position, self.position))
    {
        
        CGPoint oldCoord = [self.jewelBoard positionToCellCoord:self.position];
        CGPoint newCoord = [self.jewelBoard positionToCellCoord:position];
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

#pragma mark -
#pragma mark Explode Effects


/// 爆炸方块消失特效
-(void) explodeEliminate
{
    self.cell.jewelGlobalId = 0;
    self.jewelVo.state = 1;
    [self setVisible:NO];
    
    newState = kJewelStateEliminated; // 标记为删除
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
    
    [fireEffect release];
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
    [self detachEffects];
    
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
    [self detachEffects];
    
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



/// 执行消除
-(void) eliminate:(int)effectId
{
    [self setVisible:NO];
    
    self.jewelVo.state = 1;
    
    // 更新状态为删除状态
    newState = kJewelStateEliminated;
    
    CCParticleSystem *particle = [CCParticleSystemQuad particleWithFile:@"taken_jewel.plist"];
    particle.position = ccp(self.position.x + jewelBoard.cellSize.width/2,self.position.y + jewelBoard.cellSize.height/2);
    [particle setAutoRemoveOnFinish:YES];
    [jewelBoard addParticle:particle];
}


/// 逻辑更新
-(BOOL) update:(ccTime)delta
{
    if (state!=newState)
    {
        [self changeState:newState];
    }
    
    if (special!=jewelVo.special)
    {
        special = jewelVo.special;
        
        // 更新素材
        [self updateGraphics];
        
    }
    
    return NO;
}

-(void) updateGraphics
{
    switch (special)
    {
        case kJewelSpecialExplode:
        {
            KITProfile *profile = [KITProfile profileWithName:@"jewel_graphics"];
            CCAnimation *fireAnim = [profile animationForKey:@"fire"];
            
            EffectSprite *fireEffect = [[EffectSprite alloc] init];
            [fireEffect animate:fireAnim tag:-1 repeat:YES restore:NO];
            fireEffect.position = self.position;
            fireEffect.anchorPoint = ccp(0,0);
            [self addEffect:fireEffect withKey:kJewelEffectFire];
            [fireEffect release];
            break;
        }
    }
}

#pragma mark - 
#pragma mark Effects

-(void) addEffects
{
    // for subclasses to implement
}

-(void) addEffect:(EffectSprite*)effect withKey:(NSString*)key
{
    // 还是添加到宝石面板吧!!
    [self.jewelBoard addEffectSprite:effect];
    
    [effects setValue:effect forKey:key];
}

-(void) deleteEffectWithKey:(NSString*)key
{
    id effect = [effects objectForKey:key];
    [effect removeFromParentAndCleanup:YES];
    [effects removeObjectForKey:key];
}

/// 清除全部特效
-(void) detachEffects
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
