//
//  TaskCondition.h
//  XPlan
//
//  Created by Hex on 3/31/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 任务目标
@interface TaskObjective : NSObject
{
    NSString *targetId; // 任务目标标识
    int type; // 任务目标类型
    int count; // 目标当前完成量
    int goal; // 目标总数量
    BOOL isComplete; // 是否完成
}

/// 任务目标标识
@property (readwrite,nonatomic,retain) NSString *targetId;

/** 
 任务目标类型
 没有统计 0;
 收集类   1;
 杀怪     2;
 杀人     3;
 收集金币 4;
 强化     5;
 声望     6;
 升级     7;
 使用     8;
 */
@property (readwrite,nonatomic) int type;

/// 目标当前完成量
@property (readwrite,nonatomic) int count;

/// 需要达到的目标
@property (readwrite,nonatomic) int goal;

@end
