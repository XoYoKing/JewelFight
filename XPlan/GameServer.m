//
//  GameServer.m
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GameServer.h"
#import "GCDAsyncSocket.h"
#import "Constants.h"
#import "ServerDataDecoder.h"

@implementation GameServer

@synthesize gameCommand,loginCommand,taskCommand,chatCommand,pvpCommand,bagCommand;


-(id) init
{
    if ((self = [super init]))
    {
        // 初始化连接
        servers = [[NSMutableDictionary alloc] initWithCapacity:5];
        gameCommand = [[GameCommand alloc] init];
        pvpCommand = [[PvPCommand alloc] init];
        bagCommand = [[BagCommand alloc] init];
        loginCommand = [[LoginCommand alloc] init];
        chatCommand = [[ChatCommand alloc] init];
        taskCommand = [[TaskCommand alloc] init];
    }
    
    return self;
}

-(void) dealloc
{
    [servers release];
    [gameCommand release];
    [bagCommand release];
    [loginCommand release];
    [chatCommand release];
    [taskCommand release];
    [super dealloc];
}

-(ServerConnection*) registerServer:(NSString *)server host:(NSString *)host port:(uint)port
{
    ServerConnection *connection = [servers objectForKey:server];
    if (!connection)
    {
        connection = [[ServerConnection alloc] initWithServer:server host:host port:port delegate:self];
        [servers setObject:connection forKey:server];
        [connection release];
        connection = [servers objectForKey:server];
        [connection connect];
    }
    
    return connection;
}

-(void) removeServer:(NSString *)server
{
    ServerConnection *connection = [servers objectForKey:server];
    if (connection)
    {
        [connection disconnect];
    }
    
    [servers removeObjectForKey:server];
}

-(void) connectionClosed:(ServerConnection *)connection
{
    
}

-(void) send:(NSString *)server data:(NSData *)data
{
    ServerConnection *connection = [servers objectForKey:server];
    if (!connection)
    {
        KITLog(@"服务器没有注册或者已关闭");
        return;
    }
    
    [connection sendData:data];
}

-(void) receiveData:(NSData *)data
{
    if ([data length] <= 3)
    {
        KITLog(@"心跳信息");
        return;
    }
    
    // 声明一个服务器端数据解码器
    ServerDataDecoder *decoder = [[[ServerDataDecoder alloc] initWithData:data] autorelease];
    
    // 获取actionId
    int32_t actionId = [decoder readInt32];
    
    // 错误命令
    if (actionId == SERVER_ACTION_ERROR_MESSAGE)
    {
        // 处理错误信息
    }
    
    // 游戏主命令
    if (actionId< 50)
    {
        [gameCommand executeWithActionId:actionId data:decoder];
    }
    else if (actionId >= 50 && actionId < 100)
    {
        [pvpCommand executeWithActionId:actionId data:decoder];
    }
    // 背包命令
    else if (actionId >= 100 && actionId < 150)
    {
        [bagCommand executeWithActionId:actionId data:decoder];
        return;
    }
    
    // 任务命令
    else if (actionId >=150 && actionId < 200)
    {
        [taskCommand executeWithActionId:actionId data:decoder];
        return;
    }
    
    // 聊天命令
    else if (actionId >= 500 && actionId < 800)
    {
        [chatCommand executeWithActionId:actionId data:decoder];
        return;
    }
    else if (actionId >= 800 && actionId < 900)
    {
        [pvpCommand executeWithActionId:actionId data:decoder];
    }
}


@end
