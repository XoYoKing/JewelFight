//
//  FightController.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPController.h"
#import "GameController.h"
#import "PvPScene.h"
#import "PvPLayer.h"
#import "PvPHudLayer.h"
#import "PvPFighterPanel.h"
#import "GameController.h"
#import "PlayerInfo.h"
#import "FighterVo.h"
#import "GameServer.h"
#import "Constants.h"
#import "HeroVo.h"
#import "FighterVo.h"
#import "PvPPortraitPanel.h"
#import "PvPLoadingController.h"
#import "PvPFightController.h"

@interface PvPController()
{
}

@end

@implementation PvPController

@synthesize scene,state,newState,loadingController,fightController;

-(id) initWithScene:(PvPScene *)s
{
    if ((self = [super init]))
    {
        scene = s;
        state = -1;
        newState = -1;
        
        loadingController = [[PvPLoadingController alloc] initWithPvPController:self];
        fightController = [[PvPFightController alloc] initWithPvPController:self];
        
        [self initialize];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) initialize
{
    // 开始加载
    newState = kPvPStateLoading;
}

#pragma mark -
#pragma mark Loading

/// 开始加载
-(void) enterLoading
{    
    // 显示加载页面
    [loadingController enterLoading];
    
}


-(void) update:(ccTime)delta
{
    // 检查状态
    if (self.state!=self.newState)
    {
        [self changeState:self.newState];
    }
    
    if (self.state == kPvPStateLoading)
    {
        // 加载状态下,更新加载管理器
        [loadingController update:delta];
    }
    else if (self.state == kPvPStateFight)
    {
        // 战斗状态下,更新战斗管理器
        [fightController update:delta];
    }
}


-(void) changeState:(int)value
{
    state = newState = value;
    
    switch (state)
    {
        case kPvPStateLoading:
        {
            [self enterLoading];
            break;
        }
        case kPvPStateFight:
        {
            // 释放pvp加载管理器的资源
            [loadingController release];
            loadingController = nil;
            
            // 开始战斗
            [fightController startFight];
            break;
        }
    }    
}

@end
