//
//  BaseCommand.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "ServerConnection.h"
#import "ServerDataDecoder.h"
#import "CommandListener.h"

@class GameServer;

/// 服务端命令基类
@interface BaseCommand : NSObject
{
    NSMutableDictionary *listenersDict; // 命令侦听者
}


/// 添加服务端响应侦听对象
-(void) addListenerWithActionId:(int)actionId listener:(id<CommandListener>)listener;

/// 删除服务端响应侦听对象
-(void) removeListenerWithActionId:(int)actionId listener:(id<CommandListener>)listener;

/// 获取针对指定动作标识的侦听
-(CCArray*) getListeners:(int)actionId;

/// 回复服务端命令侦听者
-(void) responseToListenerWithActionId:(int)actionId object:(id)obj;

/// 清理侦听者
-(void) clean;

/// 响应服务器端返回数据
-(void) executeWithActionId:(int)actionId data:(ServerDataDecoder*)data;

/// 游戏循环更新
-(void) update:(ccTime)delta;

@end
