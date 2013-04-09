//
//  ServerConnection.m
//  XPlan
//
//  Created by Hex on 3/30/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "ServerConnection.h"
#import "GCDAsyncSocket.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "DDASLLogger.h"

// Log levels: off, error, warn, info, verbose
static const int ddLogLevel = LOG_LEVEL_VERBOSE;

#define USE_SECURE_CONNECTION 1
#define ENABLE_BACKGROUNDING  0

// 数据响应头
#define TAG_FIXED_LENGTH_HEADER 1

// 数据响应正文
#define TAG_RESPONSE_BODY 2

@interface ServerConnection()
{
    GCDAsyncSocket *asyncSocket; // 异步socket
}

@end

@implementation ServerConnection

-(id) initWithServer:(NSString *)s host:(NSString *)h port:(uint16_t)p delegate:(id<ServerConnectionDelegate>)l
{
    if ((self = [super init]))
    {
        server = [s retain]; // 服务器名称
        host = [h retain]; // 服务器地址
        port = p; // 端口号
        delegate = l; // 代理对象

        // 日志
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [DDLog addLogger:[DDASLLogger sharedInstance]];
        
        // 初始化异步socket
        dispatch_queue_t mainQueue = dispatch_get_main_queue();
        asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:mainQueue];
        
        [self connect];
    }
    
    return self;
}

-(void) dealloc
{
    [asyncSocket release];
    [super dealloc];
}

/// 连接
-(void) connect
{
    DDLogInfo(@"Connecting to \"%@\" on port %hu...", host, port);
    
    NSError *error = nil;
    if (![asyncSocket connectToHost:host onPort:port error:&error])
    {
        DDLogError(@"Error connecting: %@", error);
        
        // TODO: 连接失败,该怎么处理?
    }
}

/// 断开连接
-(void) disconnect
{
    [asyncSocket disconnect];
}

#pragma maek Socket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    DDLogInfo(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
    connected = YES; // 标记已经连接
    
    // 开始接收数据
    [sock readDataToLength:sizeof(int) withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
}

- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    DDLogInfo(@"socketDidSecure:%p", sock);
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
	DDLogInfo(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	DDLogInfo(@"socket:%p didReadData:withTag:%ld", sock, tag);
    
    // 读取信息
    if (tag == TAG_FIXED_LENGTH_HEADER)
    {
        // 获取数据包大小
        int bodyLength;
        [data getBytes:&bodyLength length:sizeof(int)];
        
        // 接收数据
        [sock readDataToLength:bodyLength withTimeout:-1 tag:TAG_RESPONSE_BODY];
    }
    else if (tag == TAG_RESPONSE_BODY)
    {
        [delegate connection:self receiveData:data];
        
        // 接收下一条数据
        [sock readDataToLength:sizeof(int) withTimeout:-1 tag:TAG_FIXED_LENGTH_HEADER];
    }
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
	DDLogWarn(@"socketDidDisconnect:%p withError: %@", sock, err);
    
    if (!connected)
    {
        [delegate connectionClosed:self];
        
        // 重新连接
        [self connect];
    }
    
}



@end
