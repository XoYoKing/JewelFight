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

@interface FightAttackAction()
{
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
    
    // 设置开始状态
    newState = kFightAttackStatePrepare;
}

-(BOOL) isOver
{
    return state == kFightAttackStateOver;
}

-(KITProfile*) skillProfile
{
    return [KITProfile profileWithName:[NSString stringWithFormat:@"skill_%d",attackVo.skillId]];
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
    
    //
    switch (state)
    {
        case kFightAttackStatePrepare:
        {
            // 根据技能选择动画
            NSString *actorAnim = [skillProfile attributeForKey:@"actorPrepareAnim"];
            if (![self.actor isAnimationRunning:actorAnim])
            {
                newState = kFightAttackStateRunning;
            }
            break;
        }
        case kFightAttackStateRunning:
        {
            // 根据技能选择动画
            NSString *actorAnim = [skillProfile attributeForKey:@"actorRunningAnim"];
            if (![self.actor isAnimationRunning:actorAnim])
            {
                newState = kFightAttackStateAttacking;
            }
            break;
        }
        case kFightAttackStateAttacking:
        {
            NSString *actorAnim = [skillProfile attributeForKey:@"actorAttackAnim"];
            if (![self.actor isAnimationRunning:actorAnim])
            {
                newState = kFightAttackStateAttacked;
            }
            
            break;
        }
        case kFightAttackStateAttacked:
        {
            newState = kFightAttackStateBack;
            break;
        }
        case kFightAttackStateBack:
        {
            NSString *actorAnim = [skillProfile attributeForKey:@"actorBackAnim"];
            if (![self.actor isAnimationRunning:actorAnim])
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
        // 准备状态
        case kFightAttackStatePrepare:
        {
            // 根据技能选择动画
            NSString *actorAnim = [skillProfile attributeForKey:@"actorPrepareAnim"];
            if (actorAnim)
            {
                [self.actor setAnimation:actorAnim];
            }
            else
            {
                // 否则直接跳到冲锋
                newState = kFightAttackStateRunning;
            }
            break;
        }
        // 冲锋状态
        case kFightAttackStateRunning:
        {
            // 根据技能选择动画
            NSString *actorAnim = [skillProfile attributeForKey:@"actorRunningAnim"];
            if (actorAnim)
            {
                [self.actor setAnimation:actorAnim];
            }
            else
            {
                // 否则直接跳到攻击状态
                newState = kFightAttackStateAttacking;
            }
            break;
        }
        // 攻击状态
        case kFightAttackStateAttacking:
        {
            NSString *attackAnim = [skillProfile attributeForKey:@"actorAttackAnim"];
            [self.actor setAnimation:attackAnim];
            
            break;
        }
        // 攻击完成
        case kFightAttackStateAttacked:
        {
            // TODO:执行掉血逻辑
            
            NSString *targetAnim = [skillProfile attributeForKey:@"targetHurtAnim"];
            [self.target setAnimation:targetAnim];
            
            // 撤回
            newState = kFightAttackStateBack;
            break;
        }
            
        // 撤退逻辑
        case kFightAttackStateBack:
        {
            NSString *backAnim = [skillProfile attributeForKey:@"actorBackAnim"];
            
            if (backAnim)
            {
                [self.actor setAnimation:backAnim];
            }
            else
            {
                // 结束
                newState = kFightAttackStateOver;
            }
            break;
        }
        case kFightAttackStateOver:
        {
            [self.actor setAnimation:@"idle"];
            [self.target setAnimation:@"idle"];
            break;
        }
    }

}




@end
