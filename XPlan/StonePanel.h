//
//  StonePanel.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "EffectSprite.h"

@class StoneSprite,JewelVo,StoneManager,StoneCell,StoneAction;

/// 宝石面板
@interface StonePanel : CCLayer
{
    CCLayer *effectLayer; // 效果层
    
    StoneManager *controller; // 宝石面板控制器
    NSMutableDictionary *allStoneSpriteDict; // 宝石字典
    CCArray *allStoneItems; // 宝石集合
    CCArray *cellGrid; // 宝石格子
    CGSize totalSize; // 总像素宽高
    CGSize gridSize; // 格子数量宽高
    CGSize cellSize; // 宝石地格像素宽高
    
    int continueDispose; // 连续消除次数
}

/// 连续消除次数
@property (readwrite,nonatomic) int continueDispose;

/// 格子宽高数量
@property (readonly,nonatomic) CGSize gridSize;

/// 格子宽高
@property (readonly,nonatomic) CGSize cellSize;

/// 初始化
-(id) init;

/// 添加效果
-(void) addEffectSprite:(EffectSprite*)effectSprite;

#pragma mark -
#pragma mark StoneItem

-(StoneSprite*) getStoneSprite:(NSString*)jewelId;

/// 创建宝石
-(void) createStoneSprite:(JewelVo*)stoneVo;

/// 添加宝石
-(void) addStoneSprite:(StoneSprite*)stoneSprite;

/// 删除宝石
-(void) removeStoneItem:(StoneSprite*)stoneItem;

/// 清理全部宝石
-(void) clearAllStoneSprites;

#pragma mark -
#pragma mark StoneCell

/// 获取指定坐标的宝石格子
-(StoneCell*) getCellAtCoord:(CGPoint)coord;

/// 获取指定像素的宝石格子
-(StoneCell*) getCellAtPosition:(CGPoint)position;

/// 将像素转变为坐标
-(CGPoint) positionToCellCoord:(CGPoint)pos;

-(CGPoint) cellCoordToPosition:(CGPoint)coord;

#pragma mark -
#pragma mark Add Stone Methods

/// 添加新宝石列表
-(void) addNewStonesWithActionId:(long)actionId continueDispose:(int)continueDispose voList:(CCArray*)list;

/// 添加新宝石列表
-(void) addNewStonesWithStoneVoList:(CCArray*)list;


/// 宝石消除
-(void) disposeStonesWithStoneVoList:(CCArray*)disList specialType:(int)specialType specialStoneVoList:(CCArray*)speList;


/// 逻辑更新
-(void) update:(ccTime)delta;

#pragma mark -
#pragma mark Stone Action

-(void) queueAction:(StoneAction*)action top:(BOOL)top;

-(void) resetActions;


@end
