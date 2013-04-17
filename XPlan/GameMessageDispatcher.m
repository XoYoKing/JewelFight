//
//  JewelMessageDispatcher.m
//  XPlan
//
//  Created by Hex on 4/17/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "GameMessageDispatcher.h"
#import "GameMessageListener.h"

static GameMessageDispatcher *_gameMessageDispatcherInstance = nil;

@implementation GameMessageDispatcher

#pragma mark -
#pragma mark Class methods

+(GameMessageDispatcher*) sharedDispatcher
{
    @synchronized([GameMessageDispatcher class])
    {
        if (!_gameMessageDispatcherInstance)
        {
            _gameMessageDispatcherInstance = [[self alloc] init];
        }
    }
    
    return _gameMessageDispatcherInstance;
}

+(id) alloc
{
    @synchronized([GameMessageDispatcher class])
    {
        KITAssert(_gameMessageDispatcherInstance == nil, @"There can only be one GameMessageDispatcher singleton");
        return [super alloc];
    }
    return nil;
}

-(id) init
{
    if ((self = [super init]))
    {
        listenersDict = [[NSMutableDictionary alloc] initWithCapacity:30];
    }
    
    return self;
}

-(void) dealloc
{
    [listenersDict release];
    [super dealloc];
}

///
-(void) addListenerWithMessageId:(int)messageId listener:(id<GameMessageListener>)listener
{
    NSNumber *messageIdNum = [NSNumber numberWithInt:messageId];
    CCArray *listeners = [listenersDict objectForKey:messageIdNum];
    
    // 不存在则新建
    if (listeners == nil)
    {
        listeners = [[CCArray alloc] initWithCapacity:10];
        [listenersDict setObject:listeners forKey:messageIdNum];
        [listeners release];
        listeners = [listenersDict objectForKey:messageIdNum];
    }
    
    // 检查是否在集合中
    if (![listeners containsObject:listener])
    {
        [listeners addObject:listener];
    }
}

-(void) removeListenerWithMessageId:(int)messageId listener:(id<GameMessageListener>)listener
{
    NSNumber *messageIdNum = [NSNumber numberWithInt:messageId];
    CCArray *listeners = [listenersDict objectForKey:messageIdNum];
    [listeners removeObject:listener];
}

/// 获取针对指定动作标识的侦听
-(CCArray*) getListeners:(int)messageId
{
    return [listenersDict objectForKey:[NSNumber numberWithInt:messageId]];
}


-(void) dispatchMessage:(int)messageId object:(id)obj
{
    for (id<GameMessageListener> listener in [self getListeners:messageId])
    {
        [listener handleWithMessageId:messageId object:obj];
    }
}

@end
