//
//  FighterStonePanel.h
//  XPlan
//
//  Created by Hex on 4/7/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"
#import "StonePanel.h"
#import "FighterVo.h"

/// 战士宝石面板
@interface FightStonePanel : CCNode
{
    CCLabelBMFont *nameLabel; // 名称标签
    StonePanel *stonePanel; // 宝石面板
    int team; // 队伍 0 正方, 1 敌方
    FighterVo *fighterVo; // 战士信息
}

/// 宝石面板
@property (readonly,nonatomic) StonePanel *stonePanel;

/// 阵营
@property (readonly,nonatomic) int team;

/// 初始化
-(id) initWithTeam:(int)t;

/// 更换战士
-(void) initializeWithFighter:(FighterVo*)fv;

@end
