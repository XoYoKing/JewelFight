//
//  GameLoadingScene.m
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GameLoadingScene.h"
#import "GameUpdateFilesLayer.h"

@interface GameLoadingScene()


-(void) update:(ccTime)delta;

@end

@implementation GameLoadingScene

-(id) init
{
    if ((self = [super init]))
    {
        
        
        state = -1;
        newState = -1;
        
        // schedule an update
        [self schedule:@selector(update:) interval:[[CCDirector sharedDirector] animationInterval]];
        
        CCLayer *loadingLayer = [GameUpdateFilesLayer node];
        [self addChild:loadingLayer];
        
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) onEnter
{
    // 设置状态为检查游戏版本
    newState = kGameLoadingStepCheckVersion;
    
    [super onEnter];
}


-(void) update:(ccTime)delta
{
    if (newState!=state)
    {
        [self changeState:newState];
    }
}

-(void) changeState:(int)value
{
    state = value;
    newState = value;
    
    switch (state)
    {
            // 检查版本
        case kGameLoadingStepCheckVersion:
        {
            // http连接服务器,获取更新文件
            
            break;
        }
    }
    
}

@end
