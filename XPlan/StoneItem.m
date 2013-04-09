//
//  StoneNode.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "StoneItem.h"
#import "StoneVo.h"
#import "GameController.h"
#import "StoneCell.h"
#import "StonePanel.h"
#import "Constants.h"
#import "GameController.h"


@interface StoneItem()

-(void) updateGraphic;

@end

@implementation StoneItem

@synthesize stoneId, stoneVo,coord,stoneSize,state,stonePanel;

-(id) initWithStonePanel:(StonePanel *)thePanel stoneVo:(StoneVo *)sd
{
    if ((self = [super init]))
    {
        stonePanel = thePanel; // 设置隶属宝石面板
        stoneVo = sd; // 设置对应宝石数据对象
        state = kStoneStateIdle; // 宝石状态
        stoneSize = CGSizeMake([KITApp scale:41], [KITApp scale:41]); // 设置宝石大小
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
    return [[GameController sharedController] getStoneProfileWithType:stoneVo.type];
}

/// 获取宝石格子
-(StoneCell*) getCell
{
    return [self.stonePanel getCellAtPosition:self.position];
}

/// 设置坐标
-(void) setPosition:(CGPoint)position
{
    if (!CGPointEqualToPoint(position, self.position))
    {
        
        CGPoint oldCoord = [self.stonePanel positionToCellCoord:self.position];
        CGPoint newCoord = [self.stonePanel positionToCellCoord:position];
        
        // 更新格子坐标
        if (!CGPointEqualToPoint(oldCoord, newCoord))
        {
            //
            StoneCell *oldCell = [self.stonePanel getCellAtCoord:oldCoord];
            oldCell.stoneItem = nil;
            
            StoneCell *newCell = [self.stonePanel getCellAtCoord:newCoord];
            newCell.stoneItem = self;
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
    if (stoneVo.disposeNum < kStoneSpecialExplode)
    {
        return;
    }
    
    int max = stoneVo.disposeNum;
    KITProfile *profile = [self getProfile];

    switch(max)
    {
        case kStoneSpecialExplode:
        {
            CCAnimation *explodeAnim = [profile animationForKey:@"explodeStone"];
            specialClip = [[EffectSprite alloc] initWithSpriteFrame:[explodeAnim.frames objectAtIndex:0]];
            [specialClip animate:explodeAnim tag:kStoneSpecialExplode repeat:YES restore:NO];
            stoneVo.special = kStoneSpecialExplode;
            break;
        }
        case kStoneSpecialFire:
        {
            CCAnimation *fireAnim = [profile animationForKey:@"fireStone"];
            specialClip = [[EffectSprite alloc] initWithSpriteFrame:[fireAnim.frames objectAtIndex:0]];
            [specialClip animate:fireAnim tag:kStoneSpecialFire repeat:YES restore:NO];
            stoneVo.special = kStoneSpecialFire;
            break;
        }
        case kStoneSpecialLight:
        {
            CCAnimation *lightAnim = [profile animationForKey:@"lightStone"];
            specialClip = [[EffectSprite alloc] initWithSpriteFrame:[lightAnim.frames objectAtIndex:0]];
            [specialClip animate:lightAnim tag:kStoneSpecialLight repeat:YES restore:NO];
            stoneVo.special = kStoneSpecialLight;
            break;
        }
        case kStoneSpecialBlack:
        {
            CCAnimation *blackAnim = [profile animationForKey:@"blackStone"];
            specialClip = [[EffectSprite alloc] initWithSpriteFrame:[blackAnim.frames objectAtIndex:0]];
            [specialClip animate:blackAnim tag:kStoneSpecialBlack repeat:YES restore:NO];
            stoneVo.special = kStoneSpecialBlack;
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
    if (stoneVo.yGap >= 0)
    {
        return;
    }

    // 获取掉落坐标
    CGPoint targetPos = [self.stonePanel cellCoordToPosition:ccp(stoneVo.x,stoneVo.toY)];

    // 执行掉落动作
    [self runAction:[CCSequence actions:
                    [CCMoveTo actionWithDuration:stoneVo.time position:targetPos],
                     [CCCallFunc actionWithTarget:self selector:@selector(initComplete)]
                    , nil]];
    // 设置宝石新标识
    [stoneVo newId];
}

/// 死局 下落到最低
-(void) moveToDead
{
    CGPoint targetPos = ccp(coord.x * stoneSize.width, - coord.y * stoneSize.height);
    [self runAction:[CCSequence actions:
                     [CCMoveTo actionWithDuration:0.6f position:targetPos],
                     [CCCallFunc actionWithTarget:self selector:@selector(removeFromParent)]
                     , nil]];
    
}


/// 更新位图
-(void) updateGraphic
{
    KITProfile *profile = [self getProfile];
    
    NSString *clipKey = [NSString stringWithFormat:@"stone_%@",stoneVo.type];
    
    // 显示底图
    if (!clip)
    {
        clip = [[EffectSprite alloc] initWithSpriteFrame:[profile spriteFrameForKey:clipKey]];
    }
    else
    {
        [clip setDisplayFrame:[profile spriteFrameForKey:clipKey]];
    }
}

/// 火焰方块燃烧动画
-(void) fireStoneEffect
{
    // 清理特殊效果外圈
    [self clearSpecial];
    
    KITProfile *profile = [self getProfile];
    
    // 变更底图
    [clip setDisplayFrame:[profile spriteFrameForKey:@"fireStone"]];
    
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



-(void) setStoneId:(NSString *)value
{
    [stoneId release];
    stoneId = [value retain];
    NSArray *arr = [stoneId componentsSeparatedByString:@"_"];
    coord = ccp([[arr objectAtIndex:0] intValue],[[arr objectAtIndex:1] intValue]);
    if (initAnimation)
    {
        isPlaying = YES;
        
        // 计算起始位置
        CGPoint startPos = ccp(coord.x * stoneSize.width, self.parent.height + stoneSize.height);
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
    CGPoint targetPos = [stonePanel cellCoordToPosition:ccp(self.stoneVo.x,self.stoneVo.y)];
    CCAction *action = [CCMoveTo actionWithDuration:0.6f position:targetPos];
    action.tag = kStoneItemActionMove;
    
    [self runAction:action];
}

/// 是否在移动
-(BOOL) isMoving
{
    return [self getActionByTag:kStoneItemActionMove] != nil;
}

#pragma mark - 
#pragma mark Effects

-(void) addEffects
{
    
}

-(void) addEffect:(EffectSprite*)effect withKey:(NSString*)key
{
    // 还是添加到宝石面板吧!!
    [self.stonePanel addEffectSprite:effect];
    
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
                        [CCMoveTo actionWithDuration:0.4f position:ccp(newCoord.x * stoneSize.width,newCoord.y * stoneSize.height)],
                        [CCCallFunc actionWithTarget:self selector:@selector(swapComplete:)],
                        nil];
    action.tag = kStoneItemActionMove;
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
                            [CCMoveTo actionWithDuration:0.4f position:ccp(coord.x * stoneSize.width,coord.y * stoneSize.height)],
                            [CCCallFunc actionWithTarget:self selector:@selector(swapComplete:)],
                            nil];
        action.tag = kStoneItemActionMove;
        [self runAction:action];
    }
    else
    {
        // 
        [self setStoneId:stoneVo.stoneId];
        
        isPlaying = NO;
    }
    
    isBack = NO;
    
}

// 变更为特殊宝石?
-(void) changeSpecial
{
    if (stoneVo == nil || specialClip != nil)
    {
        return;
    }
    
    if (stoneVo.lt == NO && stoneVo.disposeRight == NO && stoneVo.disposeTop == NO)
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
#pragma mark Stone Effect



@end
