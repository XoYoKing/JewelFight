//
//  StoneNode.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "EffectSprite.h"

@class JewelVo,StonePanel;

#define kStoneItemStateIdle 0 // 默认状态
#define kStoneItemStateMoving 1 // 移动状态

#define kStoneItemActionMove 50 // 宝石在移动

/// 宝石节点
@interface StoneSprite : CCNode
{
    StonePanel *stonePanel; // 隶属宝石面板
    NSString *jewelId; // 宝石标识
    JewelVo *stoneVo; // 对应宝石数据
    EffectSprite *clip; // 宝石位图
    EffectSprite *specialClip; // 特殊宝石效果
    NSMutableDictionary *effects; // 宝石效果
    BOOL initAnimation; // 是否播放初始动画
    CGPoint coord; // 所处坐标
    CGSize stoneSize; // 宝石大小
    BOOL isPlaying; // 是否正在播放
    BOOL isBack;
    
    int state; // 状态
}

/// 宝石面板
@property (readonly,nonatomic) StonePanel *stonePanel;

/// 宝石标识
@property (readwrite,nonatomic,retain) NSString *jewelId;

/// 宝石数据
@property (readonly,nonatomic) JewelVo *stoneVo;

/// 所处坐标
@property (readonly,nonatomic) CGPoint coord;

/// 宝石大小
@property (readonly,nonatomic) CGSize stoneSize;

/// 宝石状态
@property (readwrite,nonatomic) int state;

/// 初始化
-(id) initWithStonePanel:(StonePanel*)thePanel stoneVo:(JewelVo*)sd;

/// 逻辑更新
-(BOOL) update:(ccTime)delta;

/// 死局,下落到最底部
-(void) moveToDead;


@end
