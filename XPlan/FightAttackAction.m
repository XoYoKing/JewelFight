//
//  BattleAttackAction.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FightAttackAction.h"
#import "AttackVo.h"
#import "FighterVo.h"
#import "FighterSprite.h"
#import "KITProfile.h"
#import "EffectSprite.h"
#import "FightField.h"

#define kTagFightPrepare 50
#define kTagFightLighting 52
#define kTagFightMoving 53
#define kTagFightBeforeAttack 54
#define kTagFightAttack 55 // 攻击
#define kTagFightAttackedBy 56 // 被攻击
#define kTagFightWin 57 // 胜利
#define kTagFightLose 58 // 失败
#define kTagFightRetreat 59 // 撤退

@interface FightAttackAction()
{
    CGPoint actorStartPos;
    ccTime timer; // 计时器
    
    EffectSprite *lighting;
}

@end

@implementation FightAttackAction

-(id) initWithFightField:(FightField *)f attackVo:(AttackVo *)av
{
    if ((self = [super initWithFightField:f name:@"FightAttackAction"]))
    {
        attackVo = [av retain];
        actorFighterGlobalId = attackVo.actorGlobalId;
        targetFighterGlobalId = attackVo.targetGlobalId;
        
        state = -1;
        newState = -1;
    }
    
    return self;
}

-(void) dealloc
{
    [attackVo release];
    [super dealloc];
}

-(void) start
{
    if (skipped)
    {
        return;
    }
    
    // actor check
    if (self.actor == nil || ![self.actor isAlive])
    {
        [self skip];
        return;
    }
    
    // target check
    if ( self.target == nil || ![self.actor isAlive])
    {
        [self skip];
        return;
    }
    
    // 记录出发地点
    actorStartPos = self.actor.position;
    
    // 设置开始状态
    newState = kFightAttackStatePrepare;
}

-(BOOL) isOver
{
    return state == kFightAttackStateOver;
}

-(KITProfile*) skillProfile
{
    return [KITProfile profileWithName:[NSString stringWithFormat:@"skill%d_config.plist",attackVo.skillId]];
}

-(void) update:(ccTime)delta
{
    if (state == kFightAttackStateOver || skipped)
    {
        return;
    }
    
    // 变更状态
    if (state!=newState)
    {
        [self changeState:newState];
    }
    
    timer += delta;
    
    KITProfile *skillProfile = [self skillProfile];
    
    switch (state)
    {
        case kFightAttackStatePrepare:
        {
            // 检查准备动画是否完成
            if (![self.actor isAnimationPlaying:kTagFightPrepare])
            {
                // 跳到下一个状态
                newState = kFightAttackStateMoving;
            }
            break;
        }
        // 移动动画
        case kFightAttackStateMoving:
        {
            if (![self.actor getActionByTag:kTagFightMoving])
            {
                // 跳到战斗准备状态
                newState = kFightAttackStateLighting;
            }
            
            break;
        }
        case kFightAttackStateLighting:
        {
            // 由lightingDone控制完成
            break;
        }
        case kFightAttackStateBeforeAttack:
        {
            if (![self.actor getActionByTag:kTagFightBeforeAttack])
            {
                // 跳到战斗状态
                newState = kFightAttackStateAttacking;
            }
            break;
        }
        // 攻击状态
        case kFightAttackStateAttacking:
        {
            NSDictionary *config = [skillProfile attributeForKey:@"attackingState"];
            
            // 超过播放时间,跳过
            if (timer > [[config valueForKey:@"time"] floatValue])
            {
                // 伤害
                int damage = [self.actor getDamageTo:self.target];
                // 减少生命值
                [self.target reduceLife:damage];
                
                if (![self.target isAlive])
                {
                    // 胜利
                    newState = kFightAttackStateWin;
                }
                else
                {
                    // 打完收工
                    newState = kFightAttackStateRetreat;
                }
            }
            break;
        }
        // 胜利状态
        case kFightAttackStateWin:
        {
            if (![self.actor isWinAnimationPlaying] && ![self.actor isFailAnimationPlaying])
            {
                newState = kFightAttackStateOver;
            }
            break;
        }
        // 撤退状态
        case kFightAttackStateRetreat:
        {
            if (![self.actor getActionByTag:kTagFightRetreat])
            {
                newState = kFightAttackStateOver;
            }
            break;
        }
    }
}

-(void) changeState:(int)value
{
    state = newState = value;
    timer = 0;
    KITProfile *skillProfile = [self skillProfile];
    switch (state)
    {
        // 准备阶段
        case kFightAttackStatePrepare:
        {
            // 播放准备阶段动画
            NSDictionary *config = [skillProfile attributeForKey:@"prepareState"];
            if (config!=nil)
            {
                // 播放指定的动画
                [self.actor setAnimation:[config valueForKey:@"animation"] tag:kTagFightPrepare repeat:NO restore:NO];
            }
            else
            {
                // 配置为空,跳到移动状态
                newState = kFightAttackStateMoving;
            }
            
            break;
        }
        // 移动
        case kFightAttackStateMoving:
        {
            NSDictionary *config = [skillProfile attributeForKey:@"moveState"];
            if (config!=nil)
            {
                // 移动到指定位置
                CGPoint moveToPos = CGPointZero;
                // 左侧站位
                if (self.actor.team == 0)
                {
                    // 移动到对手的位置并距离一定位置
                    moveToPos = ccp(self.target.position.x - [[config valueForKey:@"distance"] floatValue], self.target.position.y);
                }
                // 右侧站位
                else
                {
                    moveToPos = ccp(self.target.position.x + [[config valueForKey:@"distance"] floatValue],self.target.position.y);
                }
                
                CCAction *moveAction = [CCMoveTo actionWithDuration:[[config valueForKey:@"time"] floatValue] position:moveToPos];
                moveAction.tag = kTagFightMoving;
                [self.actor runAction:moveAction];
            }
            else
            {
                // 配置为空,跳到发招状态
                newState = kFightAttackStateLighting;
            }
            break;
        }
        // 发招状态
        case kFightAttackStateLighting:
        {
            NSDictionary *config = [skillProfile attributeForKey:@"lightingState"];
            if (config!=nil)
            {
                // 播放全屏发招动画
                if ([[config valueForKey:@"playLighting"] boolValue])
                {
                    [self showLighting];
                }
            }
            else
            {
                // 配置为空,跳到战斗准备状态
                newState = kFightAttackStateBeforeAttack;
            }
            break;
        }
            
        // 准备攻击状态
        case kFightAttackStateBeforeAttack:
        {
            NSDictionary *config = [skillProfile attributeForKey:@"beforeAttackState"];
            if (config!=nil)
            {
                // 播放指定的动画
                [self.actor setAnimation:[config valueForKey:@"animation"] tag:kTagFightBeforeAttack repeat:NO restore:NO];
            }
            else
            {
                // 切到攻击
                newState = kFightAttackStateAttacking;
            }
            break;
        }
        // 攻击状态
        case kFightAttackStateAttacking:
        {
            NSDictionary *config = [skillProfile attributeForKey:@"attackingState"];
            if (config!=nil)
            {
                // 播放攻击动画
                [self.actor setAnimation:[config valueForKey:@"attackAnim"] tag:kTagFightAttack repeat:NO restore:NO];
                
                // 播放被攻击动画
                [self.actor setAnimation:[config valueForKey:@"attackByAnim"] tag:kTagFightAttackedBy repeat:NO restore:NO];
                
            }
            else
            {
                // 切到撤退回指定位置
                newState = kFightAttackStateRetreat;
            }
            break;
        }
        // 胜利
        case kFightAttackStateWin:
        {
            // 胜利动画
            [self.actor winAnimation];
            
            // 失败动画
            [self.target failAnimation];
            
            break;
        }
            
        // 撤退
        case kFightAttackStateRetreat:
        {
            NSDictionary *config = [skillProfile attributeForKey:@"retreatState"];
            if (config!=nil)
            {
                CCAction *moveAction = [CCMoveTo actionWithDuration:[[config valueForKey:@"time"] floatValue] position:actorStartPos];
                moveAction.tag = kTagFightRetreat;
                [self.actor runAction:moveAction];
            }
            else
            {
                newState = kFightAttackStateOver;
            }
            break;
        }
    }
}


/// 显示闪电
-(void) showLighting
{
    KITProfile *profile = [KITProfile profileWithName:@"fight_lighting"];
    
    lighting = [[EffectSprite alloc] init];
    lighting.contentSize = CGSizeMake(768,250);
    
    // 背景
    EffectSprite *bg = [[EffectSprite alloc] initWithSpriteFrame:[profile spriteFrameForKey:@"background"]];
    [lighting addChild:bg];
    [bg release];
    
    // 闪烁
    EffectSprite *flash = [[EffectSprite alloc] init];
    [flash animate:[profile animationForKey:@"flash"] tag:-1 repeat:YES restore:NO];
    [lighting addChild:flash];
    [flash release];
    
    // 闪电
    EffectSprite *light = [[EffectSprite alloc] init];
    [light animate:[profile animationForKey:@"light"] tag:-1 repeat:NO restore:NO];
    [lighting addChild:light];
    [light release];
    
    // 战士头像移动
    EffectSprite *portrait = [[EffectSprite alloc] initWithSpriteFrame:[self.actor.profile spriteFrameForKey:@"portrait"]];
    portrait.anchorPoint = ccp(0.5,0.5);
    [lighting addChild:portrait];
    CGPoint targetPos = CGPointZero;
    if (self.actor.team == 0)
    {
        portrait.position = ccp(-portrait.width,125);
        targetPos = ccp(284,125);
    }
    else
    {
        portrait.position = ccp(fightField.width+portrait.width,125);
        targetPos = ccp(384,125);
    }
    
    // 执行动作
    [portrait runAction:[CCMoveTo actionWithDuration:0.4f position:targetPos]];
    
    [fightField addEffectSprite:lighting];
    
    [lighting runAction:[CCSequence actions:
                         [CCDelayTime actionWithDuration:0.4f],
                         [CCCallFunc actionWithTarget:self selector:@selector(lightingDone)]
                         , nil]];
}

-(void) lightingDone
{
    // 清理闪电
    [lighting removeFromParentAndCleanup:YES];
    [lighting release];
    lighting = nil;
    
    // 准备攻击
    newState = kFightAttackStateBeforeAttack;
}


@end
