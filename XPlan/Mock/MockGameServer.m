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
#import "JewelVo.h"
#import "UserInfo.h"
#import "PlayerInfo.h"
#import "HeroVo.h"
#import "GameController.h"
#import "JewelFactory.h"
#import "MockConstants.h"
#import "MockPvPFight.h"

@interface MockGameServer()
{
    MockPvPFight *pvpFight;
}

@end

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
        [GameController sharedController].player = player;
        [player release];
        
        // 初始化pvp战斗
        pvpFight = [[MockPvPFight alloc] initWithServer:self];
        
        
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
            [pvpFight handleRequestWithMethod:method data:decoder];
        }
    }
    
    [decoder release];
}

#pragma mark-
#pragma mark compress

+(void) compressUserInfo:(UserInfo*)user toData:(ServerDataEncoder*)data
{
    [data writeInt64:user.userId];
    [data writeUTF:user.name];
    [data writeUTF:user.currentMap];
    [data writeInt16:user.sex];
    [data writeInt64:user.diamond];
    [data writeInt64:user.silver];
    [data writeInt64:user.gold];
}

+(void) compressFighterVo:(FighterVo*)fv toData:(ServerDataEncoder*)data
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

+(void) compressJewelVo:(JewelVo*)jv toData:(ServerDataEncoder*)data
{
    [data writeInt32:jv.globalId];
    [data writeInt32:jv.jewelId];
    [data writeInt32:jv.jewelType];
    [data writeInt32:jv.coord.x];
    [data writeInt32:jv.coord.y];
    [data writeInt16:jv.state];
}

@end
