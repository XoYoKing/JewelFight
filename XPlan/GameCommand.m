//
//  GameCommand.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GameCommand.h"
#import "Constants.h"
#import "GameController.h"
#import "PlayerInfo.h"
#import "GemVo.h"
#import "FighterVo.h"
#import "ServerDataEncoder.h"
#import "ServerDataDecoder.h"
#import "GameServer.h"
#import "AttackVo.h"

@implementation GameCommand

-(id) init
{
    if ((self = [super init]))
    {
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) update:(ccTime)delta
{
    
}

#pragma mark -
#pragma mark Request

/// 请求心跳
-(void) requestHeart
{
    NSMutableData *data = [NSMutableData data];
    
    // 方便封装
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:-1];
    [encoder writeInt8:1];
    [encoder release];
    
    // 发出
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 点击准备按钮
-(void) requestSteadyFight
{
    NSMutableData *data = [NSMutableData data];
    
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1100];
    [encoder writeInt8:2];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 请求进入游戏
-(void) requestEnterGame
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:1001];
    [encoder writeInt32:[GameController sharedController].sessionId];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 请求连接房间
-(void) requestHomeWithHomeId:(NSString*)homeId
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1100];
    [encoder writeInt8:1];
    [encoder writeUTF:homeId];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 请求退出房间
-(void) requestQuitRoom
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1100];
    [encoder writeInt8:4];
    [encoder release];
    [[GameController sharedController].server send:SERVER_GAME data:data];
}



#pragma mark -
#pragma mark Populate Methods

/// 封装用户数据
+(void) populateUserInfo:(UserInfo*)user data:(ServerDataDecoder*)data
{
    // TODO: 后端服务器的model架构最好跟前端一样!!!
    
    user.userId = [data readInt64];
    user.name = [data readUTF];
    user.currentMap = [data readUTF];
    user.sex = [data readInt16];
    user.diamond = [data readInt64];
    user.silver = [data readInt64];
    user.gold = [data readInt64];
}

/// 封装玩家数据
+(void) populatePlayerInfo:(PlayerInfo*)player data:(ServerDataDecoder*)data
{
    [self populateUserInfo:player data:data];
    
}

/// 封装武将数据
+(void) populateHeroVo:(HeroVo*)hero data:(ServerDataDecoder*)data
{
    hero.heroId = [data readInt64];
    
}


#pragma mark -
#pragma mark Response

/// 处理玩家信息 (Demo版本把Hero和玩家搞混了...)
-(void) handlePlayerInfo:(ServerDataDecoder*)data
{
    PlayerInfo *playerVo = [[[PlayerInfo alloc] init] autorelease];
    
    // 封装玩家信息
    [self populatePlayerInfo:playerVo data:data];
    [[GameController sharedController] setPlayer: playerVo];
    
    // 封装玩家英雄信息?
    // TODO: 需要更改这块的逻辑,原因是原型的服务器端认为玩家就是英雄
    
    
    
    // 玩家信息获取完毕事件
    [self responseToListenerWithActionId:SERVER_ACTION_PLAYER_INFO object:playerVo];
}

/// 更新玩家信息
-(void) handleUpdatePlayerInfo:(ServerDataDecoder*)data
{
    PlayerInfo *playerVo = [GameController sharedController].player;
    
    // 更新玩家信息
    [self populatePlayerInfo:playerVo data:data];
    
    // 玩家信息更新完毕事件
    [self responseToListenerWithActionId:SERVER_ACTION_UPDATE_PLAYER_INFO object:playerVo];
}


-(void) executeWithActionId:(int)actionId data:(ServerDataDecoder *)data
{
    switch (actionId)
    {
        // 接收英雄信息
        case SERVER_ACTION_PLAYER_INFO:
        {
            [self handlePlayerInfo:data];
            break;
        }
    }
}




@end
