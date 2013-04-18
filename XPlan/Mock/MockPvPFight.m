//
//  MockPvPServer.m
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "MockPvPFight.h"
#import "FighterVo.h"
#import "Constants.h"
#import "MockGameServer.h"
#import "GameController.h"
#import "UserInfo.h"
#import "PlayerInfo.h"
#import "MockConstants.h"
#import "ServerDataDecoder.h"
#import "ServerDataEncoder.h"
#import "MockGameServer.h"

@implementation MockPvPFight

@synthesize fightUser1,fightUser2;

-(id) initWithServer:(MockGameServer*)s
{
    if ((self = [super init]))
    {
        server = s;
        
        // 初始化玩家部分信息
        fightUser1 = [[MockPvPFightUser alloc] init];
        fightUser1.userInfo = [GameController sharedController].player;
        
        FighterVo *fv = [[FighterVo alloc] init];
        fv.userId = fightUser1.userInfo.userId;
        fv.heroId = 1001; // 英雄标识
        fv.heroType = 1; // 张飞
        fv.team = 0; // 玩家阵营
        fv.name = @"张飞";
        fv.sex = 0; // 男性
        fv.head = 1; //
        fv.fashion = 1;
        fv.maxHp = 300; // 300 血量
        fv.maxAnger = 100; // 100 怒气值
        [fightUser1.fighters addObject:fv];
        [fv release];
        
        // 第2个武将
        fv = [[FighterVo alloc] init];
        fv.userId = fightUser1.userInfo.userId;
        fv.heroId = 1002; // 英雄标识
        fv.heroType = 2;
        fv.team = 0; // 玩家阵营
        fv.name = @"关羽";
        fv.sex = 0; // 男性
        fv.head = 1; //
        fv.fashion = 1;
        fv.maxHp = 500; // 300 血量
        fv.maxAnger = 200; // 100 怒气值
        [fightUser1.fighters addObject:fv];
        [fv release];
        
        // 第3个武将
        fv = [[FighterVo alloc] init];
        fv.userId = fightUser1.userInfo.userId;
        fv.heroId = 1003; // 英雄标识
        fv.heroType = 3;
        fv.team = 0; // 玩家阵营
        fv.name = @"刘备";
        fv.sex = 0; // 男性
        fv.head = 1; //
        fv.fashion = 1;
        fv.maxHp = 200; // q00 血量
        fv.maxAnger = 100; // 100 怒气值
        [fightUser1.fighters addObject:fv];
        [fv release];
        
        // 对手用户信息
        fightUser2 = [[MockPvPFightUser alloc] init];
        fightUser2.userInfo.userId = kMockOpponentUserId;
        fightUser2.userInfo.name = @"匿名玩家";
        fightUser2.userInfo.sex = 0;
        fightUser2.userInfo.currentMap = @"家";
        fightUser2.userInfo.silver = 200;
        fightUser2.userInfo.gold = 100;
        fightUser2.userInfo.diamond = 30000;
        fightUser2.userInfo.avatar = @"";
        
        // 对手战士信息
        // 对手出战3个英雄
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
        [fightUser2.fighters addObject:fv];
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
        [fightUser2.fighters addObject:fv];
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
        [fightUser2.fighters addObject:fv];
        [fv release];
        
        
    }
    
    return self;
}

-(void) dealloc
{
    [super dealloc];
}

-(void) handleRequestWithMethod:(int)method data:(ServerDataDecoder*)requestData
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
            [encoder writeInt32:fightUser1.fighters.count];
            for (FighterVo *fv in fightUser1.fighters)
            {
                [MockGameServer compressFighterVo:fv toData:encoder];
            }
            
            [MockGameServer compressUserInfo:fightUser2.userInfo toData:encoder];
            
            // 对手战士信息
            // 对手出战3个英雄
            [encoder writeInt32:fightUser2.fighters.count];
            for (FighterVo *fv in fightUser2.fighters)
            {
                [MockGameServer compressFighterVo:fv toData:encoder];
            }
            
            [encoder release];
            
            [server performSelector:@selector(receiveData:) withObject:response afterDelay:0];
            break;
        }
            
        // 请求战斗request_fight
        case 2:
        {
            // 返回server_action_init_jewels
            NSMutableData *response = [NSMutableData data];
            ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:response];
            
            [encoder writeInt32:SERVER_ACTION_PVP_INIT_JEWELS];
            
            [fightUser1 initJewels];
            [fightUser2 initJewels];
            
            // 玩家宝石
            [encoder writeInt32:fightUser1.jewelList.count];
            for (JewelVo *sv in fightUser1.jewelList)
            {
                [MockGameServer compressJewelVo:sv toData:encoder];
            }
            

            // 生成对手宝石列表
            [encoder writeInt32:fightUser2.jewelList.count];
            for (JewelVo *sv in fightUser2.jewelList)
            {
                [MockGameServer compressJewelVo:sv toData:encoder];
            }
            
            [server performSelector:@selector(receiveData:) withObject:response afterDelay:0];
            
            break;
        }
        // 请求战斗开始request_fight_start
        case 3:
        {
            // 允许开始战斗
            NSMutableData *response = [NSMutableData data];
            ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:response];
            
            [encoder writeInt32:SERVER_ACTION_PVP_FIGHT_START];
            
            [encoder release];
            [server performSelector:@selector(receiveData:) withObject:response afterDelay:0];
            break;
        }
        // 请求交换宝石
        case 4:
        {
            long actionId = [requestData readInt64];
            int globalId1 = [requestData readInt32];
            int globalId2 = [requestData readInt32];
            
            [fightUser1 swapJewel1:globalId1 jewel2:globalId2];
            
            break;
        }
        // 请求消除宝石
        case 5:
        {
            long actionId = [requestData readInt64];
            int continueEliminate = [requestData readInt32]; // 连续消除次数
            int eliminateCount = [requestData readInt32]; // 消除宝石数量
            CCArray *elimList = [[CCArray alloc] initWithCapacity:eliminateCount];
            for (int i=0;i<eliminateCount;i++)
            {
                int globalId = [requestData readInt32];
                [elimList addObject:[NSNumber numberWithInt:globalId]];
            }
            
            // 先终结宝石
            [fightUser1 eliminateJewelsWithGlobalIds:elimList];
            [elimList release];
            
            // 再填充宝石
            CCArray *filledList = [[CCArray alloc] initWithCapacity:20];
            [fightUser1 fillEmptyJewels:filledList];
            
            // 响应填充宝石
            NSMutableData *response = [NSMutableData data];
            ServerDataEncoder *encoder = [[ServerDataEncoder alloc] initWithData:response];
            
            [encoder writeInt32:SERVER_ACTION_PVP_ADD_NEW_JEWELS];
            [encoder writeInt64:fightUser1.userInfo.userId]; // 标记给谁更新的
            [encoder writeInt32:filledList.count]; // 标记数量
            for (JewelVo *filledJv in filledList)
            {
                [MockGameServer compressJewelVo:filledJv toData:encoder];
            }
            [filledList release];
            [encoder release];
            [server performSelector:@selector(receiveData:) withObject:response afterDelay:0];
            break;
        }
    }
}




@end
