//
//  BaseCommand.m
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "BaseCommand.h"
#import "CommandListener.h"

@interface BaseCommand()

@end

@implementation BaseCommand

-(id) init
{
    if ((self = [super init]))
    {
        listenersDict = [[NSMutableDictionary alloc] initWithCapacity:10];
    }
    
    return self;
}

-(void) dealloc
{
    [listenersDict release];
    [super dealloc];
}

/// 
-(void) addListenerWithActionId:(int)actionId listener:(id<CommandListener>)listener
{
    NSNumber *actionIdNum = [NSNumber numberWithInt:actionId];
    CCArray *listeners = [listenersDict objectForKey:actionIdNum];
    
    // 不存在则新建
    if (listeners == nil)
    {
        listeners = [[CCArray alloc] initWithCapacity:10];
        [listenersDict setObject:listeners forKey:actionIdNum];
        [listeners release];
        listeners = [listenersDict objectForKey:actionIdNum];
    }
    
    // 检查是否在集合中
    if (![listeners containsObject:listener])
    {
        [listeners addObject:listener];
    }
}

-(void) removeListenerWithActionId:(int)actionId listener:(id<CommandListener>)listener
{
    NSNumber *actionIdNum = [NSNumber numberWithInt:actionId];
    CCArray *listeners = [listenersDict objectForKey:actionIdNum];
    [listeners removeObject:listener];
}

/// 获取针对指定动作标识的侦听
-(CCArray*) getListeners:(int)actionId
{
    return [listenersDict objectForKey:[NSNumber numberWithInt:actionId]];
}

-(void) responseToListenerWithActionId:(int)actionId object:(id)obj
{
    for (id<CommandListener> listener in [self getListeners:actionId])
    {
        [listener responseWithActionId:actionId object:obj];
    }
}

/// 清理侦听者
-(void) clean
{
    [listenersDict removeAllObjects];
}


-(void) update:(ccTime)delta
{
    
}


/// 连接关闭
- (void)connectionClosed:(ServerConnection*)connection
{
    
}

/// 连接获得数据
- (void)connection:(ServerConnection*)connection receiveData:(NSData*)data
{
    
}

@end
