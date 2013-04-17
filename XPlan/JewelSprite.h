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

@class JewelVo,JewelPanel,JewelCell;

#define kJewelItemStateIdle 0 // 默认状态
#define kJewelItemStateMoving 1 // 移动状态

#define kJewelItemActionMove 50 // 宝石在移动

/// 宝石节点
@interface JewelSprite : CCSprite
{
    JewelPanel *jewelPanel; // 隶属宝石面板
    JewelVo *jewelVo; // 对应宝石数据
    NSMutableDictionary *effects; // 宝石效果
    BOOL isBack; // ??
    int state; // 状态
    int newState; // 新状态
}

/// 宝石面板
@property (readonly,nonatomic) JewelPanel *jewelPanel;

/// 宝石全局标识
@property (readonly,nonatomic) int globalId;

/// 宝石数据
@property (readonly,nonatomic) JewelVo *jewelVo;

/// 所处坐标
@property (readwrite,nonatomic) CGPoint coord;

@property (readonly,nonatomic) JewelCell *cell;

/// 宝石状态
@property (readwrite,nonatomic) int state;

/// 宝石新状态
@property (readwrite,nonatomic) int newState;

/// 初始化
-(id) initWithJewelPanel:(JewelPanel*)thePanel jewelVo:(JewelVo*)sd;

#pragma mark -
#pragma mark Status

/// 是否准备移除
-(BOOL) isReadyToBeRemoved;


/// 逻辑更新
-(BOOL) update:(ccTime)delta;


/// 指定效果标识的火焰方块燃烧动画
-(void) animateFire:(int)effectId;

/// 指定效果标识的宝石消除动画
-(void) animateEliminate:(int)effectId;

/// 死局,下落到最底部
-(void) moveToDead;

#pragma mark -
#pragma mark Effects

-(void) addEffects;

-(void) addEffect:(EffectSprite*)effect withKey:(NSString*)key;

-(void) deleteEffectWithKey:(NSString*)key;

/// 清除全部特效
-(void) detatchEffects;

@end
