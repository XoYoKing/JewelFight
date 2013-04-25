//
//  MockGameServer.h
//  XPlan
//
//  Created by Hex on 4/11/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GameServer.h"

@class UserInfo,FighterVo,GemVo,ServerDataEncoder;

/// 假冒游戏服务器
@interface MockGameServer : GameServer

#pragma mark-
#pragma mark compress

+(void) compressUserInfo:(UserInfo*)user toData:(ServerDataEncoder*)data;

+(void) compressFighterVo:(FighterVo*)fv toData:(ServerDataEncoder*)data;

+(void) compressJewelVo:(GemVo*)jv toData:(ServerDataEncoder*)data;

@end
