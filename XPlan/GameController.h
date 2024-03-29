//
//  GameController.h
//  XPlan
//
//  Created by Hex on 3/27/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class GameServer,GameCommand,BagCommand,PvPCommand,PlayerInfo,PvPController;

/// 游戏控制器
@interface GameController : NSObject
{
    GameServer *server; // 游戏服务器连接
    PlayerInfo *player; // 玩家信息
    int sessionId; // 回话标识
    int state; // 游戏状态
}

/// 服务器连接
@property (readonly,nonatomic) GameServer *server;

/// 玩家信息
@property (readwrite,nonatomic,retain) PlayerInfo *player;

/// 会话标识
@property (readwrite,nonatomic) int sessionId;

/// 游戏状态
@property(readwrite,nonatomic) int state;

/// 
+(GameController*) sharedController;

/// 初始化
-(void) initialize;

/// 执行首次运行场景
-(void) runFirstRunScene;

/// 执行主城场景
-(void) runHomeScene;

/// 执行战斗场景
-(void) runPvPScene;

/// 获取宝石配置信息
-(KITProfile*) getJewelProfileWithType:(NSString*)jewelType;

@end
