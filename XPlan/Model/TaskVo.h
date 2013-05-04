//
//  TaskVo.h
//  XPlan
//
//  Created by Hex on 3/28/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>

/// 任务数据对象 Value Object
@interface TaskVo : NSObject
{
    NSString *taskId; // 任务标识
    int type; // 任务类型 1:主线 2:循环
    int state; // 任务状态 0:未接受 1:未完成 2:未提交
    
    NSString *name; // 任务名称
    int starLevel; // 任务星级
    int acceptNpcId; // 接受Npc标识
    int acceptRoomId; // 接受npc所在房间
    int finishedNpcId; // 完成NPC 标识
    BOOL canSkip; // 能够跳过任务
    BOOL isAutoAccepted; // 是否自动接受
    

}

@end
