//
//  OpponentStonePanel.h
//  XPlan
//
//  Created by Hex on 4/9/13.
//  Copyright (c) 2013 Hex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iPhoneGameKit.h"


@class UserInfo,FighterVo,ViewStonePanel;
@interface PvPOpponentStonePanel : CCLayer
{
    ViewStonePanel *stonePanel; // 宝石面板
}

/// 设置对手信息
-(void) setOpponent:(UserInfo*)opp;

/// 设置战士信息
-(void) setFighter:(FighterVo*)fv;

@end
