//
//  HudBase.h
//  XPlan
//
//  Created by Hex on 4/1/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

/// hud基类
@interface HudBase : CCLayer

/// 打开背包对话框
-(void) openBagWindow;

/// 打开技能对话框
-(void) openSkillWindow;

/// 打开任务对话框
-(void) openTaskWindow;

/// 打开公会对话框
-(void) openGuildWindow;

/// 打开商店对话框
-(void) openShopWindow;

@end
