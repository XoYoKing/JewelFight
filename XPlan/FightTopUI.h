//
//  FightTopPanel.h
//  XPlan
//
//  Created by Hex on 4/4/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"

@class LeaderPortrait;
@interface FightTopUI : CCNode
{
    LeaderPortrait *leftPortrait;
    LeaderPortrait *rightPortrait;
    CCNode *leftPortraitHolder; // 左侧定位节点
    CCNode *rightPortraitHolder; // 右侧定位节点
}

@end
