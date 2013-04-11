//
//  MockGameServer.m
//  XPlan
//
//  Created by Hex on 4/11/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "MockGameServer.h"
#import "ServerDataDecoder.h"
#import "ServerDataEncoder.h"
#import "FighterVo.h"
#import "StoneVo.h"
#import "UserInfo.h"
#import "PlayerInfo.h"
#import "HeroVo.h"
#import "GameController.h"

#define kMockPlayerUserId 1 //假冒玩家用户标识
#define kMockOpponentUserId 2 // 假冒对手用户标识

@implementation MockGameServer

-(id) init
{
    if ((self = [super init]))
    {
        // 初始化玩家信息
        PlayerInfo *player = [[PlayerInfo alloc] init];
        player.userId = kMockPlayerUserId;
        player.name = @"刀剑笑";
        player.sex = 0;
        player.silver = 3000;
        player.gold = 1000;
        player.diamond = 100000;
        [GameController sharedController].playerInfo = player;
        [player release];
        
        
    }
    
    return self;
}

/// 发送数据
-(void) send:(NSString *)server data:(NSData *)data
{
    // 解析数据
    ServerDataDecoder *decoder = [[ServerDataDecoder alloc] initWithData:data];
    int gameServer = [decoder readInt16];
    int module = [decoder readInt16];
    int method = [decoder readInt8];
    
    if (gameServer == 101)
    {
        // pvp 模块
        if (module == 1110)
        {
            switch (method)
            {
                // 请求pvp
                case 1:
                {
                    // 响应server_action_opponent_and_fighters actionId:800
                    NSMutableData *response = [NSMutableData data];
                    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:response];
                    
                    [encoder writeInt32:SERVER_ACTION_PVP_OPPONENT_AND_FIGHTERS];
                    
                    // 假冒一个对手玩家和对手战士集合和创建一个玩家的战士集合
                    // 玩家出战3个英雄
                    [encoder writeInt32:3];
                    FighterVo *fv = [[FighterVo alloc] init];
                    fv.userId = kMockPlayerUserId;
                    fv.heroId = 1001; // 英雄标识
                    fv.heroType = 1; // 张飞
                    fv.team = 0; // 玩家阵营
                    fv.name = @"张飞";
                    fv.sex = 0; // 男性
                    fv.head = 1; //
                    fv.fashion = 1;
                    fv.maxHp = 300; // 300 血量
                    fv.maxAnger = 100; // 100 怒气值
                    [self compressFighterVo:fv toData:encoder];
                    [fv release];
                    
                    // 第2个武将
                    fv = [[FighterVo alloc] init];
                    fv.userId = kMockPlayerUserId;
                    fv.heroId = 1002; // 英雄标识
                    fv.heroType = 2;
                    fv.team = 0; // 玩家阵营
                    fv.name = @"关羽";
                    fv.sex = 0; // 男性
                    fv.head = 1; //
                    fv.fashion = 1;
                    fv.maxHp = 500; // 300 血量
                    fv.maxAnger = 200; // 100 怒气值
                    [self compressFighterVo:fv toData:encoder];
                    [fv release];
                    
                    // 第3个武将
                    fv = [[FighterVo alloc] init];
                    fv.userId = kMockPlayerUserId;
                    fv.heroId = 1003; // 英雄标识
                    fv.heroType = 3;
                    fv.team = 0; // 玩家阵营
                    fv.name = @"刘备";
                    fv.sex = 0; // 男性
                    fv.head = 1; //
                    fv.fashion = 1;
                    fv.maxHp = 200; // q00 血量
                    fv.maxAnger = 100; // 100 怒气值
                    [self compressFighterVo:fv toData:encoder];
                    [fv release];
                    
                    // 对手用户信息
                    UserInfo *opponentInfo = [[UserInfo alloc] init];
                    opponentInfo.userId = kMockOpponentUserId;
                    opponentInfo.name = @"匿名玩家";
                    opponentInfo.sex = 0;
                    opponentInfo.currentMap = @"家";
                    opponentInfo.silver = 200;
                    opponentInfo.gold = 100;
                    opponentInfo.diamond = 30000;
                    opponentInfo.avatar = @"";
                    [self compressUserInfo:opponentInfo toData:encoder];
                    
                    // 对手战士信息
                    // 对手出战3个英雄
                    [encoder writeInt32:3];
                    fv = [[FighterVo alloc] init];
                    fv.userId = kMockOpponentUserId;
                    fv.heroId = 2001; // 英雄标识
                    fv.heroType = 4;
                    fv.team = 1; // 对手阵营
                    fv.name = @"董卓";
                    fv.sex = 0; // 男性
                    fv.head = 1; //
                    fv.fashion = 1;
                    fv.maxHp = 300; // 300 血量
                    fv.maxAnger = 100; // 100 怒气值
                    [self compressFighterVo:fv toData:encoder];
                    [fv release];
                    
                    // 第2个武将
                    fv = [[FighterVo alloc] init];
                    fv.userId = kMockOpponentUserId;
                    fv.heroId = 2002; // 英雄标识
                    fv.heroType = 5;
                    fv.team = 0; // 玩家阵营
                    fv.name = @"吕布";
                    fv.sex = 0; // 男性
                    fv.head = 1; //
                    fv.fashion = 1;
                    fv.maxHp = 500; // 300 血量
                    fv.maxAnger = 200; // 100 怒气值
                    [self compressFighterVo:fv toData:encoder];
                    [fv release];
                    
                    // 第3个武将
                    fv = [[FighterVo alloc] init];
                    fv.userId = kMockOpponentUserId;
                    fv.heroId = 2003; // 英雄标识
                    fv.heroType = 6;
                    fv.team = 1; // 对手阵营
                    fv.name = @"华雄";
                    fv.sex = 0; // 男性
                    fv.head = 1; //
                    fv.fashion = 1;
                    fv.maxHp = 200; // q00 血量
                    fv.maxAnger = 100; // 100 怒气值
                    [self compressFighterVo:fv toData:encoder];
                    [fv release];
                
                    
                    [self performSelector:@selector(receiveData:) withObject:response afterDelay:0.5f];
                    break;
                }
                    
                // 请求战斗
                case 2:
                {
                    // 返回server_action_init_stones
                    NSMutableData *response = [NSMutableData data];
                    ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:response];
                    
                    [encoder writeInt32:SERVER_ACTION_PVP_INIT_STONES];
                    
                    // 生成玩家宝石列表
                    
                    
                    // 生成对手宝石列表
                    
                    
                    
                    break;
                }
            }
        }
    }
    
}

#pragma mark-
#pragma mark compress

-(void) compressUserInfo:(UserInfo*)user toData:(ServerDataEncoder*)data
{
    [data writeInt64:user.userId];
    [data writeUTF:user.name];
    [data writeUTF:user.currentMap];
    [data writeInt16:user.sex];
    [data writeInt64:user.diamond];
    [data writeInt64:user.silver];
    [data writeInt64:user.gold];
}

-(void) compressFighterVo:(FighterVo*)fv toData:(ServerDataEncoder*)data
{
    [data writeInt64:fv.heroId];
    [data writeInt32:fv.heroType];
    [data writeInt64:fv.userId];
    [data writeInt32:fv.team];
    [data writeUTF:fv.name];
    [data writeInt16:fv.sex];
    [data writeInt32:fv.head];
    [data writeInt32:fv.fashion];
    [data writeInt32:fv.maxHp];
    [data writeInt32:fv.maxAnger];
}

-(void) compressStoneVo:(StoneVo*)sv toData:(ServerDataEncoder*)data
{
    
}

@end
