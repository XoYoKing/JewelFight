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
#import "NewJewelsCommandData.h"
#import "DeadJewelsCommandData.h"
#import "PVPOpponentAndFightersCommandData.h"



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

-(void) requestSwapJewelWithActionId:(long)actionId jewelGlobalId1:(int)jewelGlobalId1 jewelGlobalId2:(int)jewelGlobalId2
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1110];
    [encoder writeInt8:4];
    [encoder writeInt64:actionId];
    [encoder writeInt32:jewelGlobalId1];
    [encoder writeInt32:jewelGlobalId2];
    [encoder release];
    
    [[GameController sharedController].server send:SERVER_GAME data:data];
}

/// 消除宝石
-(void) requestEliminateWithActionId:(long)actionId continueEliminate:(int)continueEliminate eliminateGroup:(NSMutableArray*)group
{
    
    KITLog(@"group: %@",group);
    
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1110];
    [encoder writeInt8:5];
    [encoder writeInt64:actionId];
    [encoder writeInt32:continueEliminate];
    
    // 写入连接宝石组数量
    [encoder writeInt32:group.count];
    
    for (CCArray *connectedList in group)
    {
        // 写入连接宝石数量
        [encoder writeInt32:connectedList.count];
        for (JewelVo *connected in connectedList)
        {
            [encoder writeInt32:connected.globalId];
        }
    }
    
    [encoder release];
    [[GameController sharedController].server send:SERVER_GAME data:data];
}


/// 死局, 请求新的宝石队列
-(void) requestDeadWithActionId:(long)actionId
{
    NSMutableData *data = [NSMutableData data];
    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:data];
    [encoder writeInt16:101];
    [encoder writeInt16:1110];
    [encoder writeInt8:6];
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
    [encoder release];
    
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
        case SERVER_ACTION_PVP_INIT_JEWELS:
        {
            [self handleInitJewels:data];
            break;
        }
        // 开始战斗
        case SERVER_ACTION_PVP_FIGHT_START:
        {
            [self handlePvPFightStart:data];
            break;
        }
        // 交换宝石位置
        case SERVER_ACTION_PVP_SWAP_JEWELS:
        {
            [self handleSwapJewels:data];
            break;
        }
            
        // 新到宝石
        case SERVER_ACTION_PVP_ADD_NEW_JEWELS:
        {
            [self handleNewJewels:data];
            break;
        }
            
        // 死局更新宝石
        case SERVER_ACTION_PVP_DEAD_JEWELS:
        {
            [self handleDeadJewels:data];
            break;
        }
    }
}


/// 处理PvP初始化宝石队列
-(void) handleInitJewels:(ServerDataDecoder*)data
{
    // autorelease
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:2];
    
    // 先获取玩家宝石数量
    // 数量
    int boardWidth = [data readInt32]; //
    CCArray *playerJewels = [[CCArray alloc] initWithCapacity:boardWidth];
    for (int x = 0;x < boardWidth; x++)
    {
        CCArray *column = [[CCArray alloc] initWithCapacity:10];
        [playerJewels addObject:column];
        [column release];
        
        int columnCount = [data readInt32];
        for (int i = 0; i < columnCount; i++)
        {
            JewelVo *jewelVo = [[JewelVo alloc] init];
            [FightCommand populateJewelVo:jewelVo data:data];
            [column addObject:jewelVo];
            [jewelVo release];
        }
    }
    [dict setObject:playerJewels forKey:@"player_jewels"];
    [playerJewels release];
    
    // 再获取对手宝石数量
    boardWidth = [data readInt32]; //
    CCArray *opponentJewels = [[CCArray alloc] initWithCapacity:boardWidth];
    for (int x = 0;x < boardWidth; x++)
    {
        CCArray *column = [[CCArray alloc] initWithCapacity:10];
        [opponentJewels addObject:column];
        [column release];
        
        int columnCount = [data readInt32];
        for (int i = 0; i < columnCount; i++)
        {
            JewelVo *jewelVo = [[JewelVo alloc] init];
            [FightCommand populateJewelVo:jewelVo data:data];
            [column addObject:jewelVo];
            [jewelVo release];
        }
    }
    [dict setObject:opponentJewels forKey:@"opponent_jewels"];
    [opponentJewels release];
    
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_INIT_JEWELS object:dict];
}

/// 处理PvP死局宝石队列
-(void) handleDeadJewels:(ServerDataDecoder*)data
{
    //
    DeadJewelsCommandData *serverData = [[[DeadJewelsCommandData alloc] init] autorelease];
    
    serverData.userId = [data readInt64]; // 关联用户标识
    
    // 先获取玩家宝石数量
    
    int boardWidth = [data readInt32]; //
    for (int x = 0;x < boardWidth; x++)
    {
        CCArray *column = [[CCArray alloc] initWithCapacity:11];
        [serverData.jewelVoList addObject:column];
        [column release];
        
        int columnCount = [data readInt32];
        for (int i = 0; i < columnCount; i++)
        {
            JewelVo *jewelVo = [[JewelVo alloc] init];
            [FightCommand populateJewelVo:jewelVo data:data];
            [column addObject:jewelVo];
            [jewelVo release];
        }
    }
    
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_DEAD_JEWELS object:serverData];
}

-(void) handleNewJewels:(ServerDataDecoder*)data
{
    long userId = [data readInt64]; // 玩家标识
    
    int boardWidth = [data readInt32]; //
    CCArray *jewels = [[CCArray alloc] initWithCapacity:boardWidth];
    for (int x = 0;x < boardWidth; x++)
    {
        CCArray *column = [[CCArray alloc] initWithCapacity:10];
        [jewels addObject:column];
        [column release];
        
        int columnCount = [data readInt32];
        for (int i = 0; i < columnCount; i++)
        {
            JewelVo *jewelVo = [[JewelVo alloc] init];
            [FightCommand populateJewelVo:jewelVo data:data];
            [column addObject:jewelVo];
            [jewelVo release];
        }
    }
    
    NewJewelsCommandData *obj = [[[NewJewelsCommandData alloc] init] autorelease];
    obj.userId = userId;
    [obj setJewelVoList:jewels];
    [jewels release];
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_ADD_NEW_JEWELS object:obj];
}

/// 获取战斗场景的对手及对手的全部战士信息
-(void) handlePvPOpponentAndFighters:(ServerDataDecoder*)data
{
    PVPOpponentAndFightersCommandData *cData = [[[PVPOpponentAndFightersCommandData alloc] init] autorelease];
    
    // 获取玩家战士信息
    int amount = [data readInt32];
    for (int i = 0;i < amount; i++)
    {
        FighterVo *fighter = [[FighterVo alloc] init];
        [FightCommand populateFighterVo:fighter data:data];
        [cData.playerFighters addObject:fighter];
        [fighter release];
    }
    
    // 获取对手用户信息
    [GameCommand populateUserInfo:cData.opponentUserInfo data:data];
    
    // 获取对手战士数量
    amount = [data readInt32];
    
    for(int i=0;i<amount;i++)
    {
        FighterVo *fighter = [[FighterVo alloc] init];
        [FightCommand populateFighterVo:fighter data:data];
        [cData.opponentFighters addObject:fighter];
        [fighter release];
    }
    
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_OPPONENT_AND_FIGHTERS object:cData];
}

/// 开始战斗
-(void) handlePvPFightStart:(ServerDataDecoder*)data
{
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_FIGHT_START object:nil];
}


/// 处理交换宝石位置
-(void) handleSwapJewels:(ServerDataDecoder*)data
{
    long userId = [data readInt64]; // 用户标识
    long actionId = [data readInt64]; // 宝石动作标识
    NSString *jewel1 = [data readUTF];
    NSString *jewel2 = [data readUTF];
    
    // autorelease
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:userId forKey:@"userId"];
    [dict setObject:actionId forKey:@"actionId"];
    [dict setObject:jewel1 forKey:@"jewel1"];
    [dict setObject:jewel2 forKey:@"jewel2"];
    
    [self responseToListenerWithActionId:SERVER_ACTION_PVP_SWAP_JEWELS object:dict];
}



@end
