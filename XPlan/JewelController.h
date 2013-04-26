//
//  JewelController.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class JewelBoard,JewelVo,GemActionQueue,GemAction;
/// 宝石控制器
@interface JewelController : NSObject
{
    long userId; // 操作者用户标识
    JewelBoard *jewelBoard; //对应宝石面板
    NSMutableDictionary *jewelVoDict; // 宝石格子字典
    CCArray *jewelVoList; // 宝石格子集合
    
    // special
    CCArray *specialList; // 特殊宝石列表
    JewelVo *currentSpecial; // 当前特殊宝石
    
    // action
    GemActionQueue *actionQueue; // 操作宝石动作队列
    GemAction *currentAction; // 当前宝石动作
}

/// 操作者用户标识
@property (readonly,nonatomic) long userId;

/// 宝石面板
@property (readonly,nonatomic,assign) JewelBoard *jewelBoard;

/// 初始化
-(id) initWithGemBoard:(JewelBoard*)panel operatorUserId:(long)uId;

#pragma mark -
#pragma mark Jewel Actions

-(void) update:(ccTime)delta;

/// 更新宝石动作
-(void) updateGemActions:(ccTime)delta;

-(void) queueAction:(GemAction*)action top:(BOOL)top;

-(void) resetActions;

-(void) newGemVoList:(CCArray*)list;

-(void) addJewelVoList:(CCArray*)list;

/// 添加宝石数据
-(void) addGemVo:(JewelVo*)jv;

/// 删除宝石数据
-(void) removeGemVo:(JewelVo*)jv;

/// 填充空白宝石
-(void) fillEmptyGems;

@end
