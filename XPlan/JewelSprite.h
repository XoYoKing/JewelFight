//
//  JewelNode.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "EffectSprite.h"

@class JewelVo,JewelBoard,JewelCell;

typedef enum JewelSpriteStates
{
    kJewelSpriteStateIdle=0, // 默认状态
    kJewelSpriteStateMoving, // 移动状态
    kJewelSpriteActionMove // 宝石在移动
}JewelSpriteStates;


/// 宝石节点
@interface JewelSprite : CCSprite
{
    JewelBoard *jewelBoard; // 隶属宝石面板
    JewelVo *jewelVo; // 对应宝石数据
    NSMutableDictionary *effects; // 宝石效果
    BOOL isBack; // ??
    BOOL eliminateTop; // 消除上方宝石
    BOOL eliminateRight; // 消除右方宝石
    int state; // 状态
    int newState; // 新状态
}

/// 宝石面板
@property (readonly,nonatomic) JewelBoard *jewelBoard;

/// 宝石全局标识
@property (readonly,nonatomic) int globalId;

/// 宝石数据
@property (readonly,nonatomic) JewelVo *jewelVo;

@property (readonly,nonatomic) int jewelId;

/// 所处坐标
@property (readwrite,nonatomic) CGPoint coord;

@property (readonly,nonatomic) JewelCell *cell;

/// 消除上方宝石
@property (readwrite,nonatomic) BOOL eliminateTop;

/// 消除右侧宝石
@property (readwrite,nonatomic) BOOL eliminateRight;

/// 宝石状态
@property (readwrite,nonatomic) int state;

/// 宝石新状态
@property (readwrite,nonatomic) int newState;

/// 初始化
-(id) initWithJewelBoard:(JewelBoard*)thePanel jewelVo:(JewelVo*)sd;

#pragma mark -
#pragma mark Status

/// 是否准备移除
-(BOOL) isReadyToBeRemoved;


/// 逻辑更新
-(BOOL) update:(ccTime)delta;


/// 指定效果标识的火焰方块燃烧动画
-(void) fire:(int)effectId;

/// 指定效果标识的宝石消除动画
-(void) eliminate:(int)effectId;

/// 死局,下落到最底部
-(void) moveToDead;

/// 掉落
-(void) drop;

/// 是否正在下落
-(BOOL) isDropping;

#pragma mark -
#pragma mark Effects

-(void) addEffects;

-(void) addEffect:(EffectSprite*)effect withKey:(NSString*)key;

-(void) deleteEffectWithKey:(NSString*)key;

/// 清除全部特效
-(void) detatchEffects;

@end
