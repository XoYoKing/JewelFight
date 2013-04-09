//
//  GameLoadingScene.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

#define kGameLoadingStepCheckVersion 0 // 游戏加载步骤 检查版本
#define kGameLoadingStepUpdateFiles 1 // 游戏加载步骤 加载更新文件

/// 游戏加载场景
@interface GameLoadingScene : CCScene
{
    int state; // 当前状态
    int newState; // 新状态
}

@end
