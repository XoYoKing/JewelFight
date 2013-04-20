//
//  ServerConnection.h
//  XPlan
//
//  Created by Hex on 3/30/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class ServerConnection;

/// 服务器连接响应接口
@protocol ServerConnectionDelegate

/// 连接关闭
- (void)connectionClosed:(ServerConnection*)connection;

/// 连接获得数据
- (void)receiveData:(NSData*)data;

@end

/// 服务器连接
@interface ServerConnection : NSObject
{
    NSString *server; // 对应服务器名称
    NSString *host; // 地址
    uint16_t port; // 端口
    id<ServerConnectionDelegate> delegate; // 代理
    BOOL connected; // 是否连接成功
}

/// 对应服务器
@property (readonly,nonatomic) NSString *server;

/// 地址
@property (readonly,nonatomic) NSString *host;

/// 端口
@property (readonly,nonatomic) uint16_t port;

/// 初始化
-(id) initWithServer:(NSString*)s host:(NSString*)h port:(uint16_t)p delegate:(id<ServerConnectionDelegate>)l;

/// 连接
-(void) connect;

/// 断开连接
-(void) disconnect;

/// 发送NSData
-(void) sendData:(NSData*)data;

@end
