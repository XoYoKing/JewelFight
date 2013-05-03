//
//  JewelBoardData.h
//  XPlan
//
//  Created by Hex on 5/2/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JewelController,JewelVo,JewelCell;

/// 宝石面板数据
@interface JewelBoardData : NSObject
{
    JewelController *jewelController;


    NSMutableDictionary *boardJewelVoDict; // 宝石格子字典
    CCArray *boardJewelVoGrid; // 宝石格子集合
    int boardWidth;
    int boardHeight;
    CCArray *cellGrid; // 宝石格子列表
    float *timeSinceAddInColumn; // 加入到宝石列中后过去的时间
    CCArray *fallingJewelVos; // 下落的宝石集合
    CCArray *possibleEliminates; // 允许消除的宝石列表
    BOOL boardChangedSinceEvaluation; // 面板数据变化标记
    
}

/// 宝石控制器
@property (readonly,nonatomic) JewelController *jewelController;

/// 宝石格子集合
@property (readonly,nonatomic) CCArray *cellGrid;

@property (readonly,nonatomic) NSMutableDictionary *boardJewelVoDict;

@property (readonly,nonatomic) CCArray *boardJewelVoGrid;

/// 下落的宝石数量集合
@property (readonly,nonatomic) CCArray *fallingJewelVos;

/// 宝石列中的宝石数量
@property (readonly,nonatomic) int *numJewelsInColumn;

/// 加入到宝石列中后过去的时间
@property (readonly,nonatomic) float *timeSinceAddInColumn;

/// 面板数据变化标记
@property (readwrite,nonatomic) BOOL boardChangedSinceEvaluation;

/// 初始化宝石面板数据
-(id) initWithJewelController:(JewelController*)jc;

#pragma mark -
#pragma mark JewelVo

/// 添加宝石数据对象
-(void) addJewelVo:(JewelVo *)vo;

/// 删除报数数据对象
-(void) removeJewelVo:(JewelVo *)vo;

/// 删除全部宝石数据对象
-(void) removeAllJewelVos;

/// 获取宝石数据对象
-(JewelVo*) getJewelVoByGlobalId:(int)jewelGlobalId;

/// 寻找可消除的宝石
-(void) findEliminableJewels:(CCArray*)elimList;

/// 检查水平方向的可消除的宝石
-(void) findHorizontalEliminableJewels:(CCArray*)elimList withJewel:(JewelVo*)source;

/// 检查垂直方向的可消除的宝石
-(void) findVerticalEliminableJewels:(CCArray*)elimList withJewel:(JewelVo*)source;

/// 重置上方消除状态
-(void) resetEliminateTop:(JewelVo*)source;

/// 重置右侧消除状态
-(void) resetEliminateRight:(JewelVo*)source;

/// 寻找可消除的宝石
-(CCArray*) findPossibleEliminateJewels;

/// 检查死局
-(BOOL) checkDead;

/// 宝石是否满的
-(BOOL) isJewelFull;

-(void) removeMarkedJewels;

#pragma mark -
#pragma mark JewelCell

/// 获取指定坐标的宝石格子
-(JewelCell*) getCellAtCoord:(CGPoint)coord;

-(void) updateJewelGridInfo;

@end
