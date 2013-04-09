//
//  GameServer.h
//  XPlan
//
//  Created by Hex on 3/29/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerConnection.h"
#import "GameCommand.h"
#import "TaskCommand.h"
#import "LoginCommand.h"
#import "ChatCommand.h"
#import "BagCommand.h"
#import "PvPFightCommand.h"


/// 服务器连接
@interface GameServer : NSObject<ServerConnectionDelegate>
{
    NSMutableDictionary *servers; // 服务器集合
    GameCommand *gameCommand; // 游戏主命令处理器
    PvPFightCommand *fightCommand; // 战斗命令处理器
    BagCommand *bagCommand; // 背包命令处理器
    LoginCommand *loginCommand; // 登陆注册命令处理器
    ChatCommand *chatCommand; // 聊天命令处理器
    TaskCommand *taskCommand; // 任务命令处理器
}

/// 游戏主命令处理器
@property (readonly,nonatomic) GameCommand *gameCommand;

/// 战斗命令处理器
@property (readonly,nonatomic) PvPFightCommand *fightCommand;

/// 背包命令处理器
@property (readonly,nonatomic) BagCommand *bagCommand;

/// 登陆注册命令处理器
@property (readonly,nonatomic) LoginCommand *loginCommand;

/// 聊天命令处理器
@property (readonly,nonatomic) ChatCommand *chatCommand;

/// 任务命令处理器
@property (readonly,nonatomic) TaskCommand *taskCommand;

/// 初始化
-(id) init;

/// 发送信息
-(void) send:(NSString*)server data:(NSData*)data;

/// 检查服务器是否已经连接
-(BOOL) checkConnected:(NSString*)server;

/// 注册服务器
-(ServerConnection*) registerServer:(NSString*)server host:(NSString*)host port:(uint)port delegate:(id)delegate;

/// 注销掉服务器连接
-(void) removeServer:(NSString*)server;

@end
