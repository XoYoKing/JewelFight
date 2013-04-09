//
//  ToolBar.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class HudBase;

/// 工具栏
@interface ToolBar : CCNode
{
    HudBase *hud; // 隶属hud
}

/// 初始化工具栏 (因为工具栏会由CocosBuilder自动映射,所以不能用构造函数)
-(void) initialize:(HudBase*)theHud;

@end
