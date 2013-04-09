//
//  FighterPanel.h
//  XPlan
//
//  Created by Hex on 4/2/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "FighterVo.h"

/// 战斗者面板
@interface FighterPanel : CCNode
{
    CCSprite *fighterPic; // 战斗者头像
    CCSprite *lifepad;
    CCSprite *lifebar;
    
    FighterVo *fighterVo; // 战斗者数据对象
}

/// 初始化
-(id) initWithFighterVo:(FighterVo*)fv;

/// 设置战斗者数据
-(void) setFighterVo:(FighterVo*)fv;

/// 更新生命条
-(void) updateLifeBar;

@end
