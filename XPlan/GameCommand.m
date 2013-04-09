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
#import "StoneVo.h"
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
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
}

/// 点击准备按钮
-(void) requestSteadyFight
{
    NSMutableData *data = [NSMutableData data];
    
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1100];
    [encoder writeInt8:2];
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
}

/// 请求进入游戏
-(void) requestEnterGame
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:1001];
    [encoder writeInt32:[GameController sharedController].sessionId];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    
    // 封装用户形象英雄信息
    user.figureHero = [[[HeroVo alloc] init] autorelease];
    user.figureHero.userId = user.userId;
    user.figureHero.heroId = user.userId; // 英雄标识
    user.figureHero.name = user.name; // 英雄名称
    user.figureHero.head = user.figureHero.fashion = [data readInt32];
    user.figureHero.level = [data readInt16];
    user.figureHero.exp = [data readInt64];
    user.figureHero.maxExp = [data readInt64];
    user.figureHero.energy = [data readInt32]; // physical
    user.figureHero.maxEnergy = [data readInt32]; // max physical
    
    // 继续封用户信息
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
    [[GameController sharedController] setPlayerInfo: playerVo];
    
    // 封装玩家英雄信息?
    // TODO: 需要更改这块的逻辑,原因是原型的服务器端认为玩家就是英雄
    
    
    
    // 玩家信息获取完毕事件
    [self responseToListenerWithActionId:SERVER_ACTION_ID_PLAYER_INFO object:playerVo];
}

/// 更新玩家信息
-(void) handleUpdatePlayerInfo:(ServerDataDecoder*)data
{
    PlayerInfo *playerVo = [GameController sharedController].playerInfo;
    
    // 更新玩家信息
    [self populatePlayerInfo:playerVo data:data];
    
    // 玩家信息更新完毕事件
    [self responseToListenerWithActionId:SERVER_ACTION_ID_UPDATE_PLAYER_INFO object:playerVo];
}



/// 处理宝石队列
-(void) handleStoneColumn:(ServerDataDecoder*)data
{
    // 玩家标识
    long userId = [data readInt64];
    
    // 数量
    int amount = [data readInt32]; //
    CCArray *stoneList = [[[CCArray alloc] init] autorelease];
    for (int i = 0;i < amount; i++)
    {
        StoneVo *stoneVo = [[StoneVo alloc] init];
        [stoneList addObject:stoneVo];
    }

[self responseToListenerWithActionId:SERVER_ACTION_ID_STONE_COLUMN object0:userId object1:stoneList];
}

/// 处理开始战斗
-(void) handleStartEnable:(ServerDataDecoder*)data
{
    //只是通知
    [self responseToListenerWithActionId:SERVER_ACTION_ID_PVP_START_ENABLE object:nil];
}

/// 处理交换宝石位置
-(void) handleSwapStones:(ServerDataDecoder*)data
{
    long userId = [data readInt64]; // 用户标识
    long actionId = [data readInt64]; // 宝石动作标识
    NSString *stone1 = [data readUTF];
    NSString *stone2 = [data readUTF];
    CCArray *params = [[[CCArray alloc] init] autorelease];
    [params addObject:userId];
    [params addObject:actionId];
    [params addObject:stone1];
    [params addObject:stone2];
    
    [self responseToListenerWithActionId:SERVER_ACTION_ID_SWAP_STONES object:params];
}

-(void) executeWithActionId:(int)actionId data:(ServerDataDecoder *)data
{
    switch (actionId)
    {
        // 接收英雄信息
        case SERVER_ACTION_ID_PLAYER_INFO:
        {
            [self handlePlayerInfo:data];
            break;
        }
        case SERVER_ACTION_ID_STONE_COLUMN:
        {
            [self handleStoneColumn:data];
            break;
        }
        case SERVER_ACTION_ID_PVP_START_ENABLE:
        {
            [self handleStartEnable:data];
            break;
        }
    }
}




@end
