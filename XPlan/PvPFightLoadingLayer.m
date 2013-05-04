//
//  PvPFightLoadingLayer.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightLoadingLayer.h"
#import "PvPScene.h"
#import "PvPFightController.h"
#import "CCBReader.h"

@interface PvPFightLoadingLayer()
{
    float percent;
    int step; // 加载步骤
    ccTime costTime;
}

@end

@implementation PvPFightLoadingLayer

-(id) init
{
    if ((self = [super init]))
    {
        // 初始化UI
        [self initUI];
        
        // 开始循环
        [self schedule:@selector(update:) interval:[[CCDirector sharedDirector] animationInterval]];
    }
    
    return self;
}

-(void) dealloc
{
    [loadingBar release];
    [super dealloc];
}

-(void) initUI
{
    CCNode *node = [CCBReader nodeGraphFromFile:@"pvp_loading.ccbi" owner:self];
    [self addChild:node];
    
    CGPoint barPos = loadingBgSprite.position;
    
    loadingBar = [[HonsterBar alloc] initBarWithBarSprite:loadingBarSprite insetSprite:loadingBgSprite maskSprite:loadingMaskSprite];
    [self addChild:loadingBar];
    loadingBar.position = barPos;
    loadingBar.progress = 0;
}

-(void) setPercent:(float)value
{
    percent = value;
    loadingBar.progress = value;
}

-(void) update:(ccTime)delta
{
    if (percent >= 100)
    {
        [self unscheduleAllSelectors];
        [self loadingFinished];
        return;
    }
    
    switch (step)
    {
            
    }
    
    costTime+=delta;
    [self setPercent: costTime / 5 * 100];
}

/// 变更步骤
-(void) changeStep:(int)value
{
    step = value;
    switch (step)
    {
        case 0:
            // 第一步, 向服务器端请求对手信息
            break;
        case 1:
            // 第2步, 对手信息初始化完成,准备战斗
            break;
    }
}

-(PvPScene*) getFightScene
{
    return (PvPScene*)self.parent;
}

-(void) loadingFinished
{
    // 加载完成, 通知PvP战斗更新
    [[self getFightScene].controller loadingDone];
}

@end
