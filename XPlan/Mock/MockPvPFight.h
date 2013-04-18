//
//  MockPvPServer.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MockPvPFightUser.h"
#import "ServerDataDecoder.h"

@class MockGameServer;

/// 仿冒PvP服务器
@interface MockPvPFight : NSObject
{
    MockGameServer *server;
    MockPvPFightUser *fightUser1;
    MockPvPFightUser *fightUser2;
}

@property (readonly,nonatomic) MockPvPFightUser *fightUser1;

@property (readonly,nonatomic) MockPvPFightUser *fightUser2;

-(id) initWithServer:(MockGameServer*)s;

/// 处理请求
-(void) handleRequestWithMethod:(int)method data:(ServerDataDecoder*)requestData;

@end
