//
//  JewelController.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class JewelBoard,JewelVo,JewelActionQueue,JewelAction,JewelBoardData;

/// 宝石控制器
@interface JewelController : NSObject
{
    long userId; // 操作者用户标识
    int score; // 得分
    JewelBoardData *boardData; // 宝石面板数据
    JewelBoard *board; //对应宝石面板
    
    // action
    JewelActionQueue *actionQueue; // 操作宝石动作队列
    JewelAction *currentAction; // 当前宝石动作
    
    int boardWidth; // 宽度
    int boardHeight; // 高度
}

/// 操作者用户标识
@property (readonly,nonatomic) long userId;

/// 得分
@property (readonly,nonatomic) int score;

/// 宝石数据
@property (readonly,nonatomic) JewelBoardData *boardData;

/// 宝石面板
@property (readonly,nonatomic,assign) JewelBoard *board;

@property (readwrite,nonatomic) int boardWidth;

@property (readwrite,nonatomic) int boardHeight;



/// 初始化
-(id) initWithJewelBoard:(JewelBoard*)jb operatorUserId:(long)uId;

#pragma mark -
#pragma mark Status

/// 是否玩家在操作
-(BOOL) isPlayerControl;

///
-(int) addScore:(int)value;

#pragma mark -
#pragma mark Jewel Actions

-(void) update:(ccTime)delta;

/// 更新宝石动作
-(void) updateJewelActions:(ccTime)delta;

-(void) queueAction:(JewelAction*)action top:(BOOL)top;

-(void) resetActions;

-(void) newJewelVoList:(CCArray*)list;

-(void) addJewelVoList:(CCArray*)list;


@end
