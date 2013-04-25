//
//  JewelController.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class GemBoard,GemVo,GemActionQueue,GemAction;
/// 宝石控制器
@interface GemController : NSObject
{
    long userId; // 操作者用户标识
    GemBoard *jewelPanel; //对应宝石面板
    NSMutableDictionary *jewelVoDict; // 宝石格子字典
    CCArray *jewelVoList; // 宝石格子集合
    
    // special
    CCArray *specialList; // 特殊宝石列表
    GemVo *currentSpecial; // 当前特殊宝石
    
    // action
    GemActionQueue *actionQueue; // 操作宝石动作队列
    GemAction *currentAction; // 当前宝石动作
}

/// 操作者用户标识
@property (readonly,nonatomic) long userId;

/// 宝石面板
@property (readonly,nonatomic,assign) GemBoard *jewelPanel;

/// 初始化
-(id) initWithJewelPanel:(GemBoard*)panel operatorUserId:(long)uId;

#pragma mark -
#pragma mark Jewel Actions

-(void) update:(ccTime)delta;

/// 更新宝石动作
-(void) updateJewelActions:(ccTime)delta;

-(void) queueAction:(GemAction*)action top:(BOOL)top;

-(void) resetActions;

-(void) newJewelVoList:(CCArray*)list;

-(void) addJewelVoList:(CCArray*)list;

/// 添加宝石数据
-(void) addJewelVo:(GemVo*)jv;

/// 删除宝石数据
-(void) removeJewelVo:(GemVo*)jv;

/// 填充空白宝石
-(void) fillEmptyJewels;

@end
