//
//  PvPFightLoadingLayer.m
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightLoadingLayer.h"
#import "PvPFightScene.h"
#import "PvPFightController.h"

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
    CGSize winSize = [KITApp winSize];
    CCSprite *bg = [[CCSprite alloc] initWithFile:@"loadingBg.png"];
    [self addChild:bg];
    bg.anchorPoint = ccp(0.5f,0.5f);
    bg.position = ccp(winSize.height/2,winSize.width/2);
    [bg release];
    
    loadingBar = [[GPBar alloc] initBarWithBar:@"loadingBar.png" inset:@"loadingInset.png" mask:@"loadingMask.png"];
    [self addChild:loadingBar];
    loadingBar.position = ccp(0,-[KITApp scale:78]);
    loadingBar.progress = 0;
    
    // 初始化描述
    CCLabelTTF *title = [[CCLabelTTF alloc] initWithString:@"加载中" fontName:@"MarkerFelt-Wide" fontSize:20];
    title.anchorPoint=ccp(0.5f,0.5f);
    title.position = ccp([KITApp scale:0],-[KITApp scale:100]);
    [self addChild:title];
    [title release];
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

-(PvPFightScene*) getFightScene
{
    return (PvPFightScene*)self.parent;
}

-(void) loadingFinished
{
    // 加载完成, 通知PvP战斗更新
    [[self getFightScene].controller loadingDone];
}

@end
