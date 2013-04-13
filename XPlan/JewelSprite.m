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

-(void) updateGraphic;

@end

@implementation JewelSprite

@synthesize jewelId, jewelVo,coord,jewelSize,state,jewelPanel;

-(id) initWithJewelPanel:(JewelPanel *)thePanel jewelVo:(JewelVo *)sd
{
    if ((self = [super init]))
    {
        jewelPanel = thePanel; // 设置隶属宝石面板
        jewelVo = sd; // 设置对应宝石数据对象
        state = kJewelStateIdle; // 宝石状态
        jewelSize = CGSizeMake([KITApp scale:41], [KITApp scale:41]); // 设置宝石大小
        [self updateGraphic]; // 更新素材
    }
    
    return self;
}

-(void) dealloc
{
    [clip release];
    [super dealloc];
}

/// 获取对应素材配置文件
-(KITProfile*) getProfile
{
    return [KITProfile profileWithName:[NSString stringWithFormat:@"jewel%d_config.plist",jewelVo.jewelId]];
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
        
        // 更新格子坐标
        if (!CGPointEqualToPoint(oldCoord, newCoord))
        {
            //
            JewelCell *oldCell = [self.jewelPanel getCellAtCoord:oldCoord];
            oldCell.jewelSprite = nil;
            
            JewelCell *newCell = [self.jewelPanel getCellAtCoord:newCoord];
            newCell.jewelSprite = self;
        }
        
        [super setPosition:position];
    }
}

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

/// 设置到最前面
-(void) showTop
{
    if (self.parent)
    {
        self.zOrder = self.parent.children.count;
    }
}


/// 掉落
-(void) drop
{
    if (jewelVo.yGap >= 0)
    {
        return;
    }

    // 获取掉落坐标
    CGPoint targetPos = [self.jewelPanel cellCoordToPosition:jewelVo.coord];

    // 执行掉落动作
    [self runAction:[CCSequence actions:
                    [CCMoveTo actionWithDuration:jewelVo.time position:targetPos],
                     [CCCallFunc actionWithTarget:self selector:@selector(initComplete)]
                    , nil]];
    // 设置宝石新标识
    [jewelVo newId];
}

/// 死局 下落到最低
-(void) moveToDead
{
    CGPoint targetPos = ccp(coord.x * jewelSize.width, - coord.y * jewelSize.height);
    [self runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:0.6f position:targetPos],
                     [CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)]
                     , nil]];
    
}


/// 更新位图
-(void) updateGraphic
{
    KITProfile *profile = [self getProfile];
    
    // 显示底图
    if (!clip)
    {
        clip = [[EffectSprite alloc] initWithSpriteFrame:[profile spriteFrameForKey:@"clip"]];
    }
    else
    {
        [clip setDisplayFrame:[profile spriteFrameForKey:@"clip"]];
    }
}

/// 火焰方块燃烧动画
-(void) fireJewelEffect
{
    // 清理特殊效果外圈
    [self clearSpecial];
    
    KITProfile *profile = [self getProfile];
    
    // 变更底图
    [clip setDisplayFrame:[profile spriteFrameForKey:@"fireJewel"]];
    
    // 播放燃烧动画
    CCAnimation *fireAnim = [profile animationForKey:@"fire"];
    [self runAction:[CCSequence actions:
                     [CCAnimate actionWithAnimation:fireAnim],
                     [CCCallFunc actionWithTarget:self selector:@selector(effctComplete:)]
                      , nil]];
}

/// 火焰方块消失效果
-(void) fireDisposeEffect
{
    // 清理特殊效果外圈
    [self clearSpecial];
    
    KITProfile *profile = [self getProfile];
    
    // 播放燃烧销毁动画
    CCAnimation *disposeAnim = [profile animationForKey:@"fireDispose"];
    
    // 播放动画,播放完毕删除
    [self runAction:[CCSequence actions:
                     [CCAnimate actionWithAnimation:disposeAnim],
                     [CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)]
                     , nil]];
}

/// 闪电方块消失特效
-(void) lightDisposeEffect
{
    // 清理特殊效果外圈
    [self clearSpecial];
    
    KITProfile *profile = [self getProfile];
    
    // 播放闪电方块消失动画
    CCAnimation *lightAnim = [profile animationForKey:@"light"];
    [self runAction:[CCSequence actions:
                     [CCAnimate actionWithAnimation:lightAnim],
                     [CCCallFunc actionWithTarget:self selector:@selector(effectComplete:)]
                     , nil]];
}


/// 爆炸方块消失特效
-(void) explodeDisposeEffect
{
    // 清理特殊效果外圈
    [self clearSpecial];
    
    KITProfile *profile = [self getProfile];
    
    // 播放爆炸方块消失动画
    CCAnimation *explodeAnim = [profile animationForKey:@"explode"];
    [self runAction:[CCSequence actions:
                     [CCAnimate actionWithAnimation:explodeAnim],
                     [CCCallFunc actionWithTarget:self selector:@selector(effectComplete:)]
                     , nil]];
    
}

-(void) disposeEffect
{
    // 清理特殊效果外圈
    [self clearSpecial];
    
    KITProfile *profile = [self getProfile];
    
    // 播放方块消失动画
    CCAnimation *disposeAnim = [profile animationForKey:@"dispose"];
    [self runAction:[CCSequence actions:
                     [CCAnimate actionWithAnimation:disposeAnim],
                     [CCCallFunc actionWithTarget:self selector:@selector(effectComplete:)]
                     , nil]];
}



-(void) setJewelId:(NSString *)value
{
    [jewelId release];
    jewelId = [value retain];
    NSArray *arr = [jewelId componentsSeparatedByString:@"_"];
    coord = ccp([[arr objectAtIndex:0] intValue],[[arr objectAtIndex:1] intValue]);
    if (initAnimation)
    {
        isPlaying = YES;
        
        // 计算起始位置
        CGPoint startPos = ccp(coord.x * jewelSize.width, self.parent.height + jewelSize.height);
        self.position = startPos;
        [self move];
        initAnimation = NO;
        [self changeSpecial];
    }
}

/// 逻辑更新
-(BOOL) update:(ccTime)delta
{

    
    return NO;
}

/// 变更状态
-(void) changeState:(int)value
{
    self.state = value;
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

#pragma mark - 
#pragma mark Effects

-(void) addEffects
{
    
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

-(void) detatchEffects
{
    for (NSString *key in [effects allKeys])
    {
        id effect = [effects objectForKey:key];
        [effect removeFromParentAndCleanup:YES];
    }
}

-(void) initComplete
{
    // 重置播放标记
    isPlaying = NO;
}

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

#pragma mark -
#pragma mark Jewel Effect



@end
