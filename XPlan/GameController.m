//
//  GameController.m
//  XPlan
//
//  Created by Hex on 3/27/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GameController.h"
#import "GameServer.h"
#import "PvPScene.h"
#import "MockGameServer.h"

static GameController *_gameControllerInstance = nil;

@implementation GameController

@synthesize server,playerInfo,state,sessionId;

#pragma mark -
#pragma mark Class methods

+(GameController*) sharedController
{
    @synchronized([GameController class])
    {
        if (!_gameControllerInstance)
        {
            _gameControllerInstance = [[self alloc] init];
        }
    }
    
    return _gameControllerInstance;
}

+(id) alloc
{
    @synchronized([GameController class])
    {
        KITAssert(_gameControllerInstance == nil, @"There can only be one GameController singleton");
        return [super alloc];
    }
    return nil;
}

#pragma mark -
#pragma mark Instance methods

-(id) init
{
    if ((self = [super init]))
    {
        // 初始化服务器连接
        //[self initServer];
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}


/// 初始化服务器连接
-(void) initServer
{
    server = [[MockGameServer alloc] init];
}

/// 获取宝石配置信息
-(KITProfile*) getStoneProfileWithType:(NSString*)stoneType
{
    NSString *key = [NSString stringWithFormat:@"stone_%@_profile",stoneType];
    return [KITProfile profileWithName:key];
}

/// 执行战斗场景
-(void) runPvPFightScene
{
    PvPScene *scene = [[PvPScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:scene];
    [scene release];
}

@end
