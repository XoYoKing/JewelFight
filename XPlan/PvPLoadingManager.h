//
//  PvPLoadingManager.h
//  XPlan
//
//  Created by Hex on 4/10/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommandListener.h"

@class PvPController;

/// 加载管理器
@interface PvPLoadingManager : NSObject<CommandListener>
{
    PvPController *controller;
    
}

/// 初始化
-(id) initWithPvPController:(PvPController*)contr;

/// 开始加载
-(void) enterLoading;

/// 退出加载
-(void) exitLoading;


/// 逻辑更新
-(void) update:(ccTime)delta;

@end
