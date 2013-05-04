//
//  HSResource.h
//  NationalInvasion
//
//  Created by Hex on 1/5/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "iPhoneGameKit.h"

@interface KITProfile : NSObject
{
    /// 记录配置信息
    NSDictionary* configDict;
    
    /// 当前正在播放的声音
    ALuint currentSound;
    
}

/// 获取指定名称的资源
+(KITProfile*) profileWithName:(NSString*)name;

+(void) purge;

/// 构造
-(id) initWithConfig:(NSDictionary*)_config;

/// Returns all the default attribute keys
-(NSArray*) allAttributeKeys;

/// Returns the default attribute for the given key
-(id) attributeForKey:(NSString*)key;

/// 获取指定键对应的文本
-(NSString*) literalForKey:(NSString*)key;

/// Returns the sprite frame for the given key
-(CCSpriteFrame*) spriteFrameForKey:(NSString*)key;

/// Returns the sprite frame for the given key and index
-(CCSpriteFrame*) spriteFrameForKey:(NSString*)key index:(int)index;

/// Returns the animation for a given key
-(CCAnimation*) animationForKey:(NSString*)key;

/// Returns the animation for a given key and index
-(CCAnimation*) animationForKey:(NSString*)key index:(int)index;

/// Returns YES if the profile has an animation for the given key
-(BOOL) hasAnimation:(NSString*)key;

/// Plays a sound by key
-(void) playSound:(NSString*)key;

/// Plays a sound by key, at a given distance squared
-(void) playSound:(NSString*)key distanceSQ:(float)distanceSQ;

/// Plays a sound by key, given detailed parameters
-(void) playSound:(NSString*)key volume:(float)volume pan:(float)pan pitch:(float)pitch solo:(BOOL)solo;

-(void) playSoundSolo:(NSString*)key;

@end
