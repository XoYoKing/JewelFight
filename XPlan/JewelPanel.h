//
//  JewelPanel.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "EffectSprite.h"

@class JewelSprite,JewelVo,JewelController,JewelCell,JewelAction;

/// 宝石面板
@interface JewelPanel : CCLayer
{
    CCSpriteBatchNode *jewelBatchNode; // 宝石层
    CCLayer *effectLayer; // 效果层
    
    JewelController *jewelController; // 宝石面板控制器
    NSMutableDictionary *allJewelSpriteDict; // 宝石字典
    CCArray *allJewelSprites; // 宝石集合
    CCArray *cellGrid; // 宝石格子
    CGSize totalSize; // 总像素宽高
    CGSize gridSize; // 格子数量宽高
    CGSize cellSize; // 宝石地格像素宽高
    int continueDispose; // 连续消除次数
    BOOL isControlEnabled; // 是否玩家可触摸操作
}

/// 连续消除次数
@property (readwrite,nonatomic) int continueDispose;

/// 格子宽高数量
@property (readonly,nonatomic) CGSize gridSize;

/// 格子宽高
@property (readonly,nonatomic) CGSize cellSize;

/// 玩家是否可触摸操作
@property (readwrite,nonatomic) BOOL isControlEnabled;

/// 宝石控制器
@property (readwrite,nonatomic,assign) JewelController *jewelController;

/// 初始化
-(id) init;


/// 添加效果
-(void) addEffectSprite:(EffectSprite*)effectSprite;

#pragma mark -
#pragma mark JewelSprite

-(JewelSprite*) getJewelSpriteWithGlobalId:(int)globalId;

/// 创建宝石
-(JewelSprite*) createJewelSpriteWithJewelVo:(JewelVo*)jewelVo;

/// 添加宝石
-(void) addJewelSprite:(JewelSprite*)jewelSprite;

/// 删除宝石
-(void) removeJewelSprite:(JewelSprite*)jewelSprite;

/// 删除全部宝石
-(void) removeAllJewels;

/// 清理全部宝石
-(void) clearAllJewelSprites;

#pragma mark -
#pragma mark JewelCell

/// 获取指定坐标的宝石格子
-(JewelCell*) getCellAtCoord:(CGPoint)coord;

/// 获取指定像素的宝石格子
-(JewelCell*) getCellAtPosition:(CGPoint)position;

/// 将像素转变为坐标
-(CGPoint) positionToCellCoord:(CGPoint)pos;

-(CGPoint) cellCoordToPosition:(CGPoint)coord;

#pragma mark -
#pragma mark Add Jewel Methods

/// 添加新宝石列表
-(void) addNewJewelsWithActionId:(long)actionId continueDispose:(int)continueDispose voList:(CCArray*)list;

/// 添加新宝石列表
-(void) addNewJewelsWithJewelVoList:(CCArray*)list;


/// 宝石消除
-(void) disposeJewelsWithJewelVoList:(CCArray*)disList specialType:(int)specialType specialJewelVoList:(CCArray*)speList;


/// 逻辑更新
-(void) update:(ccTime)delta;

#pragma mark -
#pragma mark Jewel Action

-(void) queueAction:(JewelAction*)action top:(BOOL)top;

-(void) resetActions;


@end
