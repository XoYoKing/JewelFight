//
//  FightCommand.m
//  XPlan
//
//  Created by Hex on 4/3/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PvPFightCommand.h"
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



@implementation PvPFightCommand

#pragma mark -
#pragma mark Request

/// 请求开战
-(void) requestStartFight
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:1];
    [encoder release];
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
}

-(void) requestSwapStoneWithActionId:(long)actionId stoneId1:(NSString*)stoneId1 stoneId2:(NSString*)stoneId2
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:2];
    [encoder writeInt64:actionId];
    [encoder writeUTF:stoneId1];
    [encoder writeUTF:stoneId2];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
}

/// 加载完毕,准备战斗
-(void) requestFightReady
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1200];
    [encoder writeInt8:6];
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    
    for (NSString *stoneId in disposeStoneIds)
    {
        [encoder writeUTF:stoneId];
    }
    
    [encoder release];
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
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
    
    [[GameController sharedController].server send:SERVER_TYPE_GAME data:data];
}



#pragma mark -
#pragma mark Response

-(void) executeWithActionId:(int)actionId data:(ServerDataDecoder *)data
{
    switch (actionId)
    {
        // 接收PvP对手及英雄列表
        case SERVER_ACTION_ID_PVP_OPPONENT_AND_FIGHTERS:
        {
            [self handlePvPOpponentAndFighters:data];
            break;
        }
        // 开始战斗
        case SERVER_ACTION_ID_PVP_START_FIGHT:
        {
            [self handlePvPStartFight:data];
            break;
        }
    }
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
    
    [self responseToListenerWithActionId:SERVER_ACTION_ID_PVP_OPPONENT_AND_FIGHTERS object:dict];
}

/// 开始战斗
-(void) handlePvPStartFight:(ServerDataDecoder*)data
{
    [self responseToListenerWithActionId:SERVER_ACTION_ID_PVP_START_FIGHT object:nil];
}


@end
