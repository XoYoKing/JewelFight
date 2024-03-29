//
//  FighterSprite.m
//  XPlan
//
//  Created by Hex on 4/18/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "FighterSprite.h"
#import "FightField.h"
#import "FighterVo.h"
#import "GameController.h"
#import "PlayerInfo.h"
#import "FightTextEffect.h"
#import "CCBAnimationManager.h"

@interface FighterSprite()
{
    CCBAnimationManager* animationManager;
    ccTime textEffectTimer; // 文字特效计时
}
@end

@implementation FighterSprite

@synthesize state,newState,team,globalId,fighterVo,profile,life,maxLife;

-(id) initWithFightField:(FightField*)field fighterVo:(FighterVo*)fv
{
    if ((self = [super init]))
    {
        fightField = field;
        fighterVo = [fv retain];
        // 设置隶属阵营
        team = fighterVo.userId == [GameController sharedController].player.userId?0:1;
        state = kFighterStateIdle; // 英雄状态
        effects = [[NSMutableDictionary alloc] initWithCapacity:5];
        textEffectQueue = [[CCArray alloc] initWithCapacity:10];
        
        //
        [self initGraphics];
        
        // 设置动画
        [self setAnimation:@"idle"];
    }
    
    return self;
}

-(void) dealloc
{
    [fighterVo release];
    [effects release];
    [super dealloc];
}

-(void) initGraphics
{
    NSString *ccbFile = self.team==0?[NSString stringWithFormat:@"fighter_%d_fr.ccbi",fighterVo.heroId]:[NSString stringWithFormat:@"fighter_%d_fl.ccbi",fighterVo.heroId];
    
    CCNode *node = [CCBReader nodeGraphFromFile:ccbFile];
    [self addChild:node];
    animationManager = node.userObject;
                    
}

-(KITProfile*) profile
{
    NSString *profileName = [NSString stringWithFormat:@"fighter_%d",fighterVo.heroId];
    return [KITProfile profileWithName:profileName];
}

-(long) globalId
{
    return fighterVo.globalId;
}


-(BOOL) update:(ccTime)delta
{
    // 变更状态
    if (state!=newState)
    {
        [self changeState:newState];
    }
    
    return NO;
}

-(void) changeState:(int)value
{
    state = newState = value;
}

-(int) getDamageTo:(FighterVo *)target
{
    return self.fighterVo.firePower;
}

#pragma mark -
#pragma mark Status

/// 是否准备移除
-(BOOL) isReadyToBeRemoved
{
    return self.state == kFighterStateDied;
}

-(BOOL) isAlive
{
    return self.life == 0;
}

#pragma mark -
#pragma mark Life & Death

-(int) maxLife
{
    return fighterVo.maxLife;
}

-(int) life
{
    return fighterVo.life;
}

-(void) setLife:(int)value
{
    [fighterVo setLife:value];
}

-(void) reduceLife:(int)damage
{
    if(![self isAlive])
    {
        return;
    }
    
    // 设置生命值
    [self setLife:self.fighterVo.life - damage];
    
    if (damage > 0)
    {
        // 显示掉血效果
        NSString *text = [NSString stringWithFormat:@"- %d",damage];
        [self addTextEffectWithType:kTextEffectTypeLoss text:text];
    }
    
    // 死亡
    if (self.life <= 0)
    {
        [self die];
    }
}

-(void) die
{
    self.state = kFighterStateDied;
    
    // 播放死亡音效
    [self.profile playSoundSolo:@"die"];
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
    [fightField addEffectSprite:effect];
    
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

-(void) addTextEffectWithType:(int)ty text:(NSString*)te
{
    if (textEffectQueue.count < 2)
    {
        FightTextEffect *tf = [[FightTextEffect alloc] initWithType:ty text:te pos:CGPointZero];
        [textEffectQueue addObject:tf];
        [tf release];
    }
}

/// 更新文字特效
-(void) updateTextEffects:(ccTime)delta
{
    // update text effect
    textEffectTimer -= delta;
    if (textEffectQueue.count > 0 && textEffectTimer <= 0)
    {
        FightTextEffect *effect = [textEffectQueue objectAtIndex:0];
        
        effect.position = ccp(self.position.x,self.position.y + ([KITApp isHD]?40.0f:20.0f));
        [effect start];
        [fightField addEffectSprite:effect];
        [textEffectQueue removeObjectAtIndex:0];
        textEffectTimer = 0.35f;
    }
}


#pragma mark -
#pragma mark Animation

/// 设置动画
-(void) setAnimation:(NSString *)name
{
    [animationManager runAnimationsForSequenceNamed:name];
    runningAnim = name;
}

/// 检查给定的动画名称确认是否正在播放
-(BOOL) isAnimationRunning:(NSString*)name
{
    return [animationManager.runningSequenceName isEqualToString:name];
}


#pragma mark -
#pragma mark Attack

-(void) move
{
    
}

/// 攻击
-(void) attack
{
    
}


@end
