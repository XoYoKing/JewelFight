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
#import "Constants.h"
#import "DDLog.h"
#import "PlayerInfo.h"

static GameController *_gameControllerInstance = nil;

@implementation GameController

@synthesize server,player,state,sessionId;

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
    }
    
    return self;
}

-(void) dealloc
{
    [player release];
    [super dealloc];
}

-(void) initialize
{
    // 初始化玩家信息
    player = [[PlayerInfo alloc] init];
    player.userId = 1;
    player.name = @"刀剑笑";
    player.sex = 0;
    player.silver = 3000;
    player.gold = 1000;
    player.diamond = 100000;
    
    [self initServer];
}

/// 初始化服务器连接
-(void) initServer
{
    if (MOCK_MODE)
    {
        server = [[MockGameServer alloc] init];
    }
    else
    {
        server = [[GameServer alloc] init];
        //NSString *host = @"127.0.0.1";
        NSString *host = @"192.168.1.102";
        [server registerServer:SERVER_GAME host:host port:9080];
    }
}

/// 获取宝石配置信息
-(KITProfile*) getJewelProfileWithType:(NSString*)jewelType
{
    NSString *key = [NSString stringWithFormat:@"jewel_%@_profile",jewelType];
    return [KITProfile profileWithName:key];
}

/// 执行战斗场景
-(void) runPvPScene
{
    PvPScene *scene = [[PvPScene alloc] init];
    [[CCDirector sharedDirector] replaceScene:scene];
    [scene release];
}

@end
