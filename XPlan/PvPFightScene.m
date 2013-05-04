//
//  FightScene.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightScene.h"
#import "GameController.h"
#import "GameServer.h"
#import "Constants.h"
#import "PvPFightController.h"
#import "UserInfo.h"
#import "HeroVo.h"
#import "PvPFightLoadingLayer.h"
#import "PvPFightLayer.h"
#import "PvPFightHudLayer.h"

@interface PvPFightScene()

-(void) update:(ccTime)delta;

@end

@implementation PvPFightScene

@synthesize oppFightHeroList,oppUser,controller;

-(id) init
{
    if ((self = [super init]))
    {
        controller = [[PvPFightController alloc] initWithScene:self];
        state = 0;
    }
    
    return self;
}

-(void) dealloc
{
    [controller release];
    [oppUser release];
    [oppFightHeroList release];
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    [controller update:delta];
}

-(CCArray*) oppFightHeroList
{
    if (oppFightHeroList == nil)
    {
        oppFightHeroList = [[CCArray alloc] initWithCapacity:5];
    }
    
    return oppFightHeroList;
}

-(void) onEnter
{
    [super onEnter];
}

-(void) onEnterTransitionDidFinish
{
    [super onEnterTransitionDidFinish];
}

///
-(void) enterLoading
{
    PvPFightLoadingLayer *loadingLayer = [[PvPFightLoadingLayer alloc] init];
    [self addChild:loadingLayer z:1 tag:kTagPvPFightLoadingLayer];
}

/// 退出加载
-(void) exitLoading
{
    // 删掉加载层
    [self removeChildByTag:kTagPvPFightLoadingLayer];
}

/// 进入战斗
-(void) enterFight
{
    // 显示战斗层
    PvPFightLayer *fightLayer = [[PvPFightLayer alloc] init];
    [self addChild:fightLayer z:0 tag:kTagPvPFightLayer];
    [fightLayer release];
    
    // 初始化
    
    
    
}

@end
