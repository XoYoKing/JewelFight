//
//  FightCommand.m
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPCommand.h"
#import "FightCommand.h"
#import "FighterVo.h"
#import "HeroVo.h"
#import "AttackVo.h"
#import "Constants.h"
#import "ServerDataEncoder.h"
#import "ServerDataDecoder.h"
#import "GameController.h"
#import "GameServer.h"
#import "GameCommand.h"
#import "UserInfo.h"
#import "PlayerInfo.h"
#import "JewelVo.h"



@implementation PvPCommand

#pragma mark -
#pragma mark Request

/// 请求pvp
-(void) requestPvP
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1110];
    [encoder writeInt8:1];
    [encoder release];
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 请求战斗
-(void) requestFight
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1110];
    [encoder writeInt8:2];
    [encoder release];
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 请求开战
-(void) requestFightStart
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1110];
    [encoder writeInt8:3];
    [encoder release];
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

-(void) requestSwapStoneWithActionId:(long)actionId jewelId1:(NSString*)jewelId1 jewelId2:(NSString*)jewelId2
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:2];
    [encoder writeInt64:actionId];
    [encoder writeUTF:jewelId1];
    [encoder writeUTF:jewelId2];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}


/// 死局, 请求新的宝石队列
-(void) requestDeadWithActionId:(long)actionId
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:4];
    [encoder release];
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 加载完毕,准备战斗
-(void) requestFightReady
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:6];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 操作分数
-(void) requestOperate:(double)operate value:(int)value
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:8];
    [encoder writeInt32:value];
    [encoder writeDouble:operate];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 请求攻击
-(void) requestAttack:(int)value
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:5];
    [encoder writeInt32:value];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 消除宝石
-(void) requestDisposeWithActionId:(long)actionId continueDispose:(int)continueDispose disposeStoneIds:(CCArray*)disposeStoneIds
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:3];
    [encoder writeInt64:actionId];
    [encoder writeInt32:continueDispose];
    [encoder writeInt32:disposeStoneIds.count];
    
    for (NSString *jewelId in disposeStoneIds)
    {
        [encoder writeUTF:jewelId];
    }
    
    [encoder release];
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 请求时装技能
-(void) requestExSkill:(int)skillId
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:9];
    [encoder writeInt32:skillId];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 请求退出战斗
-(void) requestQuitFight
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:7];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}



#pragma mark -
#pragma mark Response

-(void) executeWithActionId:(int)actionId data:(ServerDataDecoder *)data
{
    switch (actionId)
    {
        // 接收PvP对手及英雄列表
        case SERVER_ACTION_PVP_OPPONENT_AND_FIGHTERS:
        {
            [self handlePvPOpponentAndFighters:data];
            break;
        }
        // 接收PvP宝石初始化信息 
        case SERVER_ACTION_PVP_INIT_STONES:
        {
            [self handleInitStones:data];
            break;
        }
        // 开始战斗
        case SERVER_ACTION_PVP_FIGHT_START:
        {
            [self handlePvPFightStart:data];
            break;
        }
        // 交换宝石位置
        case SERVER_ACTION_PVP_SWAP_STONES:
        {
            [self handleSwapStones:data];
        }
    }
}


/// 处理PvP初始化宝石队列
-(void) handleInitStones:(ServerDataDecoder*)data
{
    // autorelease
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // 先获取玩家宝石数量
    // 数量
    int amount = [data readInt32]; //
    CCArray *playerStones = [[CCArray alloc] initWithCapacity:amount];
    for (int i = 0;i < amount; i++)
    {
        JewelVo *stoneVo = [[JewelVo alloc] init];
        [FightCommand populateJewelVo:stoneVo data:data];
        [playerStones addObject:stoneVo];
    }
    [dict setObject:playerStones forKey:@"player_stones"];
    
    // 再获取对手宝石数量
    amount = [data readInt32];
    CCArray *opponentStones = [[CCArray alloc] initWithCapacity:amount];
    for (int i = 0;i < amount; i++)
    {
        JewelVo *stoneVo = [[JewelVo alloc] init];
        [FightCommand populateJewelVo:stoneVo data:data];
        [opponentStones addObject:stoneVo];
    }
    [dict setObject:opponentStones forKey:@"opponent_stones"];
    
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_INIT_STONES object:dict];
}


/// 获取战斗场景的对手及对手的全部战士信息
-(void) handlePvPOpponentAndFighters:(ServerDataDecoder*)data
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:5];
    
    // 获取玩家战士信息
    int amount = [data readInt32];
    CCArray *playerFighters = [[CCArray alloc] initWithCapacity:5];
    for (int i = 0;i < amount; i++)
    {
        FighterVo *fighter = [[FighterVo alloc] init];
        [FightCommand populateFighterVo:fighter data:data];
        [playerFighters addObject:fighter];
        [fighter release];
    }
    
    [dict setObject:playerFighters forKey:@"player_fighters"];
    
    // 获取对手用户信息
    UserInfo *opponentUser = [[UserInfo alloc] init];
    [GameCommand populateUserInfo:opponentUser data:data];
    
    [dict setObject:opponentUser forKey:@"opponent_user"];
    
    // 获取对手战士数量
    amount = [data readInt32];
    
    CCArray *opponentFighters = [[CCArray alloc] initWithCapacity:5];
    for(int i=0;i<amount;i++)
    {
        FighterVo *fighter = [[FighterVo alloc] init];
        [FightCommand populateFighterVo:fighter data:data];
        [opponentFighters addObject:fighter];
        [fighter release];
    }
    
    [dict setObject:opponentFighters forKey:@"opponent_fighters"];
    
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_OPPONENT_AND_FIGHTERS object:dict];
}

/// 开始战斗
-(void) handlePvPFightStart:(ServerDataDecoder*)data
{
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_FIGHT_START object:nil];
}


/// 处理交换宝石位置
-(void) handleSwapStones:(ServerDataDecoder*)data
{
    long userId = [data readInt64]; // 用户标识
    long actionId = [data readInt64]; // 宝石动作标识
    NSString *stone1 = [data readUTF];
    NSString *stone2 = [data readUTF];
    
    // autorelease
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:actionId forKey:@"actionId"];
    [dict setObject:stone1 forKey:@"stone1"];
    [dict setObject:stone2 forKey:@"stone2"];
    
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_SWAP_STONES object:dict];
}



@end
