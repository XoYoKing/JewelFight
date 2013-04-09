//
//  SelfPortrait.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import "PortraitUI.h"
#import "CommandListener.h"

/// 玩家方的战斗者形象
@interface SelfPortrait : PortraitUI<CommandListener>
{
    CCLabelBMFont *levelLabel; // 等级标签
    CCLabelBMFont *nameLabel; // 玩家名字标签
    CCSprite *energyBar; // 体力Bar
    CCSprite *expBar; // 经验值Bar
    CCSprite *portraitBg; // 背景
}


@end
