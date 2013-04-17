//
//  JewelMessageDispatcher.h
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "GameMessageListener.h"

/// 宝石消息触发器
@interface GameMessageDispatcher : NSObject
{
    NSMutableDictionary *listenersDict; // 命令侦听者
}

/// 单例
+(GameMessageDispatcher*) sharedDispatcher;

/// 添加消息侦听者
-(void) addListenerWithMessageId:(int)messageId listener:(id<GameMessageListener>)listener;

/// 移除消息侦听者
-(void) removeListenerWithMessageId:(int)messageId listener:(id<GameMessageListener>)listener;

/// 获取针对指定动作标识的侦听
-(CCArray*) getListeners:(int)messageId;

/// 发布消息
-(void) dispatchWithSender:(id)sender message:(int)messageId object:(id)obj;

@end
